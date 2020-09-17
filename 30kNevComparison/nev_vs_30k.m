% Comparing the 30khz vs nev data recorded on day
% because Chethan said we should

% first three will have basic settings with different threshold multipliers
% #1 *should* be identical to what we collected in the .nev
settings = struct(...
    'commonModeAverage',false,...
    'noncausalFilter', false,...
    'filterFreqs', [250, 5000],...
    'thresholdMult', 4.5);

settings(2) = struct(...
    'commonModeAverage',false,...
    'noncausalFilter', false,...
    'filterFreqs', [250, 5000],...
    'thresholdMult', 3.5);

settings(3) = struct(...
    'commonModeAverage',false,...
    'noncausalFilter', false,...
    'filterFreqs', [250, 5000],...
    'thresholdMult', 5.5);

% next filtered with a causal filter
settings(4) = struct(...
    'commonModeAverage',false,...
    'noncausalFilter', true,...
    'filterFreqs', [250, 5000],...
    'thresholdMult', 4.5);

% subtraction of common mode average
settings(5) = struct(...
    'commonModeAverage',true,...
    'noncausalFilter', false,...
    'filterFreqs', [250, 5000],...
    'thresholdMult', 4.5);

% then finally both
settings(6) = struct(...
    'commonModeAverage',true,...
    'noncausalFilter', true,...
    'filterFreqs', [250, 5000],...
    'thresholdMult', 4.5);


% commonModeAverage = false;
% noncausalFilter = false;
% filterFreqs = [250, 5000];
% thresholdMult = 4.5;
% 
% binLength = .05; % bin length in seconds

%% Files we want to load
[ns6File,ns6Path] = uigetfile('.\*.ns6','Select 30 khz data','MultiSelect','on');
% splitNSx(5)
[nevFile,nevPath] = uigetfile([ns6Path,filesep,'*.nev'],'Threshold crossing data');
[ns3File,ns3Path] = uigetfile([ns6Path,filesep,'*.ns3'],'Select EMG Data');
    
nevData = openNEV([nevPath,filesep,nevFile],'nosave','nomat');
% ns3Data = openNSx([ns3Path,filesep,ns3File]);

%% try filtering the ns6Data in a couple different ways

% running through all of the different settings
for kk = 1:numel(settings)
    sprintf('Converting settings group %i of %i',kk,numel(settings))
    
    
    % this is to run it through all of the different files
    if ~iscell(ns6File)
        ns6File = {ns6File};
    end

    ns6BaseFilename = strsplit(ns6File{1},'-s');
    ns6BaseFilename = ns6BaseFilename{1};

    if settings(kk).commonModeAverage
        ns6BaseFilename = [ns6BaseFilename,'_subtractCommon'];
    end
    if settings(kk).noncausalFilter
        ns6BaseFilename = [ns6BaseFilename,'_noncausal'];
    end
