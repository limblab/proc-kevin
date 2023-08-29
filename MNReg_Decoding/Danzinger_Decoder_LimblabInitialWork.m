%% XDS parameters
% 
% gonna take advantage of our XDS built ins to handle all of the
% conversions

monkey = 'Tot'; % monkey name
task = 'WS'; % task
array_name = 'left_M1';
ran_by = 'XM_KLB'; % who recorded this?
lab = 1; % upstairs
bin_width = .05; % 50 ms
sorted = 0;
requires_raw_emg = 0; % are we recording EMG here?

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


% useful for later -- neurons and sample numbers
num_samples = size(xds.spike_counts,1); % number of samples
num_neurons = size(xds.spike_counts,2); % number of neurons

save_name = strcat(save_dir, base_name{1}, '_xds.mat');
save(save_name,'xds');

disp('XDS created and saved')

%% use existing xds
[file_name, base_dir] = uigetfile('*_xds.mat');
load([base_dir,filesep,file_name]);

% useful for later -- neurons and sample numbers
num_samples = size(xds.spike_counts,1); % number of samples
num_neurons = size(xds.spike_counts,2); % number of neurons


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


%% plotting cursor velocities and positions


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
num_lags = 10; % start with 10 lags
lagged_spikes = zeros(num_samples,num_lags*num_neurons);
% lagged_spikes = zeros(num_samples,num_lags*num_neurons + 1);
% lagged_spikes(:,num_lags*num_neurons + 1) = 1; % term to capture the mean
% fill lagged spike matrix
for lag_idx = 0:(num_lags-1)
    neur_offset = lag_idx*num_neurons;
    lagged_spikes(1+lag_idx:num_samples,(1:num_neurons)+neur_offset) = xds.spike_counts(1:num_samples-lag_idx,:);
end

% basic ridge regression -- saw little change
filter_W = inv(lagged_spikes'*lagged_spikes + .1*eye(size(lagged_spikes,2)))*(lagged_spikes'*xds.curs_v); % could do the normal equation or something, but this is quicker ;)

% calculate quality of predictions -- both velocity and cursor
pred_vel = lagged_spikes * filter_W; 
pred_curs = cumsum(pred_vel)*bin_width;

% calculate with a third order non-linearity
% nlm = fitnlm(xds.curs_v(:,1),pred_vel(:,1),'y ~ (b0+ b1*x + b3*x^3)', [0,1,1]);

% calculate varience explained
vaf_vel = 1 - mean((pred_vel-xds.curs_v).^2,1)./var(xds.curs_v,1);
vaf_curs = 1 - mean((pred_curs-xds.curs_p).^2,1)./var(xds.curs_p,1);


% plot them
figure
ax(1) = subplot(2,1,1);
plot(xds.curs_v(:,1))
hold on
plot(pred_vel(:,1))
title('X Velocities')
legend('true','predicted')
ax(2) = subplot(2,1,2);
plot(xds.curs_v(:,2))
hold on
plot(pred_vel(:,2))
title('Y Velocities')
legend('true','predicted')
linkaxes(ax,'x')


figure
subplot(2,1,1)
plot(xds.curs_p(:,1))
hold on
plot(pred_curs(:,1))
title('X Position')
legend('true','predicted')
subplot(2,1,2)
plot(xds.curs_p(:,2))
hold on
plot(pred_curs(:,2))
title('Y Position')
legend('true','predicted')


%% Run through xpc

% online? if not we'll replay an old file
online_flag = 1;

% wiener filter or multinomial?
MN_flag = 1;

% xpc settings -- for communication
xpc_ip = '192.168.0.1'; % for sending the UDP packets of the X and Y
xpc_port = 24999; % command port

if verLessThan('matlab','9.9')
    xpc = udp(xpc_ip, xpc_port); % create opject
    set(xpc,'ByteOrder','littleEndian');
    fopen(xpc); % and open it
else
    xpc = udpport('LocalHost','192.168.0.3','LocalPort',24999);
    set(xpc,'ByteOrder','little-endian');
end

% get the xds file if we're replaying stuff
if online_flag == false
    [xds_name, base_dir] = uigetfile('*_xds.mat');
    load([base_dir,filesep,xds_name]);
end


% get the recording directory if not already known
if ~exist('rec_dir','var')
    rec_dir = uigetdir('C:','Recording directory'); % where are we recording?
end

% initialize the cerebus -- only for online
if online_flag == true
    rec_name = strcat(rec_dir,filesep,datestr(now,'YYYYmmdd_hhMM'), '_', monkey, '_', task, '_');
    cbmex('open'); % connect to cerebus

    cbmex('fileconfig',rec_name,'',0); % initialize file storage
