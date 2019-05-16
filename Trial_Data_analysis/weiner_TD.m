function [filter, varargout] = weiner_TD(trialData, inputType, options)
% calculates 

fs = 1; numsides = 1;

if strcmp(inputType,'EMG')
    H = filMIMO3(inputs,outputs,numLags,numSides,1);
    [predData, spikeDataNew, actualDataNew] = predMIMO3(inputs,H,numSides,fs,outputs);
    
else
    H = filMIMO4(inputs,outputs,numLags,numSides,1);
    [predData, spikeDataNew, actualDataNew] = predMIMO4(inputs,H,numSides,fs,outputs);
end
