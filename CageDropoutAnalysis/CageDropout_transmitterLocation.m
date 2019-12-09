%% CageDropout_transmitterLocation
%
% Take the locations of the transmitter as provided by deeplabcut and look
% at whenever we have a dropout


%% Get files
[csvFile, csvPath] = uigetfile('./*.csv');
[nevFile, nevPath] = uigetfile([csvPath,filesep,'*.nev']);
[tsFile, tsPath] = uigetfile([nevPath,filesep,'*.txt']);

csv = dlmread([csvPath,filesep,csvFile],',',3,0);
nev = openNEV([nevPath,filesep,nevFile],'nomat','nosave','noread'); % don't need the waveforms
ts = readtable([tsPath,filesep,tsFile]);
ts.Properties.VariableNames = {'ElapsedTime','ClockTime'};


% put the csv into the ts table just to make our life easier later on
ts.Dropped = zeros(length(ts.ElapsedTime),1);
ts.FrameNum = csv(:,1);
ts.orangeX = csv(:,2);
ts.orangeY = csv(:,3);
ts.orangeProb = csv(:,4);
ts.yellowX = csv(:,5);
ts.yellowY = csv(:,6);
ts.yellowProb = csv(:,7);


%% look through for the dropouts
dropoutThreshold = .01; % threshold for looking at dropouts, in seconds

dropoutIdx = find(diff(double(nev.Data.Spikes.TimeStamp)/30000) > dropoutThreshold); % what are the indices of the starts of the dropouts
dropoutStarts = double(nev.Data.Spikes.TimeStamp(dropoutIdx))/30000; % elapsed time for dropout start?
dropoutEnds = double(nev.Data.Spikes.TimeStamp(dropoutIdx+1))/30000; % " " " " end?
dropoutLengths = dropoutStarts - dropoutEnds; % length in seconds?


%% tape locations at dropoutTimes
clear ax

for ii = 1:length(dropoutLengths)
    ts.Dropped(ts.ElapsedTime>dropoutStarts(ii) & ts.ElapsedTime < dropoutEnds(ii)) = 1;
end

% 
% figure
% ax(1) = subplot(221);
% scatter(ts.yellowX(ts.Dropped & (ts.yellowProb > .95)),ts.yellowY(ts.Dropped & (ts.yellowProb > .95)),'.')
% xlabel('X location')
% ylabel('Y location')
% title('Yellow tape dropout location')
% 
% ax(2) = subplot(222);
% scatter(ts.yellowX(~ts.Dropped & (ts.yellowProb > .95)),ts.yellowY(~ts.Dropped & (ts.yellowProb > .95)),'.')
% xlabel('X location')
% ylabel('Y location')
% title('Yellow tape non-dropout location')
% 
% ax(3) = subplot(223);
% scatter(ts.orangeX(ts.Dropped & (ts.orangeProb > .95)),ts.orangeY(ts.Dropped & (ts.orangeProb > .95)),'.')
% xlabel('X location')
% ylabel('Y location')
% title('Orange tape dropout location')
% 
% ax(4) = subplot(224);
% scatter(ts.orangeX(~ts.Dropped & (ts.orangeProb > .95)),ts.orangeY(~ts.Dropped & (ts.orangeProb > .95)),'.')
% xlabel('X location')
% ylabel('Y location')
% title('Yellow tape non-dropout location')

figure
ax(1) = subplot(1,2,1)
scatter(ts.yellowX(~ts.Dropped & (ts.yellowProb > .95)),ts.yellowY(~ts.Dropped & (ts.yellowProb > .95)),'.')
hold on
scatter(ts.yellowX(ts.Dropped & (ts.yellowProb > .95)),ts.yellowY(ts.Dropped & (ts.yellowProb > .95)),'.')
xlabel('X location')
ylabel('Y location')
title('Yellow tape dropout location')

ax(2) = subplot(1,2,2)
scatter(ts.orangeX(~ts.Dropped & (ts.orangeProb > .95)),ts.orangeY(~ts.Dropped & (ts.orangeProb > .95)),'.')
hold on
scatter(ts.orangeX(ts.Dropped & (ts.orangeProb > .95)),ts.orangeY(ts.Dropped & (ts.orangeProb > .95)),'.')
xlabel('X location')
ylabel('Y location')
title('Orange tape dropout location')


for ii = 1:numel(ax)
    axes(ax(ii))
    ax(ii).XLim = [100 400];
    ax(ii).YLim = [100 400];
    axis square
end

Leefy


%%

xedges = [100:10:400];
yedges = [100:10:400];
indDropped = find(ts.Dropped & (ts.orangeProb>.95));
[orangeDropped,xedgesCalc,yedgesCalc,binX,binY] = histcounts2(ts.orangeX(indDropped),ts.orangeY(indDropped),xedges,yedges);
[orangeAll,xedgesCalcAll,yedgesCalcAll,binXAll,binYAll] = histcounts2(ts.orangeX(ts.orangeProb>.95),ts.orangeY(ts.orangeProb>.95),xedges,yedges);


figure
axx(1) = subplot(1,2,1);
imagesc(orangeDropped)
axx(2) = subplot(1,2,2);
imagesc(log(orangeDropped./orangeAll))

%%

figure
ax(1) = subplot(1,2,1);
scatter(ts.orangeX(~ts.Dropped & (ts.orangeProb > .95)),ts.orangeY(~ts.Dropped & (ts.orangeProb > .95)),'.')
hold on
scatter(ts.orangeX(ts.Dropped & (ts.orangeProb > .95)),ts.orangeY(ts.Dropped & (ts.orangeProb > .95)),'.')
xlabel('X location')
ylabel('Y location')
ax(1).XLim = [100 400];
ax(1).YLim = [100 400];
axis square
title('Orange tape dropout location')



ax(2) = subplot(1,2,2);
imagesc(orangeDropped(:,end:-1:1)')
% imagesc(orangeAll(:,end:-1:1)')
ax(2).XLabel = [];
ax(2).YLabel = [];
axis square
title('heatmap of dropout locations')
% title('heatmap of tape locations')


Leefy