end


%store predictions -- different names online vs replay
if mn_flag == true
    bci_name = 'MultiNomial';
else
    bci_name = 'Wiener';
end

if online_flag == true
    predfile = [rec_dir, filesep,  monkey, '_', datestr(now, 'YYYYmmdd_hhMM'), '_', task, '_', bci_name, 'Predictions.txt'];
    fid_pred = fopen(predfile, 'w+');
    spikefile = [rec_dir, filesep,  monkey, '_', datestr(now, 'YYYYmmdd_hhMM'), '_',task, '_Spikes.txt'];
    fid_spike = fopen(spikefile,'w+');
else
    predfile = [rec_dir, filesep,  xds_file, '_replay_', datestr(now, 'YYYYmmdd_hhMM'), '_', bci_name, '.txt'];
    fid_pred = fopen(predfile, 'w+');
end


% setup the output and inputs
% empty buffer for spikes -- different if wiener vs multinomial
if MN_flag == true
    firing_buffer = zeros(1,num_neurons);
else
    firing_buffer = zeros(1,num_neurons*num_lags);
end
curs = [0, 0, 0, 0]; % curs pos, curs vel 

% small GUI to stop the system from running
h = msgbox('Press ''ok''  to stop recording');

% for now we'll just set it up as a loop. Can switch to timer() later if we
% want
if online_flag == true
    cbmex('fileconfig',rec_name,[bci_name,' online recordings'],1)
    cbmex('trialconfig',1)
end

% start the loop timer -- 
tic_buf = tic;
elapse_tic = tic;

% Clear the buffer to make sure the initial outputs are reasonable
if online_flag == true
    [ts_cell_array, tBuffer,~] = cbmex('trialdata',1);
end

% counts going through the recording
replay_idx = 1;

while ishandle(h)
    
    % if it's within 100 us of the loop time
    toc_buf = toc(tic_buf);
    if toc_buf > bin_width
        tic_buf = tic; % set a new loop time
        
        if online_flag == true
            [ts_cell_array, tBuffer,~] = cbmex('trialdata',1);
            
            % pull in the number of spikes that have happened per channel in
            % the last bin period
            % works for both the wiener and the multinomial, since we'll shift
            % the wiener at the end of each loop
            for replay_idx = 1:num_neurons
                firing_buffer(replay_idx) = length(ts_cell_array{replay_idx,2}); % counts in hz
            end

        else % just pull things out if it's a replay session
            firing_buffer(1:num_neurons) = xds.spike_counts(replay_idx,:);
        end

        % Run it through the decoder
        if MN_flag == true
            curs = MultinomialSelection(firing_buffer', dpars_naive, curs);
        else
            curs(3:4) = firing_buffer*filter_W; % vel = rates * W == 1x2 output
            curs(1:2) = curs(1:2) + curs(3:4).*bin_width; % velocity to position
            % need to shift the lags over
            firing_buffer(num_neurons+1:num_lags*num_neurons) = firing_buffer(1:(num_lags-1)*num_neurons);
        end
        
        % cursor corrections -- to make the system usable!
        % limit at the edge of the screen
        curs(1:2) = max(-12,max(12,curs(1:2)));


        % parse to send to the XPC
        if verLessThan('matlab','9.9')
            fwrite(xpc,[0,0,curs(1),curs(2)],'single') % send to xpc
        else
            write(xpc,[0,0,curs(1),curs(2)],'single',xpc_ip, xpc_port);
        end
        
        loop_time = toc(elapse_tic);
        
        % store the data
        % cursor
        fprintf(fid_pred,'%.04f\t',loop_time);
        fprintf(fid_pred,'%.02f\t',curs); 
        fprintf(fid_pred,'\n');
        
        % spikes
        if online_flag == true
            fprintf(fid_spike,'%.04f\t',loop_time);
            fprintf(fid_spike, '%d\t', firing_buffer);
            fprintf(fid_spike,'\n');
        end


        % next replay step. Stop if we've reached the end!
        if online_flag == false
            replay_idx = replay_idx + 1;
            if replay_idx > size(xds.curs_p,1)
                close(h)
            end
        end
                


        % wait for (loosely) the loop time
        pause(bin_width-.001 - toc(tic_buf))
        
    end

end

if online_flag == true
    % close everything down
    cbmex('fileconfig',rec_name,'',0)
    cbmex('trialconfig',0)
    cbmex('close')
end

% close the udp socket
clear xpc

% close open files
fclose(fid_pred);
if online_flag == true
    fclose(fid_spike); 
end

