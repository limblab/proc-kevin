function out = processCDScontinuous(filename,signal_info)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % loads a CDS file and returns all continuous signals it can extract, along
    % with all the event data (trial table entries ending in 'Time').
    
    % params
    trial_meta = {}; % list of fields from the trial table to import into TD
    assignParams(who,signal_info.params); % overwrite parameters
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    error_flag = false;
    
    % load the CDS
    if ~isempty(filename)
        load(filename);
    else
        error_flag = true;
        disp(['ERROR: ' mfilename ': no filename provided']);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Now the continuous signals
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % figure out which signals to extract
    signal_names = {};
    if cds.meta.hasKinematics
        signal_names = [signal_names {'kin'}];
    end
    if cds.meta.hasForce
        signal_names = [signal_names {'force'}];
    end
    if cds.meta.hasEmg
        signal_names = [signal_names {'emg'}];
    end
    if cds.meta.hasLfp
        % signal_names = [signal_names {'lfp'}];
    end
    if cds.meta.hasAnalog
        % analog could be a lot of stuff...
        for analog_idx = 1:length(cds.analog)
            header = cds.analog{analog_idx}.Properties.VariableNames;
            % Figure out if we have motor control data
            if any(contains(header,'MotorControl'))
                signal_names = [signal_names {'motorcontrol'}];
                motorcontrol_idx = analog_idx;
            end
            if any(endsWith(header,'_ang'))
                signal_names = [signal_names {'joint_ang'}];
                joint_ang_idx = analog_idx;
            end
            if any(endsWith(header,'_vel'))
                signal_names = [signal_names {'joint_vel'}];
                joint_vel_idx = analog_idx;
            end
            if any(endsWith(header,'_len'))
                signal_names = [signal_names {'muscle_len'}];
                muscle_len_idx = analog_idx;
            end
            if any(endsWith(header,'_muscVel'))
                signal_names = [signal_names {'muscle_vel'}];
                muscle_vel_idx = analog_idx;
            end
            if any(contains(header,'_handPos'))
                signal_names = [signal_names {'hand_pos'}];
                hand_pos_idx = analog_idx;
            end
            if any(contains(header,'_handVel'))
                signal_names = [signal_names {'hand_vel'}];
                hand_vel_idx = analog_idx;
            end
            if any(contains(header,'_handAcc'))
                signal_names = [signal_names {'hand_acc'}];
                hand_acc_idx = analog_idx;
            end
            if any(contains(header,'_elbowPos'))
                signal_names = [signal_names {'elbow_pos'}];
                elbow_pos_idx = analog_idx;
            end
            if any(contains(header,'_elbowVel'))
                signal_names = [signal_names {'elbow_vel'}];
                elbow_vel_idx = analog_idx;
            end
            if any(contains(header,'_elbowAcc'))
                signal_names = [signal_names {'elbow_acc'}];
                elbow_acc_idx = analog_idx;
            end
            if any(contains(header,'Frame')) || any(contains(header,'Marker'))
                signal_names = [signal_names {'markers'}];
                markers_idx = analog_idx;
            end
        end
    end
    
    % extract signals
    samp_rate = zeros(1,length(signal_names));
    [timevec_cell,cont_data,signal_labels] = deal(cell(1,length(signal_names)));
    for signum = 1:length(signal_names)
        switch lower(signal_names{signum})
            case 'kin'
                % do kin stuff
                data_table = cds.kin;
                data_cols = startsWith(data_table.Properties.VariableNames,{'x','y','vx','vy','ax','ay'});
            case 'force'
                % do force stuff
                data_table = cds.force;
                data_cols = startsWith(data_table.Properties.VariableNames,{'fx','fy','fz','mx','my','mz'});
            case 'emg'
                % do emg stuff (mostly will be processed by special 'emg' tag in convertDataToTD
                data_table = cds.emg;
                data_cols = startsWith(data_table.Properties.VariableNames,'EMG');
            case 'motorcontrol'
                % do motor control stuff
                data_table = cds.analog{motorcontrol_idx};
                data_cols = startsWith(data_table.Properties.VariableNames,'MotorControl');
            case 'joint_ang'
                % do opensim stuff
                data_table = cds.analog{joint_ang_idx};
                data_cols = endsWith(data_table.Properties.VariableNames,'_ang');
            case 'joint_vel'
                % do opensim stuff
                data_table = cds.analog{joint_vel_idx};
                data_cols = endsWith(data_table.Properties.VariableNames,'_vel');
            case 'muscle_len'
                % do opensim stuff
                data_table = cds.analog{muscle_len_idx};
                data_cols = endsWith(data_table.Properties.VariableNames,'_len');
            case 'muscle_vel'
                % do opensim stuff
                data_table = cds.analog{muscle_vel_idx};
                data_cols = endsWith(data_table.Properties.VariableNames,'_muscVel');
            case 'hand_pos'
                % do opensim stuff
                data_table = cds.analog{hand_pos_idx};
                data_cols = find(contains(data_table.Properties.VariableNames,'_handPos'));
                % don't really need guide since it's X Y Z (as long as the user requests those signals by label, in order)
            case 'hand_vel'
                % do opensim stuff
                data_table = cds.analog{hand_vel_idx};
                data_cols = find(contains(data_table.Properties.VariableNames,'_handVel'));
                % don't really need guide since it's X Y Z (as long as the user requests those signals by label, in order)
            case 'hand_acc'
                % do opensim stuff
                data_table = cds.analog{hand_acc_idx};
                data_cols = find(contains(data_table.Properties.VariableNames,'_handAcc'));
                % don't really need guide since it's X Y Z (as long as the user requests those signals by label, in order)
            case 'elbow_pos'
                % do opensim stuff
                data_table = cds.analog{elbow_pos_idx};
                data_cols = find(contains(data_table.Properties.VariableNames,'_elbowPos'));
                % don't really need guide since it's X Y Z (as long as the user requests those signals by label, in order)
            case 'elbow_vel'
                % do opensim stuff
                data_table = cds.analog{elbow_vel_idx};
                data_cols = find(contains(data_table.Properties.VariableNames,'_elbowVel'));
                % don't really need guide since it's X Y Z (as long as the user requests those signals by label, in order)
            case 'elbow_acc'
                % do opensim stuff
                data_table = cds.analog{elbow_acc_idx};
                data_cols = find(contains(data_table.Properties.VariableNames,'_elbowAcc'));
                % don't really need guide since it's X Y Z (as long as the user requests those signals by label, in order)
            case 'markers'
                % do marker stuff
                assert(cds.meta.hasKinematics,'CDS has no kinematics!')
                
                marker_table = cds.analog{markers_idx};
                marker_cols = marker_table.Properties.VariableNames(...
                    ~strcmpi(marker_table.Properties.VariableNames,'Frame') &...
                    ~strcmpi(marker_table.Properties.VariableNames,'t')...
                    );
                marker_names = cell(1,length(marker_cols)*3);
                % get actual labels (assuming that the raw marker format is still y,z,x in lab coordinates...)
                for i = 1:length(marker_cols)
                    marker_names(((i-1)*3+1):(i*3)) = strcat(marker_cols(i),{'_y','_z','_x'});
                end
                
                marker_data = marker_table{:,3:end};
                t = marker_table.t;
                
                % interpolate to uniform sampling rate (treat nan as missing)
                dt = (t(end)-t(1))/length(t);
                tGrid = (t(1):dt:t(end))';
                marker_data_interp = zeros(length(tGrid),size(marker_data,2));
                for i=1:size(marker_data,2)
                    real_idx = find(~isnan(marker_data(:,i)));
                    marker_data_interp(:,i) = interp1(t(real_idx),marker_data(real_idx,i),tGrid);
                end
                
                % set in data_table
                data_table = array2table([tGrid marker_data_interp],'VariableNames',[{'t'} marker_names]);
                data_cols = 2:width(data_table);
            otherwise
                error('No idea what this signal is (%s)',signal_names{signum})
        end
        signal_labels{signum} = data_table.Properties.VariableNames(data_cols);
        cont_data{signum} = data_table{:,data_cols};
        timevec_cell{signum} = data_table.t;
        samp_rate(signum) = 1/mode(diff(data_table.t));
    end
    
    % resample everything to the highest sampling rate
    [final_rate,maxrate_idx] = max(samp_rate);
    t_end = 0;
    for signum = 1:length(signal_names)
        % [P,Q] = rat(final_rate/samp_rate(signum),1e-7);
        [P,Q] = rat(final_rate/samp_rate(signum)); % sometimes P and Q are very big, so use default tolerance...
        if P~=1 || Q~=1
            assert(signum~=maxrate_idx,'Something went wrong with the resample code...')
            
            % figure out where the NaNs are before resampling (mostly for markers, to see where they cut out)
            nan_spots = isnan(cont_data{signum});
            if any(any(nan_spots))
                nanblock_thresh = 0.3/mode(diff(timevec_cell{signum})); % tolerate nan blocks up to 0.3 seconds long
                nan_transitions = diff([zeros(1,size(nan_spots,2));nan_spots;zeros(1,size(nan_spots,2))]);
                nanblock_endpoints = cell(1, size(nan_spots,2));
                for i = 1:size(nan_spots,2)
                    nan_starts = find(nan_transitions(:,i)==1);
                    nan_stops = find(nan_transitions(:,i)==-1);
                    nanblock_lengths = nan_stops-nan_starts;
                    
                    nan_starts(nanblock_lengths<nanblock_thresh) = [];
                    nan_stops(nanblock_lengths<nanblock_thresh) = [];
                    
                    % save times for nanblocks
                    nanblock_endpoints{i} = [timevec_cell{signum}(nan_starts) timevec_cell{signum}(nan_stops-1)];
                end
            else
                nanblock_endpoints = {};
            end
            
            % need to resample
            % need to detrend first...
            % detrend first because resample assumes endpoints are 0
            a = zeros(2,size(cont_data{signum},2));
            dataDetrend = zeros(size(cont_data{signum},1),size(cont_data{signum},2));
            for i = 1:size(cont_data{signum},2)
                % in case start or end are nans
                nanners = isnan(cont_data{signum}(:,i));
                data_poly = cont_data{signum}(~nanners,i);
                
                t_poly = timevec_cell{signum}(~nanners);
                a(1,i) = (data_poly(end)-data_poly(1))/(t_poly(end)-t_poly(1));
                a(2,i) = data_poly(1);
                
                dataDetrend(:,i) = cont_data{signum}(:,i)-polyval(a(:,i),timevec_cell{signum});
            end
            temp=resample(dataDetrend,P,Q);
        
            % interpolate time vector
            % using upsample -> downsample to save memory (it's the same thing
            % as the reverse) but it adds extra points at the end that aren't
            % in the resampled data
            resamp_vec = ones(size(cont_data{signum},1),1);
            resamp_vec = upsample(downsample(resamp_vec,Q),P);
            ty=upsample(downsample(timevec_cell{signum},Q),P);
            ty=interp1(find(resamp_vec>0),ty(resamp_vec>0),(1:length(ty))');
            
            % get rid of extrapolated points at the end
            extrap_idx = isnan(ty);
            ty(extrap_idx) = [];
            temp(extrap_idx(1:size(temp,1)),:) = [];
    
            % retrend...
            dataResampled = zeros(size(temp,1),size(temp,2));
            for i=1:size(dataDetrend,2)
                dataResampled(:,i) = temp(:,i)+polyval(a(:,i),ty(:,1));
            end
            
            % set nan blocks back into resampled data...
            if ~isempty(nanblock_endpoints)
                for i=1:size(dataResampled,2)
                    for j=1:size(nanblock_endpoints{i},1)
                        inan = ty>=nanblock_endpoints{i}(j,1) & ty<=nanblock_endpoints{i}(j,2);
                        dataResampled(inan) = NaN;
                    end
                end
            end
            
            % assign back into cell
            cont_data{signum} = dataResampled;
            timevec_cell{signum} = ty;
        end
        
        % collect max time for time extension
        t_end = max(t_end,timevec_cell{signum}(end));
    end
    
    % extend time vectors to be the same length and interpolate to unified time
    dt = mode(diff(timevec_cell{maxrate_idx}));
    t = (0:dt:t_end)';
    for signum = 1:length(signal_names)
        % interpolate to new time vector (fill extrapolated points with NaNs)
        cont_data{signum} = interp1(timevec_cell{signum},cont_data{signum},t);
    end
    
    % try horizontally concatenating...If everything went well, things should
    % be the right length...
    cont_data = horzcat(cont_data{:});
    cont_labels = horzcat(signal_labels{:});
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % now the meta...
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    meta_info = struct(...
        'monkey',cds.meta.monkey,...
        'task',cds.meta.task,...
        'date_time',cds.meta.dateTime,...
        'trialID',cds.trials.number',...
        'result',cds.trials.result'...
        );
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    out.meta   = meta_info;
    out.data = cont_data;
    out.labels = cont_labels;
    out.t      = t;
    out.error_flag = error_flag;
end