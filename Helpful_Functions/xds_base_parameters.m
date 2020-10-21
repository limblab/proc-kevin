%% xds_base_parameters
%
% Similar to the cds_Base_parameters file, it's just an easy place to keep
% all of the different mapfiles etc for converting data to xds, then the
% loop to convert everything


%% Jango Lab
clc
clear
params = struct( ...
    'monkey_name','Jango', ...
    'array_name','M1', ...
    'task_name','WI', ...
    'ran_by','SN', ...
    'lab',1, ...
    'bin_width',0.05, ...
    'sorted',0, ...
    'requires_raw_emg',1);

map_dir = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab-archive\Retired Animal Logs\Monkeys\Jango 12A1\Array_Maps\';
map_name = 'SN6250-000945.cmp';


%% Conversion time!
% we're gonna run this on every .nev file in 
% E:\Data\Kevin\CDS_conversion
% as a default

base_dir = 'E:\Data\Kevin\CDS_conversion\';
file_list = dir([base_dir,'*.nev']);
save_dir = 'E:\Data\Kevin\CDS_conversion\';

for ii = 1:numel(file_list)
    [~, file_name, ~] = fileparts(file_list(ii).name);
    xds = raw_to_xds(base_dir, file_name, map_dir, map_name, params);
    save_name = strcat(save_dir, filesep, file_name,'_xds');
    save(strcat(save_name, '.mat'),'xds');
    clear xds

end


disp('done')