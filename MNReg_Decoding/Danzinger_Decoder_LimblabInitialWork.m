%% XDS parameters
% 
% gonna take advantage of our XDS built ins to handle all of the
% conversions

monkey = 'Pancake'; % monkey name
task = 'WM'; % task
array_name = 'right_M1';
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
file_name = '2021107_Pancake_WM_002.nev'; % path to training .nev
base_dir = 'Z:\data\Pancake_20K3\Cerebus_data\20221107\';

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

max_trial_length = 0;
min_trial_length = 1000;
for ii = 1:numel(trial_spike_counts)
    trial_size = size(trial_spike_counts{ii});
    max_trial_length = max(max_trial_length,trial_size(1));
    min_trial_length = min(min_trial_length,trial_size(1));
end

% zero padding
padded_trial_spike_counts = trial_spike_counts;
padded_trial_curs = trial_curs(:,1); % just the cursor location for now
for ii = 1:numel(trial_spike_counts)
    trial_size = size(padded_trial_spike_counts{ii});
    if trial_size(1) < max_trial_length
        padded_trial_spike_counts{ii} = [padded_trial_spike_counts; zeros(max_trial_length-trial_size(1),trial_size(2))];
    end
end


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

% get the model from ZD's code
dpars_naive = ComputeMNRPars(trial_spike_counts(train_inds), trial_curs(train_inds,1), .05); 

% get testing and training predictions

%% Run online

% xpc settings -- for communication
xpc_ip = '192.168.0.1'; % for sending the UDP packets of the X and Y
xpc_port = 15000; % command port
% echoudp('on',xpc_port)
u = udp(xpc_ip, xpc_port); % create opject
fopen(u); % and open it


% initialize the cerebus
rec_dir = uigetdir('C:','Recording directory'); % where are we recording?
rec_name = strcat(rec_dir,filesep,datestr(today(),'YYYYmmdd'),monkey,task);
cbmex('open'); % connect to cerebus
cbmex('fileconfig',rec_name,'',0); % initialize file storage

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

while exists(h)
    
    % if it's within 10 us of the loop time
    if toc(tic_buf) >= bin_width-.0001
        tic_buf = tic; % set a new loop time
        
        [ts_cell_array, tBuffer,~] = cbmex('trialdata',1);
        
        % pull in the number of spikes that have happened per channel in
        % the last bin period
        for ii = 1:size(firing_buffer,2)
            firing_buffer(ii) = length(ts_cell_array{ii,2})/bin_width % counts in hz
        end
        
        % Run it through the decoder
        curs = MultinomialSelection(firing_buffer, dpars_naive, curs);
        
        
        % parse to send to the XPC
        % first stick it all in a 
        

    end

end