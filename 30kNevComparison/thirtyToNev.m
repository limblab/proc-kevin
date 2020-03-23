function thirtyToNev(filename,varargin)
%% thirtyToNev(filename)
%
% Turn a recorded 30k (ns5 or ns6) file to a nev file. 
% The goal behind this is to test a bunch of different settings to see
% whether we can get better spiking by doing our own offline filtering etc.
% It's just going to save a .nev file so we can take advantage of all of
% the different analysis tools we already have.
% 
%

%% Settings, parse inputs
settings = struct(...
    'commonModeAverage',false,...
    'noncausalFilter', false,...
    'filterFreqs', [250, 5000],...
    'thresholdMult', 4.5);

% if a filename wasn't given, use a GUI to find one.0
if ~exist('filename','var')
    [filename,ns6Path] = uigetfile('.\*.ns6','Select 30 khz data','MultiSelect','off');
    [~,basename,ext] = fileparts(filename);
else
    [ns6path,basename,ext] = fileparts(filename);
end

% create a subfolder just for the split nsx files
mkdir(ns6Path,[basename,'_tmpSplit'])


%% split the ns6 file
% they're way too large to open otherwise


end