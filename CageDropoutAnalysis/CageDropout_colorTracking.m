% pick the .nev and the associated video
[nevFN,nevPN] = uigetfile('*.nev','Spiking file');
fn = [nevPN,nevFN];


[vidFN,vidPN] = uigetfile({'*.avi;*.mp4'},'Select a video to subtitle');
frameNumFN = strsplit(vidFN,'.'); % frame number text files
frameImDir = [vidPN,strjoin(frameNumFN(1:end-1))]; % individual frames
frameNumFN = [vidPN,strjoin(frameNumFN(1:end-1),'.'),'.txt']; %
if ~exist(frameNumFN,'file')
    error('We need timestamps for this video')
end


%% bin the nev 

binLength = .06;
nev = openNEV(fn,'nomat','nosave');
tt = 0:.06:nev.MetaTags.DataDurationSec;

electrodes = unique(nev.Data.Spikes.Electrode);
spikesDivided = nan(numel(electrodes),length(tt)-1);
for jj = 1:numel(electrodes)
    spikesDivided(jj,:) = histcounts(double(nev.Data.Spikes.TimeStamp(nev.Data.Spikes.Electrode == electrodes(jj)))/30000,tt); % get a binned array of spikes
end

emptyBins = sum(spikesDivided) == 0; % find timepoints without firing on any electrode


%% find the associated frames
tFID = fopen(frameNumFN);
timeStamps = textscan(tFID,'%f %s');
fclose(tFID);

% sync up the video time - assume that it's meant to be recording at 30 hz
timeStamps = timeStamps{1}; % grab the timestamp of frame
timeStamps(:,2) = zeros(size(timeStamps,1),1); % flag for if the spiking was dropped or not.


% find the binnedRate timestamp that's closest to each timestamp of the
% video, and see whether there's firing or not.
for ii = 1:size(timeStamps,1)
    [~,ttInd] = min(abs(tt(1:end-1)-timeStamps(ii,1)));
    timeStamps(ii,2) = emptyBins(ttInd);
end


cutFrames = find(timeStamps(:,2)); % the frame number associated with each dropout
cutFrames = cellfun(@num2str,num2cell(cutFrames),'UniformOutput',false);
%% Split the worthwhile timeframes out of the video

% make the folder we need
system(['mkdir ' frameImDir])

% run ffmpeg to extract the frames we want
query = ['ffmpeg -i ',vidPN,filesep,vidFN,' -vf select=''eq(n\,',...
    strjoin(cutFrames,')+eq(n\\,'),')'' -vsync 0 -frame_pts 1 ',...
    frameImDir,filesep,'%06d.bmp']; % the command
system(query) % this will probably take a minute or two


%% find the locations for the different colors of tape

dropoutXYSizes = [sum(timeStamps(ii,3)), 2]; % size = # dropout frames, xy

% each tape color xy location
xyYellow = nan(dropoutXYSizes);
xyOrange = nan(dropoutXYSizes);
xyBlue = nan(dropoutXYSizes);
xyGreen = nan(dropoutXYSizes);

% colorthresholds for each image
threshYellow = nan;
threshOrange = nan;
threshBlue = nan;
threshGreen = nan;

for ii = 1:size(timeStamps,1)
    if timeStamps(ii,3)
        changeFrame = [frameImDir,filesep,num2str(ii,'%06i'),'.jpg'];
        img = imread(changeFrame);
        
        
    end
end