%     ns6BaseFilename = [ns6BaseFilename,'_thresh',num2str(settings(kk).thresholdMult),'.mat'];
    ns6NevFilename = [ns6BaseFilename,'_thresh',num2str(settings(kk).thresholdMult),'.nev'];


    spikes30k = struct('TimeStamp',[],'Electrode',[],'Unit',[],'Waveform',[],'WaveformUnit','raw'); % start with it as a cell, we'll probably change it later
    dataLength = zeros(1,numel(ns6File));

    for jj = 1:numel(ns6File)
        ns6Data = openNSx([ns6Path,filesep,ns6File{jj}]);

        numChannels = ns6Data.MetaTags.ChannelCount; % less typing later
        if jj == 1 % don't want to reset this between files in the same recording session
            rms = zeros(numChannels,1);
        end


        % Cortical Data

        % remove the common mode average if desired
        if settings(kk).commonModeAverage
            avgSig = mean(ns6Data.Data,1);
            ns6Data.Data = double(ns6Data.Data) - ones(numChannels,1) * avgSig;
        end

        % filtering
        % if non-causal filtering
        if settings(kk).noncausalFilter
            [B,A] = butter(2,settings(kk).filterFreqs/15000,'bandpass');
        else
            [B,A] = butter(4,settings(kk).filterFreqs/15000,'bandpass');
        end

        % filter for each channel
        for ii = 1:numChannels
            if settings(kk).noncausalFilter
                ns6Data.Data(ii,:) = filtfilt(B,A,ns6Data.Data(ii,:));
            else
                ns6Data.Data(ii,:) = filter(B,A,ns6Data.Data(ii,:));
            end

            % find the RMS to calculate threshold crossings, but only
            % looking at the first file. We'll compare this with the
            % threshold values used originally later
            if jj == 1
                rms(ii) = -sqrt(mean(ns6Data.Data(ii,:).^ 2));
            end

        end

        spikes_temp = findSpikes(ns6Data,'threshold',(rms'*settings(kk).thresholdMult)*.25); % think the threshold value has to be in uV, whether or not the ns6 is
    %     keyboard
        spikes30k.Electrode = [spikes30k.Electrode,spikes_temp.Electrode(:)']; % with the weird transposed array notation because findspikes seems to send out inconsistently dimensioned matrices
        spikes30k.TimeStamp = [spikes30k.TimeStamp,spikes_temp.TimeStamp(:)' + dataLength(jj)*30000];
        spikes30k.Unit = [spikes30k.Unit,spikes_temp.Unit(:)'];
        spikes30k.Waveform = [spikes30k.Waveform,spikes_temp.Waveform]; % not going to mess with this one, since it would be a mess to reshape properly
        dataLength(jj+1) = ns6Data.MetaTags.DataDurationSec+dataLength(jj);
        clear ns6Data spikes_temp


    end

    % save([ns6Path,filesep,ns6BaseFilename],'spikes30k','-v7.3')
    spikes30kNev = nevData;
    spikes30kNev.Data.Spikes = spikes30k;
    saveNEV(spikes30kNev,[ns6Path,filesep,ns6NevFilename],'report');

    
    
end
%% filter the EMG stuff

% EMG Data filters
[Dhigh,Chigh] = butter(2,30/1000,'high');
[Dnotch,Cnotch] = butter(4,[55 65]/1000,'stop');
[Dlow,Clow] = butter(4,10/1000,'low');


% find which data streams are EMG and which are force
EMGind = find(contains({ns3Data.ElectrodesInfo.Label},'EMG')); % which labels contain the phrase 'EMG'
EMGnames = {ns3Data.ElectrodesInfo(EMGind).Label};
forceInd = find(contains({ns3Data.ElectrodesInfo.Label},'Force'));
forceNames = {ns3Data.ElectrodesInfo(forceInd).Label};

% run through the filters etc for all of the EMGs
EMGfilt = zeros(numel(EMGind),size(ns3Data.Data,2));
for ii = 1:numel(EMGnames)
    EMGfilt(EMGind(ii),:) = filtfilt(Dnotch,Cnotch,double(ns3Data.Data(EMGind(ii),:)));
    EMGfilt(EMGind(ii),:) = filter(Dlow,Clow,abs(filter(Dhigh,Chigh,EMGfilt(EMGind(ii),:))));
end


% pull in the forces
forces = ns3Data.Data(forceInd,:);


clear ns3Data

%% Bin all three data sets

electrodesNev = unique(nevData.Data.Spikes.Electrode);
electrodes30k = unique(spikes30k.Electrode);

% bin them all based on the same times
bTimes = (0:binLength:nevData.MetaTags.DataDurationSec);

% preallocate the arrays
binned30k = zeros(numel(electrodes30k),length(bTimes)-1);
binnedEMG = zeros(numel(EMGnames),length(bTimes));
binnedForces = zeros(size(forces,1),length(bTimes));
binnedNev = zeros(numel(electrodesNev),length(bTimes)-1);

% bin for each unique 30k electrode. I suppose we could do unit...
for ii = 1:numel(electrodes30k)
    electrode = electrodes30k(ii);
%     keyboard;
    binned30k(ii,:) = histcounts(spikes30k.TimeStamp(spikes30k.Electrode == electrode)/30000,bTimes);
end

% bin for each unique .nev electrode
for ii = 1:numel(electrodesNev)
    electrode = electrodesNev(ii);
    binnedNev(ii,:) = histcounts(double(nevData.Data.Spikes.TimeStamp(nevData.Data.Spikes.Electrode == electrode))/30000,bTimes);
end

% bin each unique EMG recording
for ii = 1:numel(EMGind)
%     binnedEMG(ii,:) = EMGfilt(ii,int32(bTimes/mean(diff(bTimes))));
    binnedEMG(ii,:) = downsample(EMGfilt(ii,:),floor(length(EMGfilt)/(length(bTimes)-1)));
end

% bin each unique force recording
for ii = 1:numel(forceInd)
%     binnedForces(ii,:) = forces(ii,int32(bTimes/mean(diff(bTimes))));
    binnedForces(ii,:) = downsample(forces(ii,:),floor(length(EMGfilt)/(length(bTimes)-1)));
end



%% Predictions based on nev and 30k data

% build the filters
[H_emg_Nev,vaf_emg_NEV,~] = filMIMO4(binnedNev',binnedEMG(:,1:end-1)',10,1,1);
[H_emg_30k,vaf_emg_30k,~] = filMIMO4(binned30k',binnedEMG(:,1:end-1)',10,1,1);


% mfxval
numFolds = 10;
vaf_mfxval_emg_NEV = zeros(size(binnedEMG,1),numFolds);
vaf_mfxval_emg_30k = zeros(size(binnedEMG,1),numFolds);

for ii = 1:numFolds
    
    
    
    
end






