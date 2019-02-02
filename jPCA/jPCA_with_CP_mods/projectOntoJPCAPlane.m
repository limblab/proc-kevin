function Projections = projectOntoJPCAPlane(originalData,analyzeTimes,params,Summary,newData)
% function Projections = projectOntoJPCAPlane(originalData,analyzeTimes,params,Summary,newData)
Data = originalData;

% value to use for soft normalization
softenNorm = 10;
if exist('params', 'var') && isfield(params,'softenNorm')
    softenNorm = params.softenNorm;
end
% do we normalize
normalize = true;
if exist('params', 'var') && isfield(params,'normalize')
    normalize = params.normalize;
end
% do we mean subtract
meanSubtract = true;
if exist('params', 'var') && isfield(params,'meanSubtract')
    meanSubtract = params.meanSubtract;
end

numConds = length(Data);
% take original data and calculate CCM
bigA = vertcat(Data.A);  % append conditions vertically
%% figure out which times to analyze and make masks
analyzeIndices = ismember(round(Data(1).times), analyzeTimes);
if size(analyzeIndices,1) == 1
    analyzeIndices = analyzeIndices';  % orientation matters for the repmat below
end
analyzeMask = repmat(analyzeIndices,numConds,1);  % used to mask bigA

if normalize  % normalize (incompletely unless asked otherwise)
    ranges = range(bigA);  % For each neuron, the firing rate range across all conditions and times.
    normFactors = (ranges+softenNorm);
    bigA = bsxfun(@times, bigA, 1./normFactors);  % normalize
else
    normFactors = ones(1,size(bigA,2));
end

sumA = 0;
for c = 1:numConds
    sumA = sumA + bsxfun(@times, Data(c).A, 1./normFactors);  % using the same normalization as above
end
meanA = sumA/numConds;
if meanSubtract  % subtract off the across-condition mean from each neurons response
    bigA = bigA-repmat(meanA,numConds,1);
end

% get mean FRs
smallA = bigA(analyzeMask,:);
meanFReachNeuron = mean(smallA);  % this will be kept for use by future attempts to project onto the PCs



%% now we should have everything we need to project the new data. order of operations:
% for each condition:
%   normalize all channels using normFactors
%   subtract out ccm
%   subtract out channel FRs
%   project using Sumary.jPCs_highD

Data = newData;
for c = 1:numel(Data)
    Data(c).A = bsxfun(@times, Data(c).A, 1./normFactors);
    Data(c).A = Data(c).A - meanA;
    Data(c).A = bsxfun(@minus,Data(c).A,meanFReachNeuron);
end
keyboard
for c = 1:numel(Data)
    Projections(c).projAllTimes = Data(c).A*Summary.jPCs_highD;
    Projections(c).allTimes = Data(c).times;
    Projections(c).proj = Data(c).A(analyzeIndices,:)*Summary.jPCs_highD;
    Projections(c).times = Data(c).times(analyzeIndices);
end

%% Project the old Data ??
% Data = originalData;
% for c = 1:numel(Data)
%     Data(c).A = bsxfun(@times, Data(c).A, 1./normFactors);
%     Data(c).A = Data(c).A - meanA;
%     Data(c).A = bsxfun(@minus,Data(c).A,meanFReachNeuron);
% end

% for c = 1:numel(Data)
%     Projections(end+1).projAllTimes = Data(c).A*Summary.jPCs_highD;
%     Projections(end).allTimes = Data(c).times;
%     Projections(end).proj = Data(c).A(analyzeIndices,:)*Summary.jPCs_highD;
%     Projections(end).times = Data(c).times(analyzeIndices);
% end
