%% XDS parameters
% 
% gonna take advantage of our XDS built ins to handle all of the
% conversions

monkey = 'Pancake'; % monkey name
task = 'WM'; % task
array_name = 'left_M1';
ran_by = 'KLB'; % who recorded this?
lab = 6; % upstairs
bin_width = .05; % 50 ms
sorted = 0;
requires_raw_emg = 1; % are we recording EMG here?

params = struct(...
    'monkey_name',monkey,...
    'array_name',array_name,...
    'task_name',task,...
    'ran_by',ran_by,...
    'lab',lab,...
    'bin_width',bin_width,...
    'sorted',sorted,...
    'requires_raw_emg',requires_raw_emg);


%% choosing the file to use
file_name = '20221201_Pancake_WM_001.nev'; % path to training .nev
base_dir = 'C:\data\Pancake\20221201\';

map_dir = 'Z:\limblab\lab_folder\Animal-Miscellany\Pancake_20K2\Surgeries\20210713_Pancake_LeftM1\';
map_name = 'SN 6250-002468 array 1059-12.cmp';
save_dir = 'C:\Users\limblab\Downloads';

xds = raw_to_xds(base_dir, file_name, map_dir, map_name, params);
base_name = strsplit(file_name,'.nev');
save_name = strcat(save_dir, base_name{1}, '_xds.mat');
save(save_name,'xds');

%% parse the xds data
%
% We have to pull the cortical and cursor data out from the xds, and
% place them into a series of cells -- one for each trial

% To start we'll just use the get_rewarded_trials function and see if
% that's sufficient. If not I can write something new that can take care
% of it.
start_time = 'start_time';
[trial_spike_counts, trial_EMG, trial_force, trial_kin, trial_curs, trial_tgt_pos] = ...
    get_rewarded_trials(xds, start_time);

%% clip all of the trials to run the same length
%
min_trial_length = 1000;
[trial_lengths,n_neurons] = cellfun(@size,trial_spike_counts); 
max_trial_length = max(trial_lengths);

% find the average number of neurons -- should be the same for all trials
n_neurons = int32(mean(n_neurons));


% zero padding
padded_trial_spike_counts = trial_spike_counts;
padded_trial_curs = trial_curs(:,1); % just the cursor location for now
for ii = 1:numel(trial_spike_counts)
    trial_size = size(padded_trial_spike_counts{ii});
    if trial_size(1) < max_trial_length
        padded_trial_spike_counts{ii} = [padded_trial_spike_counts{ii}; zeros(max_trial_length-trial_size(1),trial_size(2))];
    end
end


% 90th percentile
nine_perc = int32(quantile(trial_lengths,.9));
perc_trial_spike_counts = trial_spike_counts;
perc_trial_curs = trial_curs(:,1); % just the cursor location for now
for ii = 1:numel(trial_spike_counts)
    if trial_lengths(ii) < nine_perc
        perc_trial_spike_counts{ii} = [perc_trial_spike_counts{ii}; zeros(nine_perc-trial_lengths(ii),n_neurons)];
        perc_trial_curs{ii} = [perc_trial_curs{ii}; zeros(nine_perc-trial_lengths(ii),2)];
    else
        perc_trial_spike_counts{ii} = perc_trial_spike_counts{ii}(1:nine_perc,:);
        perc_trial_curs{ii} = perc_trial_curs{ii}(1:nine_perc,:);
    end
end


% % adjust everything to the length of 50%
% mean_length = int(mean(trial_lengths)); % what is the mean trial length?
% stretch_trial_spike_counts = trial_spike_counts;
% stretch_trial_curs = trial_curs(:,1);
% for ii = 1:numel(trial_spike_counts)
%     resample


%% which trial type to we want to use to train?
% 90th percentile, with zero padding
use_neur = perc_trial_spike_counts;
use_curs = perc_trial_curs;

% % resample everything to match 
% use_neur = stretch_trial_spike_counts;
% use_curs = stretch_trial_curs;


