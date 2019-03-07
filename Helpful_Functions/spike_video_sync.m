%% spike_video_sync

% video and file select
[filename,pathname] = uigetfile({'*.avi;*.mp4;*.vid;*.mod;*.h264'},...
    'Pick a video file','MultiSelect','on'); % if we want to show several angles at once
if iscell(filename)
    multivideo = true;
    videoFullPath = cell(numel(filename),1);
    for ii = 1:numel(filename)
        videoFullPath{ii} = [pathname,filename{ii}];
    end
else
    multivideo = false;
    videoFullPath = {[pathname,filename]};
end

[filename,pathname] = uigetfile({'*.nev'},'Select a .nev file');
nevFullPath = [pathname,filename];

outVidFullPath = strsplit(nevFullPath,'.nev');
outVidFullPath = [outVidFullPath{1},'.avi'];

hasEMG = false;
[filename,pathname] = uigetfile({'*.ns2;*.ns3','Blackrock Files';...
    '*.rhd','Intan Files'});
if ~(filename == 0)
    emgFullPath = [pathname,filename];
    hasEMG = true;
end

%% open the .nev and video
nevStruct = openNEV(nevFullPath,'nomat','nosave','read'); % open the nev

% any and all videos to read from
vidObj = cell(size(videoFullPath));
for ii = 1:numel(vidObj)
    vidObj{ii} = VideoReader(videoFullPath{ii}); % open the video to read
end

% video to store
outVid = VideoWriter(outVidFullPath); % open the video to write
outVid.FrameRate = 30;
open(outVid);

if hasEMG
    emgStruct = openNSx(emgFullPath,'read');
end

%% binning the spikes into 1 ms bins

ts = nevStruct.Data.Spikes.TimeStamp;
elec = nevStruct.Data.Spikes.Electrode;

numElecs = unique(elec);
binnedSpikes = zeros(length(numElecs),int32(nevStruct.MetaTags.DataDurationSec*1000));
timeEdges = 0:.001:round(nevStruct.MetaTags.DataDurationSec,3);
spikes = cell(length(numElecs),1);
spikeDuration = nevStruct.MetaTags.DataDurationSec;

clear nevStruct

for ii = 1:length(numElecs)
    spikes{ii} = double(ts(elec == numElecs(ii)))/30000;
    [binnedSpikes(ii,:),~] = histcounts(spikes{ii},timeEdges);
end

clear ts elec spikes timeEdges
%% clean up EMGs as needed
if hasEMG
    [highB,highA] = butter(2,100/emgStruct.MetaTags.SamplingFreq,'high');
    [lowB,lowA] = butter(2,20/emgStruct.metaTags.SamplingFreq,'low');
    corrEMGs = zeros(size(emgStruct.Data));
    for ii = 1:size(tempEMGs,1)
        corrEMGs(ii,:) = filtfilt(lowB,lowA,abs(filtfilt(highB,highA,...
            emgStruct.Data(ii,:))));
    end
end
    


%% get the timestamps of the video frames
tsFiles = cell(size(videoFullPath));
for ii = 1:numel(tsFiles)
    tsFileName = strsplit(videoFullPath{ii},'.');
    tsFileName = [strjoin(tsFileName(1:end-1),'.'),'.txt'];
    if ~exist(tsFileName)
        warning([videoFullPath{ii},' doesn''t seem to have a corresponding frame rate text file. We will have to do this without any synchronization'])
    else
        try
            fileID = fopen(tsFileName,'rt');
            tsFiles(ii) = textscan(fileID,'%.6f');
            fclose(fileID);
        catch ME
        end
    end
end


%% start spitting out frames for the output video

f = figure;
set(f,'Position',get(0,'Screensize'));


% timestamps for the output video
outTs = 0:1/30:spikeDuration;

% cortical and possibly EMG on the left, any videos on the right
% the organization is a little kludgy, but it's the best I have come up
% with.
if ~hasEMG
    switch length(vidObj)
        case 1
            cortSP = subplot(1,2,1);
            vidSP{1} = subplot(1,2,2);
        case 2
            cortSP = subplot(2,2,[1,3]);
            vidSP{1} = subplot(2,2,2);
            vidSP{2} = subplot(2,2,4);
        case 3
            cortSP = subplot(1,4,1);
            vidSP{1} = subplot(1,4,2);
            vidSP{2} = subplot(1,4,3);
            vidSP{3} = subplot(1,4,4);
        case 4
            cortSP = subplot(2,3,[1,4]);
            vidSP{1} = subplot(2,3,2);
            vidSP{2} = subplot(2,3,3);
            vidSP{3} = subplot(2,3,5);
            vidSP{4} = subplot(2,3,6);
    end
    
    
