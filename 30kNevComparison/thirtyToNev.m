function thirtyToNev(filename,varargin)
%% thirtyToNev(filename)
%
% Turn a recorded 30k (ns5 or ns6) file to a nev file. 
% The goal behind this is to test a bunch of different settings to see
% whether we can get better spiking by doing our own offline filtering etc.
% It's just going to save a .nev file so we can take advantage of all of
% the different analysis tools we already have.
% 
%

%% Settings, parse inputs

% get the desired filter settings etc
settings = struct(...
    'commonModeAverage',false,...
    'noncausalFilter', false,...
    'filterFreqs', [250, 5000],...
    'thresholdMult', 4.5,...
    'filtThenCAR',false);

% parse the settings struct. to do: implement with name/value pairs, and
% should probably do some sort of data validation if this is actually going
% to be a script you use.
for ii = 1:length(varargin)
    if isstruct(varargin{ii})
        feelnames = fieldnames(varargin{ii});
        for jj = 1:length(feelnames)
            settings.(feelnames{jj}) = varargin{ii}.(feelnames{jj});
        end
    end
end



% if a filename wasn't given, use a GUI to find one
if ~exist('filename','var')
    [filename,ns6path] = uigetfile('.\*.ns6','Select 30 khz data','MultiSelect','off');
    [~,basename,ext] = fileparts(filename);
    filename = [ns6path,filesep,filename];
else
    [ns6path,basename,ext] = fileparts(filename);
end

% create a subfolder just for the split nsx files
% mkdir(ns6Path,[basename,'_tmpSplit'])


%% split the ns6 file
% they're way too large to open otherwise. 

numSplit = 5;

% check to see if they've already been split
if ~exist([ns6path,filesep,basename,'-s001',ext],'file')
    splitNSx_KB(filename,numSplit);
end


%% The actually interesting shit

% get all of these before we start editing the base filename
ns6List = sprintf([basename,'-s%03d',ext,'\n'],1:numSplit);
ns6List = strsplit(ns6List,'\n');
ns6List = ns6List(1:numSplit);
nevName = [ns6path,filesep,basename,'.nev'];

if settings.commonModeAverage
    basename = [basename,'_subtractCommon'];
end
if settings.noncausalFilter
    basename = [basename,'_noncausal'];
end
if settings.filtThenCAR
    basename = [basename,'_filtThenCAR'];
end


% prep file names for reading and storage
ns6NevFilename = [basename,'_thresh',num2str(settings.thresholdMult),'.nev'];

spikes30k = struct('TimeStamp',[],'Electrode',[],'Unit',[],'Waveform',[],'WaveformUnit','raw'); 
dataLength = zeros(1,numel(ns6List));


fprintf('Processing .ns6')
for jj = 1:numel(ns6List)
    ns6File = openNSx([ns6path,filesep,ns6List{jj}]);
    numChannels = ns6File.MetaTags.ChannelCount; % less typing later 

    % Cortical Data

    % remove the common mode average if desired
    if settings.commonModeAverage && ~settings.filtThenCAR
        % let's try removing the first principal component of all of these
        % suckers
        if jj == 1 % only calculate PCA the first time - keeping things consistent I suppose
            coeff = pca(double(ns6File.Data(:,1:900000)')); % working with 30 seconds of data
            redCoeff = coeff(:,3:end)*coeff(:,3:end)';
        end
%         scores = ns6File.Data'*coeff;
        ns6File.Data = redCoeff*double(ns6File.Data); % removing the first PC        
%         avgSig = mean(ns6File.Data,1);
%         ns6File.Data = double(ns6File.Data) - ones(numChannels,1) * avgSig;
        clear scores
    end

    % filtering
    % if non-causal filtering
    if settings.noncausalFilter
        [B,A] = butter(2,settings.filterFreqs/15000,'bandpass');
        for ii = 1:size(ns6File.Data,1)
            ns6File.Data(ii,:) = filtfilt(B,A,double(ns6File.Data(ii,:))); %gotta typecast back and forth. what a pain
        end
    else
        [B,A] = butter(4,settings.filterFreqs/15000,'bandpass');
        ns6File.Data = filter(B,A,ns6File.Data,[],2);
    end

    
    if settings.commonModeAverage && settings.filtThenCAR
        % let's try removing the first principal component of all of these
        % suckers
        if jj == 1 % only calculate PCA the first time - keeping things consistent I suppose
            coeff = pca(double(ns6File.Data(:,1:900000)')); % working with 30 seconds of data
            redCoeff = coeff(:,3:end)*coeff(:,3:end)';
        end
%         scores = ns6File.Data'*coeff;
        ns6File.Data = redCoeff*double(ns6File.Data); % removing the first PC        
%         avgSig = mean(ns6File.Data,1);
%         ns6File.Data = double(ns6File.Data) - ones(numChannels,1) * avgSig;
        clear scores
    end
    
    
    
    % find the RMS to calculate threshold crossings, but only
    % looking at the first file. We'll compare this with the
    % threshold values used originally later
    if jj == 1
        cThresh = zeros(numChannels,1);
        cThresh = -rms(ns6File.Data,2);
        
%         ns6Meta = ns6File.MetaTags;
%         ns6ElecInfo = ns6File.ElectrodesInfo;
    end
    
    
%     keyboard
    spikes_temp = findSpikes(ns6File,'threshold',(cThresh'*settings.thresholdMult)*.25); % think the threshold value has to be in uV, whether or not the ns6 is
%     keyboard
    spikes30k.Electrode = [spikes30k.Electrode,spikes_temp.Electrode(:)']; % with the weird transposed array notation because findspikes seems to send out inconsistently dimensioned matrices
    spikes30k.TimeStamp = [spikes30k.TimeStamp,spikes_temp.TimeStamp(:)' + dataLength(jj)*30000];
%     keyboard
    if isempty(spikes_temp.Unit)
        spikes30k.Unit = [spikes30k.Unit,zeros(size(spikes_temp.Electrode(:)'))];
    else
        spikes30k.Unit = [spikes30k.Unit,spikes_temp.Unit(:)'];
    end
    spikes30k.Waveform = [spikes30k.Waveform,spikes_temp.Waveform]; % not going to mess with this one, since it would be a mess to reshape properly
    dataLength(jj+1) = ns6File.MetaTags.DataDurationSec+dataLength(jj);
    clear ns6Data spikes_temp


end


%% Save into a .nev structure
% we'll have to fill in the header information too.

% for now we'll just strip the structure from the associated .nev file
nevData = openNEV(nevName,'nomat','nosave');

% parse the 

nevData.Data.Spikes = spikes30k;

for jj = 1:numChannels
    chanInd = [nevData.ElectrodesInfo.ElectrodeID] == ns6File.ElectrodesInfo(jj).ElectrodeID;
    nevData.ElectrodesInfo(chanInd).LowThreshold = int16(cThresh(jj));
end

saveNEV(nevData,[ns6path,filesep,ns6NevFilename],'report');


end