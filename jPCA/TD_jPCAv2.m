%% TD_jPCA
%
% Script to perform jPCA on a series of data broken into the trial data
% format. For more information on the jPCA method refer to Churchland et
% al 2012 "Neural Population Dynamics During Reaching", in particular the
% supplementary materials that derive the method.

% I'm wanting to try this out on some isometric wrist flexion data from
% Jango to start. Let's use the data set aside for "Ali's NIPS Paper",
% since Juan claims it's quality stuff.


%% Add all relevent directories to the path
% assuming we're in the proc-kevin\jPCA folder
addpath 'jPCA_with_CP_mods' -END
addpath '



%% if the TD is already properly loaded
% meaning we have it with kinematics etc.
tdFolder = 'D:\Jango\Ali_s NIPS stuff';
tdName =  'Jango_20160623_WFiso_R10T4_002_TD.mat'

% 'Jango_20160623_WFiso_R10T4_001_TD.mat';
% 'Jango_20160623_WFiso_R10T4_002_TD.mat';
% 'Jango_20160626_WFiso_R10T4_001_TD.mat';
% 'Jango_20160626_WFiso_R10T4_002_TD.mat';
% 'Jango_20160627_WFiso_R10T4_001_TD.mat';
% 'Jango_20160627_WFiso_R10T4_002_TD.mat';


% load the trial data file
load([tdFolder,filesep,tdName],'TD');
TD = rmfield(TD,'arrayM1_ts');


%% if the TD isn't properly loaded
% bad kin
% tdFolder = 'Z:\limblab\lab_folder\Projects\BMI_Dimensionality\Ali_s_NIPS_Stuff';
% tdName =  'Jango_20160626_WFiso_R10T4_001_TD.mat';
% cdsName = 'Jango_20160626_WFiso_R10T4_001_cds.mat';
% 
% % 'Jango_20160623_WFiso_R10T4_001_TD.mat';
% % 'Jango_20160623_WFiso_R10T4_002_TD.mat';
% % 'Jango_20160626_WFiso_R10T4_001_TD.mat';
% % 'Jango_20160626_WFiso_R10T4_002_TD.mat';
% % 'Jango_20160627_WFiso_R10T4_001_TD.mat';
% % 'Jango_20160627_WFiso_R10T4_002_TD.mat';
% 
% % load the cds
% load([tdFolder,filesep,cdsName],'cds');
% params = struct('exclude_units',255,'include_ts',true,'include_start',true,'trial_results',{{'R','A','F','I'}});
% params.event_list = {'startTime','startTime';'endTime','endTime';,'goCue','goCueTime';'tgtOn','tgtOnTime'};
% 
% TD = parseFileByTrial(cds,params);
% save([tdFolder,filesep,tdName],'TD','-v7.3'); % save it so we don't have to do this again later.



%% normalize and smooth it using a gaussian kernal
% TDsmooth = softNormalize(TD); % just run the default params over it
smoothParams.kernel_SD = .05; % like in da paypa
smoothParams.signals = 'arrayM1_spikes'; 
TDsmooth = smoothSignals(TD,smoothParams);

TDsmooth = TDsmooth([TDsmooth.result] == 'R'); % get rid of the
% non-successes

%% Align and trim trials
pkMvParams = struct('which_method','peak','which_field','vel');
TDsmooth = getMoveOnsetAndPeak(TDsmooth,pkMvParams);



% realign to the movement onset, trim so that we have 200 ms before and 400
% ms after. Right now, with a 10 ms bin that's -20 and 40
TDsmooth = trimTD(TDsmooth,{'idx_movement_on',-(.5/TDsmooth(1).bin_size)},...
    {'idx_movement_on',.5/TDsmooth(1).bin_size});



%% Find the condition mean signals and the condition independent signals

[TDavg,idx_conditions] = trialAverage(TDsmooth,'target_direction'); % find the condition means
TDavg = subtractConditionMean(TDavg);


%% find the trial averaged PCA 

numCons = 8; % number of distinct conditions. This is for reshaping the matrix.
segLength = size(TDavg(1).arrayM1_spikes,1);
numChans = size(TDavg(1).arrayM1_spikes,2);

%caParams = struct('signals','arrayM1_spikes','do_plot',true);
%TDavg = getPCA(TDavg,pcaParams);

% copy and reshape the average 

spikes = [TDavg.arrayM1_spikes];
spikes = reshape(spikes, segLength*numCons, numChans);
[avgCoeff,avgScore] = pca(spikes);




