%% Overview
% this is some analysis code for looking at the frequency and the length of
% different dropouts during cage recordings for different monkeys and
% transmitters. I spent too long fiddling with trying to get CDS to work
% properly, so I'm saying screw it and just using .nev directly.


%% add all necessary directories to the path
% so that this can be used on shared computers
if strcmp(getenv('computername'),'FSM8M1SMD2')
    addpath('C:\Users\klb807\Documents\git\ClassyDataAnalysis\lib\NPMK')
    addpath('C:\Users\klb807\Documents\git\proc-kevin\Helpful_Functions')
end
        
        
        

%% List of files
% The files I'm wanting to use, organized so that I can just use a subset
% at any moment

fileList = struct('monkey','','transmitter','',...
    'path','');

% Pop files
fileList(end+1) = struct('monkey','Pop','transmitter','SN017222',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN017222\Pop\20190812_Pop_Cage_001.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN017222',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN017222\Pop\20190812_Pop_Cage_002.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Pop\20190726_Pop_Cage_001.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Pop\20190726_Pop_Cage_002.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Pop\20190726_Pop_Cage_003.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Pop\20190726_Pop_Cage_004.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016152',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016152\Pop\20190814_Pop_Cage_001.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016152',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016152\Pop\20190814_Pop_Cage_002.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016152',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016152\Pop\20190814_Pop_Cage_003.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016153',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN16153\Pop\20190821_Pop_Cage_001.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016153',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN16153\Pop\20190821_Pop_Cage_002.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016149',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016149\Pop\20190426_Pop_Cage_001.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016149',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016149\Pop\20190426_Pop_Cage_002.nev');
fileList(end+1) = struct('monkey','Pop','transmitter','SN016149',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016149\Pop\20190426_Pop_Cage_003.nev');




% Greyson file list
fileList(end+1) = struct('monkey','Greyson','transmitter','SN017222',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN017222\Greyson\20190813_Greyson_Cage_001001.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Greyson\20190805_Greyson_Cage_002.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Greyson\20190805_Greyson_Cage_003.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Greyson\20190805_Greyson_Cage_004.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Greyson\20190805_Greyson_Cage_005.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Greyson\20190805_Greyson_Cage_006.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Greyson\20190805_Greyson_Cage_007.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016154',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016154\Greyson\20190805_Greyson_Cage_008.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016152',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016152\Greyson\20190816_Greyson_Cage_001.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016152',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016152\Greyson\20190816_Greyson_Cage_002.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016149',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016149\Greyson\20190304_Greyson_Cage_001.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016149',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016149\Greyson\20190304_Greyson_Cage_002.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016149',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016149\Greyson\20190304_Greyson_Cage_003.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016149',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016149\Greyson\20190304_Greyson_Cage_004.nev');
fileList(end+1) = struct('monkey','Greyson','transmitter','SN016149',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016149\Greyson\20190304_Greyson_Cage_006.nev');


% Han file list
fileList(end+1) = struct('monkey','Han','transmitter','SN017222',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN017222\Han\20190814_Han_Cage_001001.nev');
fileList(end+1) = struct('monkey','Han','transmitter','SN017222',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN017222\Han\20190814_Han_Cage_002002.nev');
fileList(end+1) = struct('monkey','Han','transmitter','SN016152',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016152\Han\20190821_Han_Cage_001.nev');
fileList(end+1) = struct('monkey','Han','transmitter','SN016152',...
    'path','C:\Users\klb807\Documents\Data\CageDropoutAnalysis\SN016152\Han\20190821_Han_Cage_002.nev');


% get rid of initial empty entry
fileList = fileList(2:end);


%% load data
% load the .mat file for the analysis, and check if we've already binned
% the data for the files in question. If not, bin from the .nev file and
% store it.

% load data file if it exists
dataFile = 'C:\Users\klb807\Documents\Data\CageDropoutAnalysis\dataFile.mat';
if ~exist(dataFile,'file')
    bd = struct('monkey','','transmitter','','recDate',nan,'path','',...
        'data',struct('binnedData',[],'dropoutLengths',[],'dropoutTimes',[]));
else
    load(dataFile);
end

% bin and add data if it hasn't been
for ii = 1:numel(fileList)
    disp(['Converting file ', num2str(ii),' of ',num2str(numel(fileList))])
    if ~any(contains({bd.path},fileList(ii).path))
        bzzd = numel(bd);
        bd(bzzd+1).monkey = fileList(ii).monkey;
        bd(bzzd+1).transmitter = fileList(ii).transmitter;
        bd(bzzd+1).path = fileList(ii).path;
        
        nev = openNEV(fileList(ii).path,'nomat','nosave');
        tt = 0:.01:nev.MetaTags.DataDurationSec;

        electrodes = unique(nev.Data.Spikes.Electrode);
        spikesDivided = nan(numel(electrodes),length(tt)-1);
        for jj = 1:numel(electrodes)
            spikesDivided(jj,:) = histcounts(double(nev.Data.Spikes.TimeStamp(nev.Data.Spikes.Electrode == electrodes(jj)))/30000,tt); % get a binned array of spikes
        end

        emptyBins = sum(spikesDivided) == 0; % find timepoints without firing on any electrode
        changes = find(diff(emptyBins)); % indices of whenever it changes from 0 to 1 or viceversa - meaning either firing or not
        lengthChanges = [changes numel(emptyBins)] - [0 changes]; % length of either being empty or not.
        dropoutLengths = lengthChanges(emptyBins(changes));
        dropoutTimes = tt((diff(emptyBins) == -1)); % get the times when it stops firing
        
        bd(bzzd+1).data.binnedData = spikesDivided;
        bd(bzzd+1).data.tt = tt(2:end);
        bd(bzzd+1).data.dropoutLengths = dropoutLengths * .01;
        bd(bzzd+1).data.dropoutTimes = dropoutTimes;
        bd(bzzd+1).data.meanDropLength = mean(dropoutLengths) *.01;
        bd(bzzd+1).data.percDrop = sum(emptyBins)/length(emptyBins);
        
        bd(bzzd+1).recDate = nev.MetaTags.DateTime;
    end
end

if isempty(bd(1).monkey) % get rid of empty initial entry
    bd = bd(2:end);
end

save(dataFile,'bd','-v7.3')
disp('Everything binned and saved');

%% Start plotting stuff

% reload it in case we're just running this part - so we don't have to
% rerun the previous section unless necessary
if ~exist('bd','var')
    dataFile = 'C:\Users\klb807\Documents\Data\CageDropoutAnalysis\dataFile.mat';
    load(dataFile)
end


% choose what variables to plot on -- make what we don't want into empty
% strings
% monkey: Pop, Greyson, Han
% transmitter: SN016154, SN016152, SN016153, SN017222, SN016149
monkey = 'Han';
transmitter = '';
path = '';

% get the subset of data that we want. This is so much easier in SQL!
if ~isempty(path)
    plotData = bd(strcmp({bd.path},path));
elseif ~isempty(monkey) && isempty(transmitter)
    plotData = bd(strcmp({bd.monkey},monkey));
elseif ~isempty(monkey) && ~isempty(transmitter)
        plotData = bd(strcmp({bd.monkey},monkey)&&strcmp({bd.transmitter},transmitter));
elseif isempty(monkey) && ~isempty(transmitter)
        plotData = bd(strcmp({bd.transmitter},transmitter));
end     
        
histData = [];
perc = [];
uDropLen = [];
for ii = 1:numel(plotData)
        histData = [histData, plotData(ii).data.dropoutLengths];
        perc = [perc, plotData(ii).data.percDrop];
        uDropLen = [uDropLen, plotData(ii).data.meanDropLength];
end
avPerc = mean(perc);
avMeanDropLength = mean(uDropLen);

subplot(2,1,1)
timeBins = 0:.01:1;
histogram(histData,timeBins,'Normalization','probability')
xlabel('Dropout Length (s)')
ylabel('Perc of incidences')
title(sprintf('Dropout lengths for Han. Average drop length %.02f sec; %.02f percent dropped',avMeanDropLength,avPerc*100)) % change this independently, it will be a pain to program.
subplot(2,1,2)
timeBins = 1:.1:10;
histogram(histData,timeBins,'Normalization','probability')
xlabel('Dropout Length (s)')
ylabel('Perc of incidences')
Leefy


