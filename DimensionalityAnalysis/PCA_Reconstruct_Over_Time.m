%% PCA_Reconstruct_Over_Time.m
%
% I'm going to calculate the principal componenents of a file, then see how
% those PCs reconstruct small segments of data over time. The idea is that
% this will show how dimensional the data is in small segments of time,
% though we'll see whether that's accurate or not. 

% Working off the 'standard_Jango_Files': 
% 
% just loading the ex structure, rather than dealing with other shiz
% file = 'D:\Jango\BMI-EMGs\20170207\20170207_Jango_IsoWF_001_ex.mat';
% file = 'D:\Jango\BMI-EMGs\20160517\Jango_20160517_MG_PT_T3_002_ex.mat';
file = 'D:\Jango\InCage\20170524\20170524_Jango_Cage_5_ex.mat';


load(file,'ex'); % make sure we're loading what we want

%% Smoothing and sqrt xform
binWidth = .05;
gaussWidth = [-3*binWidth:binWidth:3*binWidth];
gaussPDF = normpdf(gaussWidth,0,binWidth);

smoothFR = zeros(size(ex.firingRate.data,1),size(ex.firingRate.data,2)-1);
for ii = 1:size(ex.firingRate.data,2)-1 % smooth each channel
    smoothFR(:,ii) = conv(ex.firingRate.data{:,ii+1},gaussPDF,'same');
end
smoothFR = sqrt(smoothFR);


clear ex % empty out some memory

%% calculate the PCs
[coeff,score,latent,~,~,mu] = pca(smoothFR); % find the PCs, projections etc

%% calculate the VAF for D dimensions
dDim = 10; %

reconFR = score(:,1:dDim)*coeff(:,1:dDim)' + repmat(mu,size(smoothFR,1),1);

% and find the VAFs in x second segments
lengthVAF = 5; % length of segment (seconds)
timeGainVal = lengthVAF/binWidth; % have to use this a bunch, might as well just rock it.
timeVAFs = zeros(floor(size(reconFR,1)/timeGainVal),1);

for ii = 1:length(timeVAFs)
    timeVAFs(ii) = 1-sum((reconFR((ii-1)*timeGainVal+1:ii*timeGainVal,:)-...
        smoothFR((ii-1)*timeGainVal+1:ii*timeGainVal,:)).^2)/...
        sum((smoothFR((ii-1)*timeGainVal+1:ii*timeGainVal,:)-repmat(mu,timeGainVal,1)).^2);
end



%% plot it all
figure
ax(1) = subplot(2,1,1);
imagesc(smoothFR')
set(gca,'XTick',[]);
set(gca,'YTick',[]);

ax(2) = subplot(2,1,2);
plot(lengthVAF/60:lengthVAF/60:length(timeVAFs)*lengthVAF/60,timeVAFs);
xlabel('Time (min)')
ylabel('VAF')
set(gca,'YLim',[0 1]);

lh1 = addlistener(ax(2),'XLim','PostSet',...
    @(src,event) set(ax(1),'XLim',ax(2).XLim*1200)); % set the axes to match, I guess

Leefy



