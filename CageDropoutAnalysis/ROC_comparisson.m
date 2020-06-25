%% ROC dropout threshold
%
% Looking at false positives vs false negatives for different lengths of
% dropout thresholds for the ISI dropout script.
%
% 


%% load files

[nevFName,pathstr] = uigetfile('*nev','.nev to compare');
[~,fname,ext] = fileparts(nevFName);

if exist([pathstr,filesep,fname,'.ns6'],'file')
   nsx = openNSx([pathstr,filesep,fname,'.ns6'],'read','precision','short');
elseif exist([pathstr,filesep,fname,'.ns5'],'file')
   nsx = openNSx([pathstr,filesep,fname,'.ns5'],'read','precision','short');
else
    error('there isn''t a corresponding .ns5 or .ns6 for this recording')
end

% drop channel 96 to deal with new firmward
actualData = [nsx.ElectrodesInfo.ElectrodeID] ~= 96;
nsx.Data = nsx.Data(actualData,:);
    

% load .nev file
nev = openNEV([pathstr,filesep,nevFName],'nomat','nosave');
nev.Data.Spikes.TimeStamp = nev.Data.Spikes.TimeStamp(nev.Data.Spikes.Electrode ~= 96);
nev.Data.Spikes.Electrode = nev.Data.Spikes.Electrode(nev.Data.Spikes.Electrode ~= 96);

%% .nsx based analysis

lock = zeros(size(nsx.Data));
for ii = 1:size(nsx.Data,1)
    lock(ii,:) = [1,abs(diff(nsx.Data(ii,:)))>1]; % is the signal changing? Consider it a signal lock
end

% If we have three samples in a row that have difference less than the
% threshold
dropVecCont = (sum(lock,1) == 0); % Are all channels blank?
dropVecCont(2:end-1) = (dropVecCont(1:end-2) & dropVecCont(2:end-1) & dropVecCont(3:end)); % For three in a row?
dropVecContDwn = decimate(double(dropVecCont),30) > .6; % downsample from 30k to 1k after filtering, then set a threshold if 60% is dropped

%% spike based analysis

dropThresh = [ 0.001, 0.002, 0.005, 0.01, 0.02, 0.05]; % length (in seconds) of ISI definition of "dropouts"

% a struct with entries for each threshold value
dropStruct = struct('dropThresh',[],'times',[],'dropVec',[],'fPos',[],'fNeg',[]);


for ii = 1:length(dropThresh)
    dropoutIdx = find(diff(double(nev.Data.Spikes.TimeStamp)/30000) > dropThresh(ii)); % what are the indices of the starts of the dropouts
    dropoutStarts = double(nev.Data.Spikes.TimeStamp(dropoutIdx))/30000; % elapsed time for dropout start
    dropoutEnds = double(nev.Data.Spikes.TimeStamp(dropoutIdx+1))/30000; % " " " " end
    
    dropStruct(ii).dropThresh = dropThresh(ii);
    dropStruct(ii).times = .001:.001:nev.MetaTags.DataDurationSec;
    dropStruct(ii).dropVec = zeros(size(dropStruct(ii).times));
    
    for jj = 1:length(dropoutStarts)
        dropStruct(ii).dropVec = dropStruct(ii).dropVec | ...
            ((dropStruct(ii).times > dropoutStarts(jj)) & (dropStruct(ii).times < dropoutEnds(jj)));
    end
    
    
end
