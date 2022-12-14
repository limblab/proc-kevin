%% vibration trigger

%% create a new folder for today's date, and the appropriate file name

basedir = 'C:\Data_Lab1';
monkey = '19L2_Groot';
dToday = datestr(today,'yyyymmdd');

storageDir = [basedir,filesep,monkey,filesep,dToday];
if ~exist(storageDir,'dir')
    mkdir(storageDir)
end

filenameBase = ['C:\Data_Lab1\19L2_Groot\',dToday,'\', monkey,'_', dToday,'_PICReflex_'];




%% open cbmex, get everything prepped 
cbmex('open')
cbmex('trialconfig',0)

drawnow()

cbmex('analogout',1,'sequence',[1000 0], 'offset', 2000, 'mv', 'ms');
cbmex('analogout',2,'sequence',[1000 0], 'offset', 2000, 'mv', 'ms');
cbmex('analogout',3,'sequence',[1000 0], 'offset', 2000, 'mv', 'ms');
cbmex('analogout',4,'sequence',[1000 0], 'offset', 2000, 'mv', 'ms');

pause(1)
disp('All outputs set to 2V. Turn on machine.')

%% home the system
disp('Enabling the system')
cbmex('analogout',1,'sequence',[1000 0], 'offset', 0, 'mv', 'ms'); % enable the system
pause(1)

disp('Running the ''Home'' function')
cbmex('analogout',2,'sequence',[1000 0], 'offset', 0, 'mv', 'ms'); % turn on Home mode
input('Press any key when ''Home'' has finished')
cbmex('analogout',2,'sequence',[1000 0], 'offset', 2000, 'mv', 'ms'); % turn off Home mode
disp('Done')


%% Tap mode
disp('Enabling the system')
cbmex('analogout',1,'sequence',[1000 0], 'offset', 0, 'mv', 'ms'); % enable the system
pause(1)

filename = [filenameBase,'tap_',datestr(now(),'MM:ss')];
cbmex('fileconfig',filename,'',0)
disp('Starting recording')
cbmex('fileconfig',filename,'',1)

disp('Enabling ''Tap'' mode')
cbmex('analogout',3,'sequence',[1000 0], 'offset', 0, 'mv', 'ms'); % enable Tap mode
input('Press any key to trigger ''Tap'' mode');
cbmex('analogout',4,'sequence',[1000 0], 'offset', 0, 'mv', 'ms');
pause(1)
cbmex('analogout',4,'sequence',[1000 0], 'offset', 2000, 'mv', 'ms');


pause(10)
cbmex('analogout',3,'sequence',[2000 0], 'offset', 2000, 'mv', 'ms'); % disable tap mode
disp('Ending recording')
cbmex('fileconfig',filename,'',0)
disp('Tap mode disabled, paradigm complete')


%% Vibration Mode
disp('Enabling the system')
cbmex('analogout',1,'sequence',[1000 0], 'offset', 0, 'mv', 'ms'); % enable the system
pause(1)

filename = [filenameBase,'vib_',datestr(now(),'MM:ss')];
cbmex('fileconfig',filename,'',0)
disp('Starting recording')
cbmex('fileconfig',filename,'',1)

input('Press any key to trigger ''Vibration'' mode');
cbmex('analogout',4,'sequence',[1000 0], 'offset', 0, 'mv', 'ms');
pause(5)
cbmex('analogout',4,'sequence',[1000 0], 'offset', 2000, 'mv', 'ms');

pause(10)

disp('Ending recording')
cbmex('fileconfig',filename,'',0)
disp('Paradigm complete')

%% Close everything

input('Turn off machine. Press any key when done')
cbmex('analogout',1,'sequence',[1000 0], 'offset', 0, 'mv', 'ms');
cbmex('analogout',2,'sequence',[1000 0], 'offset', 0, 'mv', 'ms');
cbmex('analogout',3,'sequence',[1000 0], 'offset', 0, 'mv', 'ms');
cbmex('analogout',4,'sequence',[1000 0], 'offset', 0, 'mv', 'ms');

pause(1)
disp('All outputs set to 0V')
cbmex('close')

