%% XDS parameters
% 
% gonna take advantage of our XDS built ins to handle all of the
% conversions

monkey = 'Tot'; % monkey name
task = 'WM'; % task
array_name = 'left_M1';
ran_by = 'XM_KLB'; % who recorded this?
lab = 6; % upstairs
bin_width = .05; % 50 ms
sorted = 0;
requires_raw_emg = 0; % are we recording EMG here?

delay = 0; % number of bins to delay by -- 2 bins w/ 50 ms bin == 100 ms

params = struct(...
    'monkey_name',monkey,...
    'array_name',array_name,...
    'task_name',task,...
    'ran_by',ran_by,...
    'lab',lab,...
    'bin_width',bin_width,...
    'sorted',sorted,...
    'requires_raw_emg',requires_raw_emg);


map_dir = 'Z:\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\Tot_20K4\Surgery\20230215_LeftM1\';
map_name = 'SN 6251-002471 array 1066-5.cmp';
save_dir = 'D:\Kevin\';

%% convert file to xds
[file_name,base_dir] = uigetfile('*.nev');



xds = raw_to_xds(base_dir, file_name, map_dir, map_name, params);
base_name = strsplit(file_name,'.nev');

% add delay as desired
temp_p = [xds.curs_p(delay+1:end,:); zeros(delay,2)];
temp_v = [xds.curs_v(delay+1:end,:); zeros(delay,2)];
temp_a = [xds.curs_a(delay+1:end,:); zeros(delay,2)];
xds.curs_p = temp_p; % overwrite
xds.curs_v = temp_v; % overwrite
xds.curs_a = temp_a; % overwrite
xds.cursor_delay = delay;

% useful for later -- neurons and sample numbers
num_samples = size(xds.spike_counts,1); % number of samples
num_neurons = size(xds.spike_counts,2); % number of neurons

save_name = strcat(save_dir, base_name{1}, '_xds.mat');
save(save_name,'xds');

disp('XDS created and saved')

%% use existing xds
[file_name, base_dir] = uigetfile('*_xds.mat');
load([base_dir,filesep,file_name]);

%% parse the xds data
%
% We have to pull the cortical and cursor data out from the xds, and
% place them into a series of cells -- one for each trial

% To start we'll just use the get_rewarded_trials function and see if
% that's sufficient. If not I can write something new that can take care
% of it.

% start_time = 'start_time';
start_time = 'gocue_time';
[trial_spike_counts, ~, ~, ~, trial_curs, trial_tgt_pos] = ...
    get_rewarded_trials(xds, start_time);


%% Naive training
%
% No temporal stretching or additional preprocessing
%
% Now let's try just running it through the training process

% get the model from ZD's code -- use the velocity directly
dpars_naive = ComputeMNRPars(trial_spike_counts, trial_curs(:,2), xds.bin_width, 1);


disp('decoder built')
% get testing and training predictions

%% Offline testing -- convert xds

[file_name,base_dir] = uigetfile('*.nev');

offline_xds = raw_to_xds(base_dir, file_name, map_dir, map_name, params);

%% offline testing -- existing xds


%%
% add delay as desired
temp_p = [offline_xds.curs_p(delay+1:end,:); zeros(delay,2)];
temp_v = [offline_xds.curs_v(delay+1:end,:); zeros(delay,2)];
temp_a = [offline_xds.curs_a(delay+1:end,:); zeros(delay,2)];
offline_xds.curs_p = temp_p; % overwrite
offline_xds.curs_v = temp_v; % overwrite
offline_xds.curs_a = temp_a; % overwrite
offline_xds.cursor_delay = delay;

