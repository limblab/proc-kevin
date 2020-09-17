%% CageDropout_singleFile
%
% Calculates the frequency and length of dropouts.
% Dropouts are defined in this case as any time that there aren't any
% spikes on any channels for longer than a defined threshold. Standard
% threshold is 10 ms, which should be safe
%
% Provided without any guarantees etc etc. Feel free to update and pass
% this file on, let me know if you find any issues so that I can update my
% own code.
%
% Kevin Bodkin
% September 2019
% kevinbodkin2017@u.northwestern.edu


%% open the .nev file
% these are written with R2017+ versions of uigetfile.

if ~exist('basedir')
    basedir = '.';
end

[nevFN,nevPN] = uigetfile([basedir,filesep,'*.nev'],'Spiking file');
basedir = nevPN;
fn = [nevPN,nevFN];
nev = openNEV(fn,'nomat','nosave','noread');

nev.Data.Spikes.TimeStamp = nev.Data.Spikes.TimeStamp(nev.Data.Spikes.Electrode ~= 96); % gets rid of electrode 96, which sends meta data as of the most recent firmware

%% find dropouts
clc
displayGap = '\n-----------------------------------------------------------\n';
fprintf(displayGap)
fprintf('%s\n%s\n',nevFN,nev.MetaTags.DateTime)

dropoutThreshold = .01; % threshold for looking at dropouts, in seconds

dropoutIdx = find(diff(double(nev.Data.Spikes.TimeStamp)/30000) > dropoutThreshold); % what are the indices of the starts of the dropouts
dropoutStarts = double(nev.Data.Spikes.TimeStamp(dropoutIdx))/30000; % elapsed time for dropout start
dropoutEnds = double(nev.Data.Spikes.TimeStamp(dropoutIdx+1))/30000; % " " " " end
dropoutLengths = dropoutEnds - dropoutStarts; % length in seconds


%% Summary statistics of dropouts
percDrop = 100*sum(dropoutLengths)/nev.MetaTags.DataDurationSec; % percentage of total recording time that's a "dropout"
numDrop = length(dropoutStarts); % number of dropouts


fprintf('For threshold length: %0.2f\n',dropoutThreshold)
fprintf('Total percentage dropped signal: %0.3f%% \n',percDrop);
fprintf('Number of dropouts: %i \n',numDrop);
fprintf('Longest dropout length: %0.3f seconds\n',max(dropoutLengths));
fprintf('Mean dropout length: %0.3f seconds\n',mean(dropoutLengths));
fprintf(displayGap)

%% Plot histograms of the dropout lengths

ff = figure;
subplot(2,1,1)
timeBins = 0:.01:1;
histogram(dropoutLengths,timeBins,'Normalization','count')
xlabel('Dropout Length (s)')
ylabel('Count')
title(['Dropout lengths between ', num2str(100*dropoutThreshold), ' ms and 1 s'])
subplot(2,1,2)
timeBins = 1:.1:10;
histogram(dropoutLengths,timeBins,'Normalization','count')
xlabel('Dropout Length (s)')
ylabel('Count')
title('Dropout lengths between 1 and 10 seconds')

% clean up the figure so it looks pretty
for a = 1:length(ff.Children) % for all axes on the figure
    ax = ff.Children(a);
    if isa(ax,'matlab.graphics.axis.Axes')
        ax.TickDir = 'out';
        ax.Box = 'off';
    elseif isa(ax,'matlab.graphics.illustration.Legend')
        ax.Box = 'off';
    end
    
    if ax.YLim(2) < 5 % set the ylim to at least 5 
        ax.YLim(2) = 5;
    end
end
