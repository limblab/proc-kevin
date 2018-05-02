function [ReconstructionError,LowerBoundError,UpperBoundError,ErrorBoot] = ...
    bootstrap_PCA_EMGs(ex,confidenceInterval, EMGlist)
% find dimensionality of the EMG task.
% EMG_list should be a cell structure. If empty, I'll use ALL of emg


if ~exist('EMGlist','var')
    EMGlist = ex.emg.data.Properties.VariableNames(2:end);
end

for ii = 1:length(EMGlist)
    if ~any(strfind(EMGlist{ii},'EMG'))
        EMGlist{ii} = ['EMG_',EMGlist{ii}];
    end
    
    % there needs to be some normalization due to the natural differences
    % in the magnitudes of these signals, but I'm not really sure how to do
    % it. We're gonna start with dividing by the mean and working from
    % there.
    EMGs(:,ii) = ex.bin.data.(EMGlist{ii})/quantile(ex.bin.data.(EMGlist{ii}),.95);
end



nBoot = 1000;
VAF_Boot = zeros(size(EMGs,2),nBoot);
nBin = size(EMGs,1);
for jj = 1:nBoot
    EMGdataBoot = EMGs(randsample(nBin,nBin,1),:);
    [~,~,~,~,VAF_Boot(:,jj)] = pca(EMGdataBoot);
    VAF_Boot(:,jj) = cumsum(VAF_Boot(:,jj));
end
[VAF,lowVAF,highVAF] = getCIforPCA(VAF_Boot,confidenceInterval);


ReconstructionError = 100 - VAF;
UpperBoundError = 100 - highVAF;
LowerBoundError = 100 - lowVAF;
ErrorBoot = 100 - VAF_Boot;


end
