%% function plot_FR_EMG(binnedFR,binnedEMG,timeStamps,optional inputs)
% a helpful_function to set up a heatmap raster for firing rates and plot
% the binnedEMGs in a consistent way that will hook the x axes together so
% that zooming on specific sections works well
%
% for the moment we're just gonna put all the EMGs given into one single
% plot. We can change that later if we want, or something. Dunno
%
% KevinHP 2018
function plot_FR_EMG(binnedFR,binnedEMG,timeStamps,varargin)

% quick input checks
binFRSize = size(binnedFR); 
binEMGSize = size(binnedEMG);
binTSize = size(timeStamps);

% this assumes there are a lot more timepoints than dimensions 
if (max(binFRSize)~=max(binEMGSize))|(max(binFRSize)~=max(binTSize))
    error('Dimensions of inputs unacceptable. Get it together!');
end

if numel(varargin) ~= 0
    emgNames = varargin{1}; % all we're gonna handle right now. We can change this later.
end


%% making the firing rate raster
figure
ax(1) = subplot(2,1,1);


% super straight forward for the moment
if binFRSize(1)>binFRSize(2)
    imagesc(binnedFR')
else
    imagesc(binnedFR)
end

ax(1).XTick = [];
zz = zoom;
setAllowAxesZoom(zz,ax(1),false); % make it so we can only zoom in the EMG plot. May change that later
ylabel('Channel')
title('Firing Rates')

%% EMGs
ax(2) = subplot(2,1,2);
plot(timeStamps,binnedEMG);
set(ax(2),'XLim',timeStamps([1 end]))
% keyboard
lh1 = addlistener(ax(2),'XLim','PostSet',...
    @(src,event) ax2Callback(src,event,ax)); % set the axes to match, I guess
% setappdata(ax(2),'XLim_listener',@(src,event) ax2Callback(src,event,ax));
xlabel('Time (s)')
ylabel('EMG Amplitude')
title('EMGs')

if exist('emgNames','var')
    legend(emgNames);
end

Leefy


end


%% axis callback function to make zooming easier
function ax2Callback(src,event,ax)
% keyboard
    set(ax(1),'XLim',ax(2).XLim * 20);
end