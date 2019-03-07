%% just a list of all the fields for cds so that I can run easy copy paste when I want to

%% Jango Lab - wireless
mapFile = 'D:\Jango\SN6250-000945.cmp'; % Jango Array map for wired
monkey = 'Jango';
ranBy = 'Kevin';
task = 'multi_gadget'; % might have to change this
lab = 1; % we should fix this, yeah?
array_names = 'arrayM1';


%% Fish in cage
mapFile = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\Fish_12H2\Array Maps\LeftM1 -doublecheck\SN 6250-001687.cmp'; % fish array map
monkey = 'Fish';
ranBy = 'Kevin';
task = 'cage'; % might have to change this
lab = 1; % we should fix this, yeah?
array_names = 'arrayM1';


%% Chewie PMd array
mapFile = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Lab-Wide Animal Info\Implants\Blackrock Array Info\Array Map Files\6251-001469\SN 6251-001469.cmp';
monkey = 'Chewie';
ranBy = 'Kevin';
task = 'cage';
lab = 6;
array_names = 'arrayPMd';


%% Greyson left M1
mapFile = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\Greyson_17L2\Array Map Files\6250-001696 (Left M1 2018)\SN 6250-001696.cmp';
monkey = 'Greyson';
ranBy = 'Kevin';
task = 'cage';
lab = 0;
array_names = 'leftM1';


%% Jaco 
mapFile = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Lab-Wide Animal Info\Implants\Blackrock Array Info\Array Map Files\1025-0397\1025-0397.cmp'
monkey = 'Jaco';
ranBy = 'ChristianE'
task = 'ball_drop';
lab = 1;
array_names = 'rightM1';

%% Kevin
mapFile = 'Z:\limblab-archive\Retired Animal Logs\Monkeys\Kevin 12A2\Array_Maps\SN 6250-001273.cmp';
monkey = 'Kevin';
ranBy = 'StephNaufel';
task = 'WF';
lab = 1;
array_names = 'rightM1';




%% Add to a cds object
clc
cds = commonDataStructure;
file =  'D:\ForEge\Kevin_20150520_WmHandleHorizXaxisonly_Utah14EMGs_SN_005.nev';


cds.file2cds(file,lab,['array', array_names],['monkey', monkey],['task', task],['ranBy', ranBy],'ignoreJumps',['mapFile', mapFile]);
('Created CDS')

filesplit = strsplit(file,'.');
save([strjoin(filesplit(1:end-1),'.'),'_cds.mat'],'cds')

disp('Save Completed')