%% plot the PCA projections
% Plot some projections 
% initialize axes
figure
ax(1) = subplot(1,3,1);
axis square
hold on
xlabel('Time')
ylabel('PC1')
ax(2) = subplot(1,3,2);
axis square
hold on
xlabel('Time')
ylabel('PC2')
ax(3) = subplot(1,3,3);
axis square
hold on
xlabel('Time')
ylabel('PC3')
cMap = hsv;


for ii = 1:numCons
    traceColor = cMap(ii*8,:);
    axes(ax(1))
    plot(avgScore(((ii-1)*segLength+1):(ii*segLength),1),...
        'Color',traceColor,'LineWidth',1.5);
    axes(ax(2))
    plot(avgScore(((ii-1)*segLength+1):(ii*segLength),2),...
        'Color',traceColor,'LineWidth',1.5);
    axes(ax(3))
    plot(avgScore(((ii-1)*segLength+1):(ii*segLength),3),...
        'Color',traceColor,'LineWidth',1.5);
end



% 
% for ii = randperm(length(TDsmooth),40)
%     tarDir = find([TDavg.target_direction]==TDsmooth(ii).target_direction);
%     traceColor = cMap(tarDir*8,:);
%     axes(ax(1))
%     plot(TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1),'Color',traceColor,'LineWidth',0.25);
%     axes(ax(2))
%     plot(TDsmooth(ii).arrayM1_spikes*avgCoeff(:,2),'Color',traceColor,'LineWidth',0.25);
%     axes(ax(3))
%     plot(TDsmooth(ii).arrayM1_spikes*avgCoeff(:,3),'Color',traceColor,'LineWidth',0.25);
% end

Leefy


%% jPCA
dims = 10; % number of PCA dimensions we want to use. Should be EVEN


% first 10 dimensions
avgScoreDot = avgScore(1:end-1,1:dims)-avgScore(2:end,1:dims)./TDsmooth(1).bin_size; % finite different estimation of derivative

avgScoreDot = avgScoreDot(:); % xdot vector
avgScoreTemp = avgScore(1:end-1,1:dims); % shoring up the size of the matrices
avgScoreBlk = blkdiag(avgScoreTemp,avgScoreTemp,...
    avgScoreTemp,avgScoreTemp,avgScoreTemp,avgScoreTemp,...
    avgScoreTemp,avgScoreTemp,avgScoreTemp,avgScoreTemp); % Xtilde

% define the H vector that will get us from the k to Mskew
maxJ = dims*(dims-1)/2; % maximum number of independent dimensions
jVectPos = 1; % skew matrix j
jVectNeg = 1; % skew matrix -j 
H = zeros(dims^2,maxJ); % initialize H

% H for the bottom triangle of M
for ii = 1:dims^2
    if (mod(ii-1,dims)+1) > ceil(ii/dims);
        H(ii,jVectNeg) = -1;
        jVectNeg = jVectNeg + 1;
    end
end

kTemp = 1:maxJ; % temporary k vector
mTemp = H*kTemp'; % temporary Mskew
mTemp = reshape(mTemp,[dims,dims]);
mTemp = mTemp - mTemp'; % skew symmetry, yo
mTemp = mTemp(:); % unroll it

for ii = 1:dims^2
    if mTemp(ii) ~= 0
        H(ii,abs(mTemp(ii))) = sign(mTemp(ii)); % create both sides of the H vector, hopefully...
    end
end


% Now for the big show - we'll just do it with the normal eqn I think...
k = avgScoreBlk*H\avgScoreDot;
mSkew = H*k;
mSkew = reshape(mSkew,[dims,dims]);

% Eigen decomposition of mSkew (because they said so)
[vSkew,~] = eig(mSkew);

clear maxJ jVectPos jVectNeg kTemp mTemp

%% Projections for the first few planes

% first plane
uOne = vSkew(:,1)+vSkew(:,2);
uTwo = j*(vSkew(:,1)-vSkew(:,2));

% second plane
uThree = vSkew(:,3)+vSkew(:,4);
uFour = j*(vSkew(:,3)-vSkew(:,4));

% third plane
uFive = vSkew(:,5)+vSkew(:,6);
uSix = j*(vSkew(:,5)-vSkew(:,6));



% Plot some projections 
% initialize axes
figure
ax(1) = subplot(1,3,1);
axis square
hold on
xlabel('Projection 1')
ylabel('Projection 2')
ax(2) = subplot(1,3,2);
axis square
hold on
xlabel('Projection 3')
ylabel('Projection 4')
ax(3) = subplot(1,3,3);
axis square
hold on
xlabel('Projection 5')
ylabel('Projection 6')
cMap = hsv;



