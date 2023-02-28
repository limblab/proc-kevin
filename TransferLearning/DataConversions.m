%% Jaco Lab
clc
clear
params = struct( ...
    'monkey_name','Jaco', ...
    'array_name','M1', ...
    'task_name','ball_drop', ...
    'ran_by','Unknown', ...
    'lab',1, ...
    'bin_width',0.05, ...
    'sorted',0, ...
    'requires_raw_emg',1);

map_dir = 'D:\Kevin\Jaco\';
map_name = '1025-0397.cmp';


%% Theo Lab
clc
clear
params = struct( ...
    'monkey_name','Theo', ...
    'array_name','M1', ...
    'task_name','ball_drop', ...
    'ran_by','CE', ...
    'lab',1, ...
    'bin_width',0.05, ...
    'sorted',0, ...
    'requires_raw_emg',1);

map_dir = 'D:\Kevin\Theo\';
map_name = '1025-0397.cmp';

%% Conversion time!
% we're gonna run this on every .nev file in 
% as a default

base_dir = 'D:\Kevin\Theo\';
file_list = dir([base_dir,'*.nev']);
save_dir = 'D:\Kevin\Theo\';

for ii = 1:numel(file_list)
    [~, file_name, ~] = fileparts(file_list(ii).name);
%     nev = openNEV([base_dir,file_name,'.nev'],'read','nomat','nosave');
%     nev.Data.Spikes.Unit = zeros(size(nev.Data.Spikes.Unit),'uint16');
%     saveNEV(nev,[base_dir,filesep,file_name,'.nev']);
    xds = raw_to_xds(base_dir, file_name, map_dir, map_name, params);
    save_name = strcat(save_dir, filesep, file_name,'_xds');
    save(strcat(save_name, '.mat'),'xds');
    clear xds

end


disp('done')