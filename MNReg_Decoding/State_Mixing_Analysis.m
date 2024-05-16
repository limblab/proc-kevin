% State mixing analysis
% 
% Take a look at the mixed predictions for online MNR sessions

% open everything
rec_dirs = {'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240102\';
            'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240103\';
%             'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240104\';
            'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240105\';
            'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240108\';
            'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240110\';
            'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240111\';
            'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240112\'};

save_dir = 'Z:\L_MillerLab\limblab\User_folders\Kevin\MNR_results';

for dd = 1:size(rec_dirs,1)

    % rec_dir = 'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240102\';
    rec_dir = rec_dirs{dd};
    rec_date = datestr(datenum(regexp(rec_dir,'\d{8}','match'),'yyyyMMdd'),'yyyy-MM-dd');
    % get all of the MNR decoder setups
    MNR_list = dir([rec_dir,'*MNRDecoder.mat']);
    % since we have spikes in different places in different folders...
    spike_list = dir([rec_dir, '*Spikes.txt']);
    spike_list = [spike_list, dir([rec_dir, 'brain control nev*\*Spikes.txt'])];


    estCats = cell(size(MNR_list));
    wCats = cell(size(MNR_list));
    for ii = 1:length(MNR_list)
        % load the decoder
        decoder = load([rec_dir,MNR_list(ii).name]).dpars_reward;

        % load in the spikes
        rec_time = regexp(MNR_list(ii).name, '_\d{4}_','match'); % find the timestamp label
        spike_file = spike_list(cellfun(@length, regexp({spike_list.name},rec_time,'match')) == 1); % get the matching spike file
        spikes = load([spike_file.folder, filesep, spike_file.name]);

        % pull out the timestamps
        spike_ts = spikes(:,1);
        spikes = spikes(:,2:end);

        % I'm sure there's a better way than looping through rows, but here we
        % are 
        estCats{ii} = zeros(size(decoder.A,1),size(spikes,1));
        wCats{ii} = zeros(size(decoder.A,1),size(spikes,1));
        for jj = 1:size(spikes,1)
            estCats_temp = decoder.mnrModel(spikes(jj,:)',decoder.A);
            estCats{ii}(:,jj) = estCats_temp;
            wCats_temp = max(0,min(1, (estCats_temp+decoder.mixCat-1)/(2*decoder.mixCat-1) ));
            wCats{ii}(:,jj) = wCats_temp/sum(wCats_temp);      % renormalize so all weights sum to 1
        end

    end

    % concatenate all of the wCats
    wCat_summary = zeros(size(decoder.A,1),sum(cellfun(@length,wCats))); % create a single array
    i_Cat = 1;
    for ii = 1:numel(wCats)
        wCat_summary(:,i_Cat:i_Cat+length(wCats{ii})-1) = wCats{ii};
        i_Cat = i_Cat + length(wCats{ii}); 

    end

    % plot the histogram of the maximum weighted probability for each point in time
    figure;
    ax = gca;
    disp(size(wCat_summary))
    hh = histogram(ax, max(wCat_summary, [], 1), 0:.05:1, 'normalization','pdf');
    title(ax, [rec_date, ' largest selection weight']);
    set(ax,'box','off')


end