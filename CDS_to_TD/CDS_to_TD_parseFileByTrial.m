function CDS_to_TD_parseFileByTrial
% an alternative script to my current one that will convert a batch of cds
% files to TD using parseFileByTrial (hooray for not having to do much of
% my own programming). All of the baseline settings will be for binning at
% 1 ms and including all data points - ie what I need to send to Lahiru

filenames = uigetfile({'*_cds.mat','CDS files (_cds.mat)'},...
    'Pick the CDS files to convert','Multiselect','on'); % allows us to select multiple files

params.exclude_units = 255;
params.trial_results = {'R','A','F','I'};
params.all_points = true;
params.include_ts = true;
params.include_start = true;



for ii = 1:length(filenames)
    params.event_list = cds.trials.Properties.VariableNames;
    