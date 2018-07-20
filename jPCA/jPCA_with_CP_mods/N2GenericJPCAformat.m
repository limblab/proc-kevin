% CP: function received from Mark Churchland, 2016-06-17. I own no rights to this code
%
% For converting an N structure into the generic data format that can be fed to jPCA.
% Here we are calling zero the time that firing rates begin to change rapidly.
%
function [Data, lat] = N2GenericJPCAformat(N, latency)  % added the optional 'lat' output on Jun 11 2013

numConds = numel(N(1).cond);
numNeurons = numel(N);
numTimes = length(N(1).interpTimes.times);

riseThresh = 0.5;
if exist('latency','var')
    lat = latency;
else
    lat = moveActivityLatency(N, riseThresh);
end
%lat = 0;

for c = 1:numConds
    Data(c).A = zeros(numTimes,numNeurons);
    Data(c).times = N(1).interpTimes.times' - N(1).interpTimes.moveStarts - lat;  % zero is now set to be when rates begin to change rapidly
    Data(c).timesWRTmove = N(1).interpTimes.times' - N(1).interpTimes.moveStarts;  % not used by jPCA, but keep for posterity
    Data(c).conditionCode = N(1).cond(c).conditionCode;
    
    for n = 1:numNeurons
        Data(c).A(:,n) = N(n).cond(c).interpPSTH;
    end
    
end
