% CP: function received from Mark Churchland, 2016-10-17. I own no rights to this code
%
% latency = moveActivityLatency(N)
% where N is an N-structure of neural data.
%
% or:
% latency = moveActivityLatency(N, thresh)
% where thresh is a number between 0 and 1 (0.25 to 0.5 is a reasonable range)
% thresh is how close to the normalized peak of the derivative we have to get before we call that
% the latency.
%
% 'latency' is in ms, relative to the go cue.  If the times in the N structure are in increments of
% 10 (which at the moment they always are) then the latency will always be a multiple of 10.


function latency = moveActivityLatency(N, varargin)

if ~isempty(varargin)
    FRthresh = varargin{1};
else
    FRthresh = 0.25;
end

preTime = -370;  % look 370 ms before move onset
goodTimes = N(1).interpTimes.times > (preTime + N(1).interpTimes.moveStarts);  % logical indexing
moveTimes = N(1).interpTimes.times(goodTimes) - N(1).interpTimes.moveStarts;

softenNorm = 5;
numNeurons = length(N);
numTimes = sum(goodTimes);  % sum because of logical indexing

allDs = zeros(numNeurons, numTimes-1);  % minus one because we lose one when differentiating

for n = 1:numNeurons
    normFact = 1/( range(N(n).ranges.whole) + softenNorm);
    
    allRates = normFact * [N(n).cond.interpPSTH];
    
    dRates = abs(diff(allRates(goodTimes,:)));
    
    allDs(n,:) = mean(dRates'); %#ok<UDIM>
    
end

meanDerivative = mean(allDs);

meanDerivative = meanDerivative - mean(meanDerivative(1:10));  % make early part of curve (first 100 ms) centered on zero
meanDerivative = meanDerivative / max(meanDerivative);

[~, peakT] = max(meanDerivative);
latencyIndex = find(meanDerivative(1:peakT) < FRthresh, 1, 'last');
latencyIndex = latencyIndex+1; % +1 because that was the last one below

latency = moveTimes(latencyIndex);  

if 0  % just for sanity-checking
    figure; plot(moveTimes(1:end-1), meanDerivative, 'k');  hold on;  
    plot(moveTimes(1:end-1), meanDerivative, 'k.');
    plot(moveTimes(1:end-1), FRthresh + 0*meanDerivative, 'b');  % threshold line
    plot(latency, meanDerivative(latencyIndex), 'ro');
end
    
    
    
    
    
        
    

