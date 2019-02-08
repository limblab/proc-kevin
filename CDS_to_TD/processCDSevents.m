function out = processCDSevents(filename,signal_info)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % loads a CDS file and returns all all the event data (trial table entries ending in 'Time').
    
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
    % first the events...
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    event_names = cds.trials.Properties.VariableNames(endsWith(cds.trials.Properties.VariableNames,'Time'));
    
    % if events are time, it expects them in cells like spiking data
    %   you can also give it already-binned events and it just passes them
    %   along
    event_data = cell(1,length(event_names));
    for eventnum = 1:length(event_names)
        event_data{eventnum} = cds.trials.(event_names{eventnum});
    end
    
    % this part could be automated
    event_labels = event_names;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
    
    % import the trial table meta info
    for i=1:length(trial_meta)
        if ischar(trial_meta{i}) && ismember(trial_meta{i},cds.trials.Properties.VariableNames)
            meta_info.(trial_meta{i}) = cds.trials.(trial_meta{i})';
        else
            warning('Element %d of trial_meta was not imported',i)
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % and creating a time vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    t = 0:1/30000:cds.meta.duration; % events are (hopefully) sampled at 30k
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    out.meta   = meta_info;
    out.data = event_data;
    out.labels = event_labels;
    out.t = t;
    out.error_flag = error_flag;
end