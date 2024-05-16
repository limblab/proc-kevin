% State mixing analysis
% 
% Take a look at the mixed predictions for online MNR sessions

% open everything
rec_dir = 'Z:\L_MillerLab\data\Tot_20K4\Cerebus_Data\20240102\';
% get all of the MNR decoder setups
MNR_list = dir([rec_dir,'*MNRDecoder.mat']);
spike_list = dir([rec_dir, '*Spikes.txt']);

estCats = cell(size(MNR_list));
for ii = 1:length(MNR_list)
    % load the decoder
    decoder = load([rec_dir,MNR_list(ii).name]).dpars_reward;
    
    % load in the spikes
    rec_time = regexp(MNR_list(ii).name, '_\d{4}_','match'); % find the timestamp label
    spike_fn = spike_list(cellfun(@length, regexp({spike_list.name},rec_time,'match')) == 1).name; % get the matching spike file
    spikes = load([rec_dir, spike_fn]);
    
    % pull out the timestamps
    spike_ts = spikes(:,1);
    spikes = spikes(:,2:end);
    
    % I'm sure there's a better way than looping through rows, but here we
    % are
    estCats{ii} = zeros(size(decoder.A,1),size(spikes,1));
    for jj = 1:size(spikes,1)
        estCats(:,jj) = decoder.mnrModel(spikes(jj,:)',decoder.A);
    end
        
end