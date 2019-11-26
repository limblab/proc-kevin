%% Pulling out and recoloring frames with dropout


% pick the .nev and the associated video
[nevFN,nevPN] = uigetfile('*.nev','Spiking file');
fn = [nevPN,nevFN];


[vidFN,vidPN] = uigetfile({'*.avi;*.mp4'},'Select a video to subtitle');
frameNumFN = strsplit(vidFN,'.'); % frame number text files
frameImDir = [vidPN,strjoin(frameNumFN(1:end-1))]; % individual frames
frameNumFN = [vidPN,strjoin(frameNumFN(1:end-1),'.'),'.txt']; %
if ~exist(frameNumFN,'file')
    error('There needs to be a text file with frame timestamps associated with this video.')
end



%% bin the nev as needed
nev = openNEV(fn,'nomat','nosave');
tt = 0:.01:nev.MetaTags.DataDurationSec;

electrodes = unique(nev.Data.Spikes.Electrode);
spikesDivided = nan(numel(electrodes),length(tt)-1);
for jj = 1:numel(electrodes)
    spikesDivided(jj,:) = histcounts(double(nev.Data.Spikes.TimeStamp(nev.Data.Spikes.Electrode == electrodes(jj)))/30000,tt); % get a binned array of spikes
end

emptyBins = sum(spikesDivided) == 0; % find timepoints without firing on any electrode


%% load in the timeframes from the video
% and turn into an array with the timestamp and the video time for each
% frame number

% load the file
tFID = fopen(frameNumFN);
timeStamps = textscan(tFID,'%f');
fclose(tFID);

% sync up the video time - assume that it's meant to be recording at 30 hz
timeStamps = timeStamps{:};
timeStamps(:,2) = (1:length(timeStamps))/30;
timeStamps(:,3) = zeros(size(timeStamps,1),1); % flag for if the spiking was dropped or not.

% find the binnedRate timestamp that's closest to each timestamp of the
% video, and see whether there's firing or not.
for ii = 1:size(timeStamps,1)
    [~,ttInd] = min(abs(tt-timeStamps(ii,1)));
    timeStamps(ii,3) = emptyBins(ttInd);
    if emptyBins(ttInd)
        changeFrame = [frameImDir,filesep,num2str(ii,'%06i'),'.jpg'];
        img = imread(changeFrame);
        imgGray = rgb2gray(img);
        movefile(changeFrame,[frameImDir,filesep,num2str(ii),'_backup.jpg']);
        imwrite(imgGray,winter(),changeFrame);
    end
end


sprintf('%0.2f percent of the file was dropouts.',sum(emptyBins)/length(emptyBins) * 100)
% % find the beginning and end of dropouts in "Video Time"
% startDrops = find(diff(timeStamps(:,3)) == -1);
% finDrops = find(diff(timeStamps(:,3)) == 1);


%% restore backup images
dd = dir([frameImDir,filesep,'*_backup.jpg']);
whos dd
for ii = 1:numel(dd)
rname = strsplit(dd(ii).name,'_backup.jpg');
movefile([dd(ii).folder,filesep,dd(ii).name],[dd(ii).folder,filesep,rname{1},'.jpg']);
end


