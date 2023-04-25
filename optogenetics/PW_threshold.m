%% PW_threshold.m
%
% Sweeps the pulse width of the optical stimulator.
%
% This is for the optogenetic project in collaboration with the Williams
% lab, attempting peripheral nerve stimulation to result in muscle
% contractions

%% clear everything
clear all;

% directories and filenames for storage -- to save all of the EMG recordings and stim times
save_dir = ['C:\Data\20C1-Sherry\',datestr(today,'yymmdd')];
if ~exist(save_dir,'dir')
    mkdir(save_dir)
end
    
base_FN = [save_dir,filesep,datestr(today,'yyyymmdd'),'Sherry_PWThreshold'];

%% initialize cbmex
cbmex('open')
cbmex('trialconfig',0) % turn off buffering


%% stimulation parameters
amp_o = 5;                  %owave amplitude
dur_o = 1:10;               %ms, owave pulse width
period = 2000;              %ms, owave period
count = 10;                 %owave number of pulses
last_index = length(dur_o); %upper bound for an array
wtime = 1;                  %blanking period in seconds
pre_t = -100;                  %# of samples before the pulse
post_t = 500;             %# of samples after the pulse


%% cerebus parameters
% Analog inputs 1-4 to record EMG, 5 to record the stimulation control
% signal
%

% turn off all the neural channels
for ii = 1:256
    cbmex('config',ii,'smpgroup',0)
end

% Recording at 2k, filter 10-250 hz
for ii = 257:260
    cbmex('config',ii,'smpgroup',3,'smpfilter',9)
end

% recording the pulse control signal
cbmex('config',261,'smpgroup',3,'smpfilter',0)

%% Start the cerebus recording

cbmex('fileconfig'