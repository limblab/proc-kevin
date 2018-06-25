%% TD_jPCA
%
% Script to perform jPCA on a series of data broken into the trial data
% format. For more information on the jPCA method refer to Churchland et
% al 2012 "Neural Population Dynamics During Reaching", in particular the
% supplementary materials that derive the method.

% I'm wanting to try this out on some isometric wrist flexion data from
% Jango to start. Let's use the data set aside for "Ali's NIPS Paper",
% since Juan claims it's quality stuff.


%% if the TD is already properly loaded
% meaning we have it with kinematics etc.
tdFolder = 'Z:\limblab\lab_folder\Projects\BMI_Dimensionality\Ali_s_NIPS_Stuff';
tdName =  'Jango_20160626_WFiso_R10T4_001_TD.mat';

% 'Jango_20160623_WFiso_R10T4_001_TD.mat';
% 'Jango_20160623_WFiso_R10T4_002_TD.mat';
% 'Jango_20160626_WFiso_R10T4_001_TD.mat';
% 'Jango_20160626_WFiso_R10T4_002_TD.mat';
% 'Jango_20160627_WFiso_R10T4_001_TD.mat';
% 'Jango_20160627_WFiso_R10T4_002_TD.mat';


% load the trial data file
load([tdFolder,filesep,tdName],'TD');

%% if the TD isn't properly loaded
% bad kin
tdFolder = 'Z:\limblab\lab_folder\Projects\BMI_Dimensionality\Ali_s_NIPS_Stuff';
tdName =  'Jango_20160626_WFiso_R10T4_001_TD.mat';
cdsName = 'Jango_20160626_WFiso_R10T4_001_cds.mat';

% 'Jango_20160623_WFiso_R10T4_001_TD.mat';
% 'Jango_20160623_WFiso_R10T4_002_TD.mat';
% 'Jango_20160626_WFiso_R10T4_001_TD.mat';
% 'Jango_20160626_WFiso_R10T4_002_TD.mat';
% 'Jango_20160627_WFiso_R10T4_001_TD.mat';
% 'Jango_20160627_WFiso_R10T4_002_TD.mat';

% load the cds
load([tdFolder,filesep,cdsName],'cds');
params = struct('exclude_units',255,'include_ts',true,'include_start',true,'trial_results',{{'R','A','F','I'}});
params.event_list = {'startTime','startTime';'endTime','endTime';,'goCue','goCueTime';'tgtOn','tgtOnTime'};

TD = parseFileByTrial(cds,params);
save([tdFolder,filesep,tdName],'TD','-v7.3'); % save it so we don't have to do this again later.



%% smooth it using a gaussian kernal
smoothParams.kernel_SD = .05;
smoothParams.signals = 'arrayM1_spikes';
TDsmooth = smoothSignals(TD,smoothParams);

%% Align and trim trials
pkMvParams = struct('which_method','peak','which_field','vel');
TDsmooth = getMoveOnsetAndPeak(TDsmooth,pkMvParams);

% realign to the movement onset, trim so that we have 200 ms before and 400
% ms after. Right now, with a 10 ms bin that's -20 and 40
TDsmooth = trimTD(TDsmooth,{'idx_movement_on',-20},{'idx_movement_on',40});



%% find the trial averaged PCA 

pcaParams = struct('signals','arrayM1_spikes','do_plot',true);
TDsmooth = getPCA(TDsmooth,pcaParams);

