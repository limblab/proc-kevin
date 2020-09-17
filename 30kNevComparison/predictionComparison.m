%% predictionComparison
% 
% I'm interested in looking at the how different preprocessing of
% continuosly-sampled 30khz neural data affects the threshold crossings
% (and consequently the predictability) of neural and EMG recordings.
%
% This file takes a series of different binned TrialData structures and
% calculates the mfxval VAF across the file using a linear wiener filter
% with static non-linearities. It then plots the average of the
% training-set VAFs and the testing set VAFs (separately). 



tdFiles = {...
    'Pop_20200316_FR_001_TD.mat',...
    'Pop_20200316_FR_001_subtractCommon_thresh4.5_TD.mat',...
    'Pop_20200316_FR_001_thresh4.5_TD.mat',...
};

numFolds = 10;
exponent = 3;

model_params = struct(...
    'in_signals',{'leftM1_2_spikes'},...
    'out_signals',{'emg'},...
    'model_type','linmodel',...
    'polynomial',3);



for ii = 1:numel(tdFiles)
    printDivider
    [fpath,fname,ext] = fileparts(tdFiles{ii});
    fprintf('Analysis for %s',fname)
    
    load(tdFiles{ii},'TD')
    TD.t = (1:size(TD.emg,1))*TD.bin_size; %adding a time vector. Not sure why that doesn't already exist
    
    testIDx = 1:floor(length(TD.t)/numFolds)*numFolds;
    testIDx = reshape(testIDx,numFolds,[]);
    
%     TD = dupeAndShift(TD,'leftM1_2_spikes',-(1:10)); % 500 ms lags. Need to do this after duping everything.
    trainVAF = nan(numFolds,numel(TD.emg_names)); % different arrays for test vs training VAF
    testVAF = nan(numFolds,numel(TD.emg_names));
    
    
    TD.emg(isnan(TD.emg)) = deal(0);
    TD.leftM1_2_spikes(isnan(TD.leftM1_2_spikes)) = deal(0);
    
    for jj = 1:numFolds % mfxval
        trainIDx = setdiff(1:length(TD.t),testIDx(jj,:)); % training indices
        model_name = ['lin_EMG_fold_',num2str(jj)];
        
        H = filMIMO4(TD.leftM1_2_spikes(trainIDx,:),TD.emg(trainIDx,:),10,1,1);
        predTrain = predMIMO4(TD.leftM1_2_spikes(trainIDx,:),H,1,1,TD.emg(trainIDx,:));
        predTest = predMIMO4(TD.leftM1_2_spikes(testIDx(jj,:),:),H,1,1,TD.emg(testIDx(jj,:),:));
        
        trainVAF(jj,:) = 1-(var(predTrain-TD.emg(trainIDx,:))./var(TD.emg(trainIDx,:),1));
        testVAF(jj,:) = 1-(var(predTest-TD.emg(testIDx(jj,:),:))./var(TD.emg(testIDx(jj,:),:),1));
%         TD = getModel(TD,model_params); % calculate the model on the training data set
%         for kk = 1:numel(TD.emg_names) % VAF for each muscle
%             trainVAF(jj,kk) = 
            
    end
    
    
    % plot the VAF values
    ax(1) = subplot(1,2,1);
    bar(mean(trainVAF))
    ylabel('VAF')
    title('mean training set VAF')
    ax(2) = subplot(1,2,2);
    bar(mean(testVAF))
    ylabel('VAF')
    title('mean testing set VAF')
    set(ax,'XTickLabel',TD.emg_names)
    set(ax,'XTickLabelRotation',90)
    set(ax,'YLim',[-.1 1.1])
    set(ax,'TickLabelInterpreter','none')
    axis(ax,'square')
    Leefy
    snapnow()
    for jj = 1:numel(TD.emg_names)
        fprintf('%s mean testing VAF: %02f\n',TD.emg_names{jj},mean(testVAF(:,jj)))
    end
    fprintf('\n\n\n\n\n\n\n\n\n\n\n\n\n')
%     printDivider
    
    
    
end