% average traces, using the PCA coefficient matrix
for ii = 1:numCons
    traceColor = cMap(ii*8,:);
    axes(ax(1))
    projOne = TDavg(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uOne;
    projTwo = TDavg(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uTwo;
    plot(projOne,projTwo,'Color',traceColor,'LineWidth',0.25);
    plot(projOne(1),projTwo(1),'ko')
    axes(ax(2))
    projThree = TDavg(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uThree;
    projFour = TDavg(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uFour;
    plot(projThree,projFour,'Color',traceColor,'LineWidth',0.25);
    plot(projThree(1),projFour(1),'ko')
    axes(ax(3))
    projFive = TDavg(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uFive;
    projSix = TDavg(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uSix;
    plot(projFive,projSix,'Color',traceColor,'LineWidth',0.25);
    plot(projFive(1),projSix(1),'ko')
end

% % average traces, using the previously calculated PCA scores
% for ii = 1:numCons
%     traceColor = cMap(ii*8,:);
%     axes(ax(1))
%         projOne = avgScore(((ii-1)*segLength+1):(ii*segLength),1),...
%         'Color',traceColor,'LineWidth',1.5);
%         plot(avgScore(((ii-1)*segLength+1):(ii*segLength),1),...
%         'Color',traceColor,'LineWidth',1.5);
%     plot(avgScore(((ii-1)*segLength+1):(ii*segLength),1),...
%         'Color',traceColor,'LineWidth',1.5);
%     axes(ax(2))
%     plot(avgScore(((ii-1)*segLength+1):(ii*segLength),2),...
%         'Color',traceColor,'LineWidth',1.5);
%     axes(ax(3))
%     plot(avgScore(((ii-1)*segLength+1):(ii*segLength),3),...
%         'Color',traceColor,'LineWidth',1.5);
% end
    
% 
% for ii = randperm(length(TDsmooth),40)    
%     tarDir = find([TDavg.target_direction]==TDsmooth(ii).target_direction);
%     traceColor = cMap(tarDir*8,:);
%     axes(ax(1))
%     projOne = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uOne;
%     projTwo = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uTwo;
%     plot(projOne,projTwo,'Color',traceColor,'LineWidth',0.25);
%     plot(projOne(1),projTwo(1),'ko')
%     axes(ax(2))
%     projThree = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uThree;
%     projFour = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uFour;
%     plot(projThree,projFour,'Color',traceColor,'LineWidth',0.25);
%     plot(projThree(1),projFour(1),'ko')
%     axes(ax(3))
%     projFive = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uFive;
%     projSix = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uSix;
%     plot(projFive,projSix,'Color',traceColor,'LineWidth',0.25);
%     plot(projFive(1),projSix(1),'ko')
% end

Leefy    


%% plot the jPCA projections in time
% % initialize axes
% figure
% ax(1) = subplot(2,3,1);
% axis square
% hold on
% xlabel('Time')
% ylabel('jPC1')
% ax(2) = subplot(2,3,4);
% axis square
% hold on
% xlabel('Time')
% ylabel('jPC2')
% ax(3) = subplot(2,3,2);
% axis square
% hold on
% xlabel('Time')
% ylabel('jPC3')
% ax(4) = subplot(2,3,5);
% axis square
% hold on
% xlabel('Time')
% ylabel('jPC4')
% ax(5) = subplot(2,3,3);
% axis square
% hold on
% xlabel('Time')
% ylabel('jPC5')
% ax(6) = subplot(2,3,6);
% axis square
% hold on
% xlabel('Time')
% ylabel('jPC6')
% cMap = hsv;
% 
% 
% ts = [-.2:.01:1];
% 
% for ii = randperm(length(TDsmooth),40)
%     tarDir = find([TDavg.target_direction]==TDsmooth(ii).target_direction);
%     traceColor = cMap(tarDir*8,:);
%     
%     projOne = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uOne;
%     projTwo = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uTwo;
%     axes(ax(1))
%     plot(ts,projOne,'Color',traceColor,'LineWidth',0.25);
%     axes(ax(2))
%     plot(ts,projTwo,'Color',traceColor,'LineWidth',0.25);
%   
%     projThree = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uThree;
%     projFour = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uFour;
%     axes(ax(3))
%     plot(ts,projThree,'Color',traceColor,'LineWidth',0.25);
%     axes(ax(4))
%     plot(ts,projFour,'Color',traceColor,'LineWidth',0.25);
%     
%     projFive = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uFive;
%     projSix = TDsmooth(ii).arrayM1_spikes*avgCoeff(:,1:dims)*uSix;
%     axes(ax(5))
%     plot(ts,projFive,'Color',traceColor,'LineWidth',0.25);
%     axes(ax(6))
%     plot(ts,projSix,'Color',traceColor,'LineWidth',0.25);
% end
% 
% 
% 
% 
% 
% 
% 
