function bootstrap_PCA_File_Lengths(currfile,timeLengths,artifactRej)


% script to run PCA over segments of data of specific lengths, but using
% bootstrap to gather segments of data.


%% load a specific current file
% currfile = 'D:\Jango\BMI-EMGs\20170104\Jango_20170104_WFiso_R10T4_001.nev';


spikes = openNEV(currfile,'nomat','nosave');
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
if ~artifactRej

    binWidth = .05;
    binTimes = binWidth:binWidth:spikes.MetaTags.DataDurationSec; % FR times
    spikes.Data.Spikes.BinFR = zeros(length(binTimes),size(units,1));

    % bin it all!
    for ii = 1:size(units,1)
            spikes.Data.Spikes.BinFR(:,ii) = histcounts(...
                spikes.Data.Spikes.perUnit{ii,2},[0,binTimes])/binWidth;
    end



%% removing xchan artifacts, then bin it -- overwrites previous binning

else

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


    clear artifactBins shortBin* xcThresh frThresh 

end

%% sqrt of the counts
% to convert from poisson distrib to a gaussian, supposedly...
spikes.Data.Spikes.BinFR = sqrt(spikes.Data.Spikes.BinFR);

%% Run a gaussian kernal over the whole thing
gaussWidth = [-3*binWidth:binWidth:3*binWidth]; % for 3*SD
gaussPDF = normpdf(gaussWidth,0,binWidth); % bell with mu = 0, SD = binWidth.
for ii = 1:size(units,1)
    spikes.Data.Spikes.BinFR(:,ii) = conv(spikes.Data.Spikes.BinFR(:,ii),gaussPDF,'same');
end




%% clear everything except binned FR, binWidth and binTimes
binFR = spikes.Data.Spikes.BinFR;
% binFR = binFR(:,[1:66,68,69,71:95]);

clear spikes gauss* 

%% PCA for the full length file

[coeffFull,scoreFull,eigFull] = pca(binFR);
VAFFull = cumsum(eigFull)/sum(eigFull);
fullSixty = find(VAFFull>.6,1);
fullEighty = find(VAFFull>.8,1);


%% structure for the bootstrapped dim numbers to achieve 60% and 80% VAF

numBoots = 100; % number of times to run the bootstrap values

eigDim = struct('Length',0,'sixty',nan(1,numBoots),'eighty',nan(1,numBoots));

%% ju lee, do the thing!


%lengths in seconds
% timeLengths = [900,450,[120:-10:30],15,5,4];




for ii = 1:length(timeLengths)
    eigDim(ii).Length = timeLengths(ii);
    for jj = 1:numBoots
        inds = randi(size(binFR,1),timeLengths(ii)/binWidth,1);
        [~,~,eigs] = pca(binFR(inds,:));
        perc = cumsum(eigs)/sum(eigs);
        eigDim(ii).sixty(jj) = find(perc>.6,1);
        eigDim(ii).eighty(jj) = find(perc>.8,1);
    end
end


%% plot this shiz

% meanSixty = nan(length(timeLengths),1);
% meanEight = nan(length(timeLengths),1);


meanSixty = mean(reshape([eigDim.sixty],numBoots,length(timeLengths)),1);
meanEighty = mean(reshape([eigDim.eighty],numBoots,length(timeLengths)),1);


imageName = strsplit(currfile,'.');
imageName = imageName{1:end-1};
imageName = strsplit(imageName,filesep);
imageName = imageName{end};



figure
plot([eigDim.Length],meanSixty,'LineWidth',2,'DisplayName','Sixty Percent Variance')
hold on
plot([eigDim.Length],meanEighty,'LineWidth',2,'DisplayName','Eighty Percent Variance')
plot([0 max(timeLengths)],ones(2,1)*fullSixty,'LineStyle','--','DisplayName','Full PCA sixty')
plot([0 max(timeLengths)],ones(2,1)*fullEighty,'LineStyle','--','DisplayName','Full PCA eighty')
legend('show')
xlabel('Time(s)')
ylabel('Dimensions')
title(imageName)
set(gca,'YLim',[0 100])
Leefy




end