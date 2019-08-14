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
ranBy = 'Matt';
task = 'cage';
lab = 6;
array_names = 'arrayPMd';

%% Chewie M1 array
mapFile = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab-archive\Retired Animal Logs\Monkeys\Mihili 12A3\old_array_maps\Mihili Right M1 SN  6250-000989.cmp';
monkey = 'Chewie';
ranBy = 'Matt';
task = 'CO';
lab = 3;
array_names = 'rightM1';


%% Greyson left M1
mapFile = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\Greyson_17L2\Array Map Files\6250-002085 (Right M1 2019)\SN 6250-002085.cmp';
monkey = 'Greyson';
ranBy = 'KevinAndXuan';
task = 'cage';
lab = 1;
array_names = 'leftM1';


%% Jaco 
mapFile = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Lab-Wide Animal Info\Implants\Blackrock Array Info\Array Map Files\1025-0397\1025-0397.cmp'
monkey = 'Jaco';
ranBy = 'ChristianE'
task = 'multi_gadget';
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

d = dir('*.nev');


for ii = 1:length(d)
clear cds
clc
sprintf('Converting file %i of %i',ii,length(d))
cds = commonDataStructure;
% file =  'D:\Greyson\20190415\20190415_Greyson_isoWF_003.nev';
file = [pwd,filesep,d(ii).name];
filesplit = strsplit(file,'.');
if ~exist([strjoin(filesplit(1:end-1),'.'),'_cds.mat'],'file')
    try
        cds.file2cds(file,lab,['array', array_names],['monkey', monkey],['task', task],['ranBy', ranBy],'ignoreJumps',['mapFile', mapFile]);
        disp('Created CDS')
    catch
        disp('error in creating CDS. Going to save it anyways');
    end
    
    save([strjoin(filesplit(1:end-1),'.'),'_cds.mat'],'cds')
end

disp('Save Completed')

end