else
    switch length(vidObj)
        case 1
            cortSP = subplot(2,2,1);
            emgSP = subplot(2,2,3);
            vidSP{1} = subplot(2,2,[2,4]);
        case 2
            cortSP = subplot(2,2,1);
            emgSP = subplot(2,2,3);
            vidSP{1} = subplot(2,2,2);
            vidSP{2} = subplot(2,2,4);
        case 3
            cortSP = subplot(2,3,1);
            emgSP = subplot(2,3,4);
            vidSP{1} = subplot(2,3,2);
            vidSP{2} = subplot(2,3,3);
            vidSP{3} = subplot(2,3,5);
        case 4
            cortSP = subplot(2,3,1);
            emgSP = subplot(2,3,4);
            vidSP{1} = subplot(2,3,2);
            vidSP{2} = subplot(2,3,3);
            vidSP{3} = subplot(2,3,5);
            vidSP{4} = subplot(2,3,6);
    end
    

end

colormap(cortSP,1-gray)
cortSP.TickDir = 'out';
set(f,'Visible','off');
% clip off the first and last 2 seconds
disp('starting to convert video')
for ii = 60:180 % just two minutes for the moment
    
%     keyboard
    cortFrame = binnedSpikes(:,(int32(outTs(ii)*1000-100):int32(outTs(ii)*1000+400)));
    imagesc(cortFrame,'Parent',cortSP)
    cortSP.XTick = [100];
    cortSP.XTickLabel = {num2str(outTs(ii))};
    hold on
    plot(cortSP,[100,100],[1,length(numElecs)],'r:');
    
    % find the current time in the associated video, correcting for skips
    for jj = 1:length(vidSP)
        [~,currFrame] = min(abs(tsFiles{jj}-outTs(ii)));
        vidObj{jj}.CurrentTime = currFrame/30;
        currFrame = readFrame(vidObj{jj});
        imshow(currFrame(1:2:end,1:2:end,:),'Parent',vidSP{jj}); %halving the resolution so the file doesn't balloon
    end
    
    frame = getframe(f);
    writeVideo(outVid,frame);
    
    if mod(outTs(ii),1) == 0
        disp(['Converting t = ',num2str(outTs(ii))]);
    end

end


close(outVid);
disp('Finished converting')




%% A kludgy copy of the one above for a messy import of intan files.
% we'll change this in the future to just import cds and TD rather than
% fucking with direct imports of nev and other files. 

f = figure;
set(f,'Position',get(0,'Screensize'));


% timestamps for the output video
outTs = 0:1/30:spikeDuration;

% cortical and possibly EMG on the left, any videos on the right
% the organization is a little kludgy, but it's the best I have come up
% with.
cortSP = subplot(2,2,1);
emgSP = subplot(2,2,3);
vidSP{1} = subplot(2,2,2);
vidSP{2} = subplot(2,2,4);

colormap(cortSP,1-gray)
cortSP.TickDir = 'out';
emgSP.TickDir = 'out';
set(f,'Visible','off');
% clip off the first and last 2 seconds
disp('starting to convert video')
for ii = 60:4000 % just two minutes for the moment
    
%     keyboard
    cortFrame = binnedSpikes(:,(int32(outTs(ii)*1000-100):int32(outTs(ii)*1000+400)));
    imagesc(cortFrame,'Parent',cortSP)
    cortSP.XTick = [100];
    cortSP.XTickLabel = {num2str(outTs(ii))};
    cortSP.YTick = [];
    cortSP.Box = 'off';
    xlabel(cortSP,'Time (s)');
    cortSP.NextPlot = 'add';
    plot(cortSP,[100,100],[1,length(numElecs)],'r:','LineWidth',2);
    cortSP.NextPlot = 'replace';
    
    plot(emgSP,[outTs(ii),outTs(ii)],[-.2 1.2],'r:','LineWidth',2);
    emgSP.NextPlot = 'add';
    for jj = 1:numel(EMGs)
        [~,winBegin] = min(abs(EMGs(jj).bin_times-(outTs(ii)-.1)));
        [~,winEnd] = min(abs(EMGs(jj).bin_times-(outTs(ii)+.4)));
        plot(emgSP,EMGs(jj).bin_times(winBegin:winEnd),EMGs(jj).bin_data(winBegin:winEnd))
    end
    legend(emgSP,{EMGs.label})
    emgSP.XTick = outTs(ii);
    emgSP.XTickLabel = {num2str(outTs(ii))};
    emgSP.Box = 'off';
    emgSP.YLim = [-0.2 1.2];
    emgSP.XLim = [outTs(ii)-.1,outTs(ii)+.4];
    emgSP.TickDir = 'out';
    emgSP.YTick = [];
    xlabel(emgSP,'Time (s)');
    emgSP.NextPlot = 'replace';
    
    
    
    % find the current time in the associated video, correcting for skips
    for jj = 1:length(vidSP)
        [~,currFrame] = min(abs(tsFiles{jj}-outTs(ii)));
        vidObj{jj}.CurrentTime = currFrame/30;
        currFrame = readFrame(vidObj{jj});
        imshow(currFrame(1:2:end,1:2:end,:),'Parent',vidSP{jj}); %halving the resolution so the file doesn't balloon
    end
    
    frame = getframe(f);
    writeVideo(outVid,frame);
    
    if mod(outTs(ii),1) == 0
        disp(['Converting t = ',num2str(outTs(ii))]);
    end

end


close(outVid);
disp('Finished converting')