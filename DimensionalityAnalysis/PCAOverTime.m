    %% PCAOverTime
% Script to look at the number of dimensions of PCA describe a certain
% portion of the variance over time. 
%
% Thoughts on how I'm gonna do this:
% I'm gonna start with files with video at the same time, so that I can
% compare what the monkey is doing with variance
%
% I'm gonna try splitting the file into 90 second chunks with 30-seconds of
% overlap, and 15 second chunks with 5 seconds of overlap, and see what
% shakes out. That might be interesting.
%
% The initial threshold I'm going to use is 85%, and we'll run from there. 
%
% This is all going to be from firing rates.
% 
% I should also take a look at the quality of the signals -- multi channel
% artifacts, excessively high firing rates or high amplitude signals. I'm

% Current file I'm looking at: Jango june 22 2017, #1
%% Add script location to current path to call on any dependent functions
fullFileLocn = mfilename('fullpath');
fullFileLocn = strsplit(fullFileLocn,filesep);
fullFileLocn = strjoin(fullFileLocn(1:end-1),filesep);
addpath(fullFileLocn)

%% Load file as necessary
if strcmp(getenv('computername'),'INTERNETMACHINE')
    cd C:\Users\Kevin\Documents\Data;
    spikes = openNEV([pwd,filesep,'20170622_Jango_cage_key_onlyNeurons_1.nev'],'nosave','nomat','uV');
elseif strcmp(getenv('computername'),'KEVIN-PC')
    cd D:\Jango\InCage\20170622\;
    spikes = openNEV([pwd,filesep,'20170622_Jango_cage_key_onlyNeurons_2.nev'],'read','nosave','nomat','uV');
end

