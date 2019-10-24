%% open the .nev file

if ~exist('LD')
    LD = '.';
end

[nevFN,nevPN] = uigetfile([LD,filesep,'*.nev'],'Spiking file');
LD = nevPN;
fn = [nevPN,nevFN];
nev = openNEV(fn,'nomat','nosave');


%%
clc
fprintf('%s\n%0.2f',nevFN,nev.MetaTags.DateTime)
binLength = [.01 .06];
for ii = 1:length(binLength)
%% bin the spikes -- this way we can try a bunch of different bin lengths
% binLength = .06;
tt = 0:binLength(ii):nev.MetaTags.DataDurationSec;

electrodes = unique(nev.Data.Spikes.Electrode);
spikesBinned = nan(numel(electrodes),length(tt)-1);
for jj = 1:numel(electrodes)
    spikesBinned(jj,:) = histcounts(double(nev.Data.Spikes.TimeStamp(nev.Data.Spikes.Electrode == electrodes(jj)))/30000,tt); % get a binned array of spikes
end

emptyBins = sum(spikesBinned) == 0; % find timepoints without firing on any electrode

% dropoutIDx = find(diff(double(nev.Data.Spikes.TimeStamp)/33000)>(binLength(ii))); % index values of timesteps with too large of spaces before the next one.
% dropoutStarts = double(nev.Data.Spikes.TimeStamp(dropoutIDx))/33000; % The beginning of the 
% dropoutEnds = double(nev.Data.Spikes.TimeStamp(dropoutIDx+1))/33000; % the next timestamp, aka the end of the drop

%% Calculate the statistics of dropouts

dropoutStarts = find(diff(emptyBins) == 1); % shifting from one to zero
dropoutEnds = find(diff(emptyBins) == -1); % shifting from zero to one

% if we have a dropout that starts or ends on the edge of the recording
if dropoutStarts(1) > dropoutEnds(1)
    dropoutStarts = [1 dropoutStarts];
end
if dropoutEnds(end) < dropoutStarts(end)
    dropoutEnds = [dropoutEnds numel(dropoutEnds)];
end

dropoutLengths = dropoutEnds - dropoutStarts;

displayGap = '\n-----------------------------------------------------------\n';
fprintf(displayGap)
fprintf('For bin length: %0.2f\n',binLength(ii))
fprintf('Total percentage dropped signal: %0.3f%% \n',sum(emptyBins)/length(emptyBins)*100);
fprintf('Number of dropouts: %i \n',length(dropoutStarts));
fprintf('Longest dropout length: %0.3f seconds\n',max(dropoutLengths)*binLength(ii));
fprintf('Mean dropout length: %0.3f seconds\n',mean(dropoutLengths)*binLength(ii));
fprintf(displayGap)

% 
% 
% displayGap = '\n-----------------------------------------------------------\n';
% fprintf(displayGap)
% fprintf('For bin length: %0.2f\n',binLength(ii))
% fprintf('Total percentage dropped signal: %0.3f%% \n',sum(dropoutLengths)/nev.MetaTags.DataDurationSec);
% fprintf('Number of dropouts: %i \n',length(dropoutStarts));
% fprintf('Longest dropout length: %0.3f seconds\n',max(dropoutLengths));
% fprintf('Mean dropout length: %0.3f seconds\n',mean(dropoutLengths));
% fprintf(displayGap)


end