% % Continuous control
% store predictions
pred_vel = zeros(size(temp_v));
pred_curs = zeros(size(temp_p));
temp_curs = [0,0,0,0];
for replay_idx = 1:size(offline_xds.curs_v,1)
    temp_curs = MultinomialSelection(offline_xds.spike_counts(replay_idx,:)', dpars_naive, temp_curs);
    pred_curs(replay_idx,:) = temp_curs(1:2);
    pred_vel(replay_idx,:) = temp_curs(3:4);
    
end

% Compare and contrast
f_offline = figure;
ax(1) = subplot(2,1,1);
hold on
plot(offline_xds.time_frame, pred_curs(:,1));
plot(offline_xds.time_frame, offline_xds.curs_p(:,1))
legend('Predicted Values','Recorded Values')
ylabel('Horizontal Position')
ax(2) = subplot(2,1,2);
hold on
plot(offline_xds.time_frame, pred_vel(:,1));
plot(offline_xds.time_frame, offline_xds.curs_v(:,1))
legend('Predicted Values','Recorded Values')
ylabel('Horizontal Velocity')
xlabel('Time (s)')
linkaxes(ax,'x')
title('Continuous cursor')


% % Aligned Trials
% pull out the trials so they're the same as above
[offline_spike_counts, ~, ~, ~, offline_curs, offline_tgt_pos] = ...
    get_rewarded_trials(offline_xds, start_time);

% convert from cells to matrices
offline_spike_counts = cell2mat(offline_spike_counts);
offline_p = cell2mat(offline_curs(:,1));
offline_v = cell2mat(offline_curs(:,2));

% store predictions
pred_vel = zeros(size(offline_p));
pred_curs = zeros(size(offline_p));
temp_curs = [0,0,0,0];
for replay_idx = 1:size(offline_p,1)
    temp_curs = MultinomialSelection(offline_spike_counts(replay_idx,:)', dpars_naive, temp_curs);
    pred_curs(replay_idx,:) = temp_curs(1:2);
    pred_vel(replay_idx,:) = temp_curs(3:4);
end



f_aligned = figure;
ax(1) = subplot(2,1,1);
hold on
plot(pred_curs(:,1))
plot(offline_p(:,1))
ylabel('Horizontal Position')
legend('Prediction','Recording')
ax(2) = subplot(2,1,2);
hold on
plot(pred_vel(:,1))
plot(offline_v(:,1))
legend('Prediction','Recording')
ylabel('Horizontal Velocity')
xlabel('Samples')
linkaxes(ax,'x')
title('Predicted cursor, offline data, trial aligned')


% % Aligned Trials -- reset the cursor
% pull out the trials so they're the same as above
[offline_spike_counts, ~, ~, ~, offline_curs, offline_tgt_pos] = ...
    get_rewarded_trials(offline_xds, start_time);

% store predictions
pred_vel = offline_curs(:,2);
pred_curs = offline_curs(:,1);
for replay_idx = 1:numel(offline_spike_counts)
    temp_spike_counts = offline_spike_counts{replay_idx};
    temp_curs = [0,0,0,0];
    for jj = 1:size(temp_spike_counts,1)
        temp_curs = MultinomialSelection(temp_spike_counts(jj,:)', dpars_naive, temp_curs);
        pred_curs{replay_idx}(jj,:) = temp_curs(1:2);
        pred_vel{replay_idx}(jj,:) = temp_curs(3:4);
    end
end

pred_curs = cell2mat(pred_curs);
pred_vel = cell2mat(pred_vel);
offline_p = cell2mat(offline_curs(:,1));
offline_v = cell2mat(offline_curs(:,2));

f_aligned = figure;
ax(1) = subplot(2,1,1);
hold on
plot(pred_curs(:,1))
plot(offline_p(:,1))
ylabel('Horizontal Position')
legend('Prediction','Recording')
ax(2) = subplot(2,1,2);
hold on
plot(pred_vel(:,1))
plot(offline_v(:,1))
legend('Prediction','Recording')
ylabel('Horizontal Velocity')
xlabel('Samples')
linkaxes(ax,'x')
title('Predicted cursor, offline data, trial aligned, start trial at 0')

%% compare with W Filter

% create the historical data lags
num_taps = 10; % start with 10 lags
lagged_spikes = zeros(num_samples,num_taps*num_neurons + 1);
lagged_spikes(:,num_taps*num_neurons + 1) = 1; % term to capture the mean
% fill lagged spike matrix
for replay_idx = 0:(num_taps-1)
    neur_offset = replay_idx*num_neurons;
    lagged_spikes(1:num_samples-replay_idx,(1:num_neurons)+neur_offset) = xds.spike_counts((replay_idx+1):num_samples,:);
end

filter_W = lagged_spikes\xds.curs_v; % could do the normal equation or something, but this is quicker ;)

% calculate quality of predictions -- both velocity and cursor
pred_vel = lagged_spikes * filter_W; 
pred_curs = cumsum(pred_vel)*bin_width;

% calculate with a third order non-linearity
% nlm = fitnlm(xds.curs_v(:,1),pred_vel(:,1),'y ~ (b0+ b1*x + b3*x^3)', [0,1,1]);

% calculate varience explained
vaf_vel = 1 - sum((pred_vel-xds.curs_v).^2./var(xds.curs_v,1),1);
vaf_curs = 1 - sum((pred_curs-xds.curs_p).^2./var(xds.curs_p,1),1);




%% Run online

% wiener filter or multinomial?
MN_flag = 1;

% xpc settings -- for communication
xpc_ip = '192.168.0.1'; % for sending the UDP packets of the X and Y
xpc_port = 24999; % command port

if verLessThan('matlab','9.9')
    u = udp(xpc_ip, xpc_port); % create opject
    set(u,'ByteOrder','littleEndian');
    fopen(u); % and open it
else
    u = udpport('LocalHost','192.168.0.3','LocalPort',24999);
    set(u,'ByteOrder','little-endian');
end


% initialize the cerebus
if ~exist('rec_dir','var')
    rec_dir = uigetdir('C:','Recording directory'); % where are we recording?
end
rec_name = strcat(rec_dir,filesep,datestr(now,'YYYYmmdd_hhMM'), '_', monkey, '_', task, '_');
cbmex('open'); % connect to cerebus
cbmex('fileconfig',rec_name,'',0); % initialize file storage

%store predictions
predfile = [rec_dir, filesep, datestr(now, 'YYYYmmdd_hhMM'), '_', monkey, '_', task, '_MNParsPredictions.txt'];
fid_pred = fopen(predfile, 'w+');
spikefile = [rec_dir, filesep, datestr(now, 'YYYYmmdd_hhMM'), '_', monkey, '_', task, '_Spikes.txt'];
fid_spike = fopen(spikefile,'w+');


% setup the output and inputs
% empty buffer for spikes -- different if wiener vs multinomial
if MN_flag == true
    firing_buffer = zeros(1,num_neurons);
else
    firing_buffer = zeros(1,num_neurons*num_taps + 1);
end
curs = [0, 0, 0, 0]; % curs pos, curs vel 

% small GUI to stop the system from running
h = msgbox('Press ''ok''  to stop recording');

% for now we'll just set it up as a loop. Can switch to timer() later if we
% want
cbmex('fileconfig',rec_name,'Danzinger decoder online',1)
cbmex('trialconfig',1)
tic_buf = tic;
elapse_tic = tic;

% Clear the buffer to make sure the initial outputs are reasonable
[ts_cell_array, tBuffer,~] = cbmex('trialdata',1);
while ishandle(h)
    
    % if it's within 100 us of the loop time
    toc_buf = toc(tic_buf);
    if toc_buf > bin_width
        tic_buf = tic; % set a new loop time
        
        [ts_cell_array, tBuffer,~] = cbmex('trialdata',1);
        
        % pull in the number of spikes that have happened per channel in
        % the last bin period
        % works for both the wiener and the multinomial, since we'll shift
        % the wiener at the end of each loop
        for replay_idx = 1:num_neurons
            firing_buffer(replay_idx) = length(ts_cell_array{replay_idx,2})/bin_width; % counts in hz
        end
        
        % Run it through the decoder
        if MN_flag == true
            curs = MultinomialSelection(firing_buffer', dpars_naive, curs);
        else
            curs(3:4) = firing_buffer*filter_W; % vel = rates * W == 1x2 output
            curs(1:2) = curs(1:2) + curs(3:4).*bin_width; % velocity to position
            % need to shift the lags over
            firing_buffer(num_neurons+1:num_taps*num_neurons) = firing_buffer(1:(num_taps-1)*num_neurons);
        end
            
        
        
        % parse to send to the XPC
        if verLessThan('matlab','9.9')
            fwrite(u,[0,0,curs(1),curs(2)],'single') % send to xpc
        else
            write(u,[0,0,curs(1),curs(2)],'single',xpc_ip, xpc_port);
        end
        
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


% close everything down
cbmex('fileconfig',rec_name,'',0)
cbmex('trialconfig',0)
cbmex('close')

% if verLessThan(
% fclose(u);
clear u

fclose(fid_pred);
fclose(fid_spike);

%% replay a recorded file
% allows us to watch it replay on the xpc

% wiener filter or multinomial?
MN_flag = 0;

% xpc settings -- for communication
xpc_ip = '192.168.0.1'; % for sending the UDP packets of the X and Y
xpc_port = 24999; % command port

if verLessThan('matlab','9.9')
    u = udp(xpc_ip, xpc_port); % create opject
    set(u,'ByteOrder','littleEndian');
    fopen(u); % and open it
else
    u = udpport('LocalHost','192.168.0.3','LocalPort',24999);
    set(u,'ByteOrder','little-endian');
%     set(u,'LocalPort',24999);
end

if MN_flag == true
    firing_buffer = zeros(1,num_neurons);
else
    firing_buffer = zeros(1,num_neurons*num_taps + 1);
end
curs = [0, 0, 0, 0]; % curs pos, curs vel 


replay_idx = 0;
while ishandle(h) && replay_idx < size(xds.spike_counts,1)
    
    % if it's within 100 us of the loop time
    toc_buf = toc(tic_buf);
    if toc_buf > bin_width
        tic_buf = tic; % set a new loop time
        
        firing_buffer(1:num_neurons) = xds.spike_counts(replay_idx,:);
        
        % Run it through the decoder
        if MN_flag == true
            curs = MultinomialSelection(firing_buffer', dpars_naive, curs);
        else
            curs(3:4) = firing_buffer*filter_W; % vel = rates * W == 1x2 output
            curs(1:2) = curs(1:2) + curs(3:4).*bin_width; % velocity to position
            % need to shift the lags over
            firing_buffer(num_neurons+1:num_taps*num_neurons) = firing_buffer(1:(num_taps-1)*num_neurons);
        end
            
        
        
        % parse to send to the XPC
        if verLessThan('matlab','9.9')
            fwrite(u,[0,0,curs(1),curs(2)],'single') % send to xpc
        else
            write(u,[0,0,curs(1),curs(2)],'single',xpc_ip, xpc_port);
        end
        
        loop_time = toc(elapse_tic);
        % store the data
        % cursor
        
        % wait for (loosely) the loop time
        pause(bin_width-.001 - toc(tic_buf))
        
        % increment the counter
        replay_idx = replay_idx+1;
        
    end

end