% list of all channels and associated units
units = [(1:96)',zeros(96,1)];
for ii = 1:size(units,1)
    fillMat = [repmat(units(ii,1),spikes.ElectrodesInfo(ii).Units+1,1),0:spikes.ElectrodesInfo(ii).Units]; % repeat matrix for number of units that exist in the channel
    units = [units(1:ii-1,:);fillMat;units(ii+1:end,:)];
end
clear fillMat

% make a cell matrix of spiking for each unit
spikes.Data.Spikes.perUnit = cell(size(units,1),3);
for ii = 1:size(units,1)
    spikes.Data.Spikes.perUnit{ii,1} = units(ii,:); % which unit is this?
    % get all of the matching timestamps
    spikes.Data.Spikes.perUnit{ii,2} = double(spikes.Data.Spikes.TimeStamp(...
        (spikes.Data.Spikes.Electrode==units(ii,1))&...
        (spikes.Data.Spikes.Unit==units(ii,2))))'/30000;
    % get all of the units, since we want to remove artifacts later
    spikes.Data.Spikes.perUnit{ii,3} = spikes.Data.Spikes.Waveform(:,...
        (spikes.Data.Spikes.Electrode==units(ii,1))&...
        (spikes.Data.Spikes.Unit==units(ii,2)))';
end

%% Bin it all! - no artifact removal
binWidth = .05;
binTimes = binWidth:binWidth:spikes.MetaTags.DataDurationSec; % FR times
spikes.Data.Spikes.BinFR = zeros(length(binTimes),size(units,1));

% bin it all!
for ii = 1:size(units,1)
        spikes.Data.Spikes.BinFR(:,ii) = histcounts(...
            spikes.Data.Spikes.perUnit{ii,2},[0,binTimes])/binWidth;
end



%% removing xchan artifacts, then bin it -- overwrites previous binning

% firing rate and xchannel threshold values
xcThresh = 30;
frThresh = 200;

% bin into short bins for xchan artifact removal
shortBinTimes = 1/2000:1/2000:spikes.MetaTags.DataDurationSec; % for xChan artifacts

% bin spikes into .5 ms bins
shortBin = zeros(length(shortBinTimes),size(units,1)); % preallocate the (short bin) matrix
for ii = 1:size(units,1)
    shortBin(:,ii) = histcounts(spikes.Data.Spikes.perUnit{ii,2},'BinEdges',[0,shortBinTimes]);
end

% windowing with the bins around present. .5*bin(t-1) + bin(t) +.5*bin(t+1)
artifactBins = [zeros(1,96);shortBin(1:end-1,:)]+...
    shortBin+...
    [shortBin(2:end,:);zeros(1,96)];
artifactBins = artifactBins~=0; % did a unit fire in that period of time?

% drop anything over the threshold of 30 chans in 1 ms
shortBin(sum(artifactBins,2)>xcThresh,:) = 0;

% now bin it into longer bins.
binWidth = .05;
binTimes = binWidth:binWidth:spikes.MetaTags.DataDurationSec; % FR times
spikes.Data.Spikes.BinFR = zeros(length(binTimes),size(units,1));
for ii = 1:length(binTimes)
    spikes.Data.Spikes.BinFR(ii,:) = sum(shortBin((ii-1)*100+1:ii*100,:),1)/binWidth;
end

% get rid of any firing rate over a specific threshold
spikes.Data.Spikes.BinFR(spikes.Data.Spikes.BinFR>frThresh) = 0; % could change this to a cap if we wanted, but I'm assuming it's just garbage for the mo'


clear artifactBins shortBin*
%% Run a gaussian kernal over the whole thing
gaussWidth = [-3*binWidth:binWidth:3*binWidth]; % for 3*SD
gaussPDF = normpdf(gaussWidth,0,binWidth); % bell with mu = 0, SD = binWidth.
for ii = 1:size(units,1)
    spikes.Data.Spikes.BinFR(:,ii) = conv(spikes.Data.Spikes.BinFR(:,ii),gaussPDF,'same');
end


%% sqrt of the counts
% to convert from poisson distrib to a gaussian, supposedly...
spikes.Data.Spikes.BinFR = sqrt(spikes.Data.Spikes.BinFR);


%% PCA time! 
% through the artifact ridden signals

% window length = 90 s
% window overlap = 30 s
% windowShort = windowLength - windowOver
windowShort = 15;
windowOver = 0;


[coeffTotal,scoreTotal,latentTotal,~,vaTotal,mu] = pca(spikes.Data.Spikes.BinFR);
vafMeanTotal = zeros(96,1);
for jj = 1:96
    recData = scoreTotal(:,1:jj)*coeffTotal(:,1:jj)' + repmat(mu,size(spikes.Data.Spikes.BinFR,1),1);
    vafMeanTotal(jj) = 1-mean(mean((spikes.Data.Spikes.BinFR - recData).^2)./...
        var(spikes.Data.Spikes.BinFR));
end
% we're gonna run this for the length of the file, divided into 90 second
% segments
coeff = {}; score = {}; latent = {}; ve = {}; vafmean = {};mu = zeros(1,96);

for ii = 1:(floor((length(spikes.Data.Spikes.BinFR)-windowOver*20)/((windowShort)*20))-1)
    timeSeg = ((ii-1)*windowShort*20+1):(windowShort*20*ii+windowOver*20);
    [coeff{ii},score{ii},~,~,ve{ii},mu(ii,:)] = pca(spikes.Data.Spikes.BinFR(timeSeg,:));
    for jj = 1:96
        recData = score{ii}(:,1:jj)*coeff{ii}(:,1:jj)' + repmat(mu(ii,:),length(timeSeg),1);
        vafmean{ii,jj} = 1 - mean(... 
            (mean((spikes.Data.Spikes.BinFR(timeSeg,:) - recData).^2)./ ...
            var(spikes.Data.Spikes.BinFR(timeSeg,:))));

    end
end


% figure
% ln1 = plot([1:96],[tril(ones(96,96),0)*vaTotal(1:96)],'LineWidth',1.5,'Color','k');
% hold on
% for ii = 1:length(ve)
%     ln2 = plot(1:96,[tril(ones(96,96),0)*ve{ii}(1:96)],'LineWidth',.25,'Color','b');
% end
% plot(0:96,100*ones(97,1),'LineStyle','--')
% xlabel('Principal Components')
% ylabel('Percentage of VE')
% legend([ln1,ln2],'Whole file','90 second segments')
% 
% Leefy


figure
hold on
Lmain = plot(1:96,vafMeanTotal,'LineWidth',2,'Color','k','DisplayName','Full Recording');
for ii = 1:size(vafmean,1)
    Lseg(ii) = plot(1:96,[vafmean{ii,:}],'LineWidth',.25,'Color','b','DisplayName',['Segment ',num2str(ii)]);
    timeFrame = datenum(spikes.MetaTags.DateTime) + [datenum(0,0,0,0,0,windowShort*(ii-1)),...
        datenum(0,0,0,0,0,windowShort*ii+windowOver)]; % timeFrame length
    set(Lseg(ii),'UserData',struct('timeFrame',timeFrame,'segment',ii));
    set(Lseg(ii),'ButtonDownFcn',@PCALinePopup)
end
% legend show
plot(0:96,[1;.85;.6]*ones(1,97),'LineStyle','--')
set(gca,'YLim',[0 1.2])
xlabel('# of Principal Components')
ylabel('VAF')

Leefy

