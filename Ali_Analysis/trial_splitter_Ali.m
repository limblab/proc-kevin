% Put together only reward trials
% splitting up the trials, aligning them, then clip
% then take the first 80% as a training set and the last 20% as a test set.


% start with a file list
files = [];
muscles = {};

savedir = [pwd,filesep,'processed_for_Ali'];
if ~exist(savedir,'dir')
    mkdir(savedir);
end


for ii = 1:length(files)
    xds = load(files(ii));
    xds = get_rewarded_trials(xds,'trial_gocue_time');
    
     
    trial_len = cellfun(@length,xds.reward_trial_elapsed_time);
    bad_trial_len = mean(trial_len)+3*std(trial_len);
    
    
    xds.spike_counts = [];
    xds.EMG = [];
%     xds.EMG_names = {};
    xds.trial_elapsed_time = []
    
    if xds.has_force
        xds.force = [];
    end
    
    if xds.has_kin
        xds.kin = [];
    end
    
    for jj = 1:length(xds.reward_trial_elapsed_time)
        % skip trials that are outlier length long
        if length(xds.reward_trial_elapsed_time{jj})>bad_trial_len
            continue
        end
        
        iClip = find(-0.25<xds.reward_trial_elapsed_time{jj} & xds.reward_trial_elapsed_time{jj}<0.75);
        xds.trial_elapsed_time = [xds.trial_elapsed_time, xds.reward_trial_elapsed_time{jj}(iClip,:)];
        xds.spike_counts = [xds.reward_spike_counts, xds.reward_spike_counts{jj}(iClip,:)];
        [~,muscles_idx,~] = intersect(xds.EMG_names,muscles);
        muscles_idx = sort(muscles_idx);
        xds.EMG = [xds.EMG xds.reward_EMG{jj}(iClip,muscles_idx)];
        if length(xds.reward_force)>1
            xds.force = [xds.force xds.reward_force{jj}(iClip,:)];
        else
            
        end
        if length(xds.reward_curs)>1
            xds.curs = [xds.curs xds.reward_curs{jj}(iClip,:)];
        end
        

        
        
    end
    
    xds = rmfield(xds,'reward_trial_elapsed_time');
    xds = rmfield(xds,'reward_spike_counts');
    xds = rmfield(xds,'reward_EMG');
    
    xds.EMG_names = muscles;
    
    
    
    xds.processing(1) = struct('function','get_rewarded_trials',...
        'description','Extracted rewarded trials',...
        'processTime',datestr(now));
    xds.processing(2) = struct('function','trial_splitter_Ali',...
        'description','Clipped reward trials to 250 ms before and 750 ms after go cue',...
        'processTime',datestr(now));
   
    
    save([savedir,filesep,files{ii}],xds,'-v7.3');
    
end