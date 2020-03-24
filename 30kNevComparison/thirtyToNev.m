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
settings = struct(...
    'commonModeAverage',false,...
    'noncausalFilter', false,...
    'filterFreqs', [250, 5000],...
    'thresholdMult', 4.5);

% if a filename wasn't given, use a GUI to find one
if ~exist('filename','var')
    [filename,ns6Path] = uigetfile('.\*.ns6','Select 30 khz data','MultiSelect','off');
    [~,basename,ext] = fileparts(filename);
    filename = [ns6Path,filesep,filename];
else
    [ns6path,basename,ext] = fileparts(filename);
end

% create a subfolder just for the split nsx files
% mkdir(ns6Path,[basename,'_tmpSplit'])


%% split the ns6 file
% they're way too large to open otherwise. 

% check to see if they've already been split
if ~exist([ns6Path,filesep,basename,'-s001',filesep,ext],'file')
    splitNSx_KB(filename,5);
end


%% The actually interesting shit

if settings.commonModeAverage
    basename = [basename,'_subtractCommon'];
end
if settings.noncausalFilter
    basename = [basename,'_noncausal'];
end

% prep file names for reading and storage
ns6NevFilename = [basename,'_thresh',num2str(settings(kk).thresholdMult),'.nev'];
ns6List = sprintf([basename,'-s%03d.',ext,'\n'],[1:5]);
ns6List = strsplit(ns6List,'\n');

spikes30k = struct('TimeStamp',[],'Electrode',[],'Unit',[],'Waveform',[],'WaveformUnit','raw'); 
dataLength = zeros(1,numel(ns6List));

for jj = 1:numel(ns6List)
    ns6File = openNSx([ns6Path,filesep,ns6List{jj}]);
    numChannels = ns6File.MetaTags.ChannelCount; % less typing later

    % Cortical Data

    % remove the common mode average if desired
    if setting.commonModeAverage
        avgSig = mean(ns6File.Data,1);
        ns6File.Data = double(ns6File.Data) - ones(numChannels,1) * avgSig;
    end

    % filtering
    % if non-causal filtering
    if settings.noncausalFilter
        [B,A] = butter(2,settings.filterFreqs/15000,'bandpass');
    else
        [B,A] = butter(4,settings.filterFreqs/15000,'bandpass');
    end

    if settings.noncausalFilter
        ns6File.Data(ii,:) = filtfilt(B,A,ns6File.Data,[],2);
    else
        ns6File.Data(ii,:) = filter(B,A,ns6File.Data,[],2);
    end

    % find the RMS to calculate threshold crossings, but only
    % looking at the first file. We'll compare this with the
    % threshold values used originally later
    if jj == 1
        cThresh = zeros(numChannels,1);
        cThresh = -rms(ns6File.Data.^ 2,2);
        
        ns6Meta = ns6File.MetaTags;
        ns6ElecInfo = ns6File.ElectrodeInfo;
    end
    
    

    spikes_temp = findSpikes(ns6File,'threshold',(cThresh'*settings.thresholdMult)*.25); % think the threshold value has to be in uV, whether or not the ns6 is
%     keyboard
    spikes30k.Electrode = [spikes30k.Electrode,spikes_temp.Electrode(:)']; % with the weird transposed array notation because findspikes seems to send out inconsistently dimensioned matrices
    spikes30k.TimeStamp = [spikes30k.TimeStamp,spikes_temp.TimeStamp(:)' + dataLength(jj)*30000];
    spikes30k.Unit = [spikes30k.Unit,spikes_temp.Unit(:)'];
    spikes30k.Waveform = [spikes30k.Waveform,spikes_temp.Waveform]; % not going to mess with this one, since it would be a mess to reshape properly
    dataLength(jj+1) = ns6File.MetaTags.DataDurationSec+dataLength(jj);
    clear ns6Data spikes_temp


end



%% Save into a .nev structure
% we'll have to fill in the header information too.

spikes30kNev = nevData;
spikes30kNev.Data.Spikes = spikes30k;
saveNEV(spikes30kNev,[ns6Path,filesep,ns6NevFilename],'report');


end