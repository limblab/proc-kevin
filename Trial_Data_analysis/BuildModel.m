function [filter, varargout] = BuildModel(trialData, options)
%    [filter, varargout] = BuildModel(trialData, options)
%
%
%       trialData           : data structure to build model
%       options             : structure with fields:
%           filType             : filter type (weiner, etc)
%           filLen              : filter length in seconds (typically 0.5)
%           UseAllInputs        : 1 to use all inputs, 0 to specify a neuronID file, or a NeuronIDs array
%           PolynomialOrder     : order of the Weiner non-linearity (0=no Polynomial)
%           PredEMGs, PredForce, PredCursPos, PredVeloc, numPCs :
%                               flags to include EMG, Force, Cursor Position
%                               and Velocity in the prediction model
%                               (0=no,1=yes), if numPCs is present, will
%                               use numPCs components as inputs instead of
%                               spikeratedata
%           Use_Thresh,Use_EMGs,Use_Ridge:
%                               options to fit only data above a certain
%                               threshold, use EMGs as inputs instead of
%                               spikes, or use a ridge regression to fit model
%           plotflag            : plot predictions after xval
%
%       Note on options: not all the fields have to be present in the
%       'option' structure provided in arguments. Those that are not will
%       be filled with the values from 'ModelBuildingDefault.m'
%
%       filter: structure of filter data (neuronIDs,H,P,emgGuide,filLen,binSize)
%       varargout = {PredData}
%           [PredData]      : structure with EMG prediction data (fit)% 
%

%% Argument handling