%% Naive training
%
% No temporal stretching or additional preprocessing
%
% Now let's try just running it through the training process

train_perc = .9; % train/test percentage
total_trials = numel(trial_spike_counts); % how many trials?
trial_order = randperm(total_trials); % randomly reorder the trials
train_cutoff = floor(total_trials*train_perc);
train_inds = trial_order(1:train_cutoff); % use P training trials

% % get the model from ZD's code
% dpars_naive = ComputeMNRPars(trial_spike_counts(train_inds), trial_curs(train_inds,1), xds.bin_width); 
dpars_naive = ComputeMNRPars(perc_trial_spike_counts(train_inds), perc_trial_curs(train_inds,1), xds.bin_width); 


disp('decoder built')
% get testing and training predictions

%% Run online

% xpc settings -- for communication
xpc_ip = '192.168.0.1'; % for sending the UDP packets of the X and Y
xpc_port = 24999; % command port
% echoudp('on',xpc_port)
u = udp(xpc_ip, xpc_port); % create opject
fopen(u); % and open it



% initialize the cerebus
rec_dir = uigetdir('C:','Recording directory'); % where are we recording?
rec_name = strcat(rec_dir,filesep,datestr(now,'YYYYmmdd_hhMM'), '_', monkey, '_', task, '_');
cbmex('open'); % connect to cerebus
cbmex('fileconfig',rec_name,'',0); % initialize file storage

%store predictions
predfile = [rec_dir, filesep, datestr(now, 'YYYYmmdd_hhMM'), '_', monkey, '_', task, '_MNParsPredictions.txt'];
fid_pred = fopen(predfile, 'w+');
spikefile = [rec_dir, filesep, datestr(now, 'YYYYmmdd_hhMM'), '_', monkey, '_', task, '_Spikes.txt'];
fid_spike = fopen(spikefile,'w+');


% setup the output and inputs
% empty buffer for spikes
firing_buffer = zeros(1,size(xds.spike_counts,2));
% curs = [x, y, vx, vy] -- start with all zeros
curs = [0, 0, 0, 0];

% small GUI to stop the system from running
h = msgbox('Press ''ok''  to stop recording');

% for now we'll just set it up as a loop. Can switch to timer() later if we
% want
cbmex('fileconfig',rec_name,'Danzinger decoder online',1)
cbmex('trialconfig',1)
tic_buf = tic;
elapse_tic = tic;

while ishandle(h)
    
    % if it's within 100 us of the loop time
    toc_buf = toc(tic_buf);
    if toc_buf > bin_width
        tic_buf = tic; % set a new loop time
        
        [ts_cell_array, tBuffer,~] = cbmex('trialdata',1);
        
        % pull in the number of spikes that have happened per channel in
        % the last bin period
        for ii = 1:size(firing_buffer,2)
            firing_buffer(ii) = length(ts_cell_array{ii,2})/bin_width; % counts in hz
        end
        
        % Run it through the decoder
        curs = MultinomialSelection(firing_buffer', dpars_naive, curs);
        
        
        % parse to send to the XPC
        fwrite(u,[curs(1),curs(2),0,0],'single') % send to xpc
        
        loop_time = toc(elapse_tic);
        % store the data
        % cursor
        fprintf(fid_pred,'%.04f\t',loop_time);
        fprintf(fid_pred,'%.02f\t',curs); 
        fprintf(fid_pred,'\n');
        % spikes
        fprintf(fid_spike,'%.04f\t',loop_time);
        fprintf(fid_spike, '%d\t', firing_buffer);
        fprintf(fid_spike,'\n');
        
        % wait for (loosely) the loop time
        pause(bin_width-.001 - toc(tic_buf))
        
    end

end


%% 
cbmex('fileconfig',rec_name,'',0)
cbmex('trialconfig',0)
cbmex('close')

fclose(u);
delete(u)

fclose(fid_pred);
fclose(fid_spike);