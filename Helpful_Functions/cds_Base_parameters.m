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


%% Add to a cds object
cds = commonDataStructure;
file =  'X:\Jango_12a1\CerebusData\BMI-FES\20170815\20170815_Jango_KB_MG_Wired_003.nev';



cds.file2cds(file,lab,['array', array_names],['monkey', monkey],['task', task],['ranBy', ranBy],'ignoreJumps',['mapFile', mapFile]);


filesplit = strsplit(file,'.');
save([strjoin(filesplit(1:end-1),'.'),'_cds.mat'],'cds')