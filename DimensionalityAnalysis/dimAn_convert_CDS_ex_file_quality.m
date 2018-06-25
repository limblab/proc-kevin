%% dimAn_convert_CDS_ex_file_quality
% Despite the loooooong name, this script is actually useful
%
% it takes a given .nev filename along with a series of parameters for the
% associated file (all the CDS params) then converts it to CDS, then to
% experimental data format, and stores both. After that, it runs through a
% few basic plotting scripts I've written and sees the quality of the
% mfxval weiner predictions.
%
% Afterwards it stores the comments and plots in the dimensionality red'n
% project folder on the server. It's up to the user to move the converted
% files over to the server, since we don't want to bog down the server with
% crappy converted files.
%
% KevinHP April 2018

%-------------------------------------------------------------------------%
% Base parameters
% fileName = 'C:\Users\klb807\Documents\Data\Nev\CageData\Jango\20170524\20170524_Jango_Cage_1.nev'; % make this a local file, because running through the network is SLOW
[fileName,pathName] = uigetfile('C:\Users\klb807\Documents\Data\Nev\CageData\*.nev')

fileName = [pathName,filesep,fileName];

% CDS params. see my cds_base_parameters.m script for examples if you're
% not sure how this should look
mapFile = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Animal-Miscellany\RetiredMonkeys\Fish_12H2\Array Maps\LeftM1 -doublecheck\SN 6250-001687.cmp';
monkey = 'Fish';
ranBy = 'KBandSN';
task = 'WF';
lab = 1;
array_names = 'arrayM1';
recordDate = '';

% experimental data parameters. This will depend on what's in the recorded
% file, so change accordingly
hasTrials = true;
hasForces = true;
hasKinematics = true;
hasEmg = true;
hasUnits = true; % this better always be true

% filenames to store. Don't fuck with them please, I like my defaults
baseFilename = strsplit(fileName,'.');
baseFilename = strjoin(baseFilename(1:end-1),'.');
% make a new subfolder so the base folder doesn't get too crapped up
subFolder = [baseFilename,'_SupportFiles'];
mkdir(subFolder);
exFilename = [baseFilename,'_ex.mat']; % experiment file name
cdsFilename = [baseFilename,'_cds.mat']; % same for cds
% bmiDimAnLogFolder = '\\fsmresfiles.fsm.northwestern.edu\fsmresfiles\Basic_Sciences\Phys\L_MillerLab\limblab\lab_folder\Projects\BMI Dimensionality\Standard nevs'; % and the folder it's in?
% bmiDimAnLog = [bmiDimAnLogFolder,filesep,'standard_Files_Log.csv']; % where's the log stored?



% these get checked later, so don't bother playing with them
overWriteCDS = true;
overWriteEx = true;



%%
%-------------------------------------------------------------------------%
% load/convert files

% if the _cds and _ex.mat files exist on the user's computer, ask if we
% want to write over them or just load the existing ones
if exist(cdsFilename,'file')||exist([subFolder,filesep,cdsFilename],'file')
    owCDS = input('Do you want to reconvert and save over the existing CDS file?(Y/N)','s');
    if strcmpi(owCDS,'n')
        overWriteCDS = false;
    end
end

if (exist(exFilename,'file')||exist([subFolder,filesep,cdsFilename],'file'))&&~overWriteCDS
    owEx = input('Do you want to reconvert and save over the existing Experimental Class file?(Y?N)','s');
    if strcmpi(owEx,'n')
        overWriteEx = false;
    end
end




if ~overWriteEx % if we want to just load the file, skip all the creation steps
    disp('Loading experiment data structure')
    load(exFilename,'ex')
else
    if ~overWriteCDS % if we want to use an existing cds
        disp('Loading CDS')
        load(cdsFilename,'cds')
    else
        disp('Creating CDS')
        cds = commonDataStructure;
        cds.file2cds(fileName,lab,['array', array_names],['monkey', monkey],...
            ['task', task],['ranBy', ranBy],'ignoreJumps',['mapFile', mapFile]); % load it with all those goodies
        disp('Saving CDS')
        save(cdsFilename,'cds','-v7.3') % save it. Needs to be matlab standard v7.3+
    end
    disp('Creating experiment data structure');
    ex = experiment; % new empty experimental data class
    
    ex.meta.hasEmg = true; % want to load EMGs
    ex.meta.hasUnits = true; % and units
    ex.meta.hasTrials = hasTrials; % and trials if we have them
    ex.meta.hasForce = hasForces; % we'll just make it true for the cage, then check
    ex.meta.hasKinematics = hasKinematics;
    
    % load all the data into the experiment
    ex.addSession(cds);
%     clear cds % clear up some memory, since it's at a bit of a premium
    ex.calcFiringRate; % calculate firing rate
    
    % loading everything for the binnedData()
    ex.binConfig.include(1).field = 'units'; % bin the units
    ex.binConfig.include(2).field = 'emg'; % bin the EMGs
    ex.emg.processDefault; % filters and rectifies the so that we can bin it properly.

    if ex.meta.hasForce % bin forces if necessary
        ex.binConfig.include(end+1).field = 'force';
    end
    
    if ex.meta.hasKinematics
        ex.binConfig.include(end+1).field = 'kin'; % same with kinematics
    end
    
    ex.binData; % bin it all
%     save(exFilename,'ex','-v7.3')


end



%%
%-------------------------------------------------------------------------%
% plot firing rate and EMGs



disp('Plotting firing rate')
[binnedUnitNames,binnedUnitMask] = ex.bin.getUnitNames; % because this binnedStructure is weird
emgMask = ~cellfun(@(x)isempty(strfind(x,'EMG')),ex.bin.data.Properties.VariableNames); % and again...
emgNames = ex.bin.data.Properties.VariableNames(emgMask); % don't get it... 

% % remove channels whose mean firing rates are greater than 50 or less
% % than 1
% meanFR = mean(ex.bin.data{:,:},1); % means of everything
% meanFR = meanFR.*binnedUnitMask; % throw away non-units
% ex.bin.data{:,meanFR>50} = 0; % throw away those high firing ones

% this is one of my commands that should spit out firing rates and EMGs so that you can 
% zoom on the EMGs and it will automatically fit the FR window to the same time period.  
plot_FR_EMG(ex.bin.data{:,binnedUnitMask},ex.bin.data{:,emgMask},ex.bin.data.t,emgNames);
FREMGFilename = [subFolder,filesep,'FR_EMG_plot'];
saveas(gcf,FREMGFilename,'fig'); % save as a matlab figure to keep the listeners working
% close(gcf)

%%
%-------------------------------------------------------------------------%
% % plot mean waveforms - gives us an idea of how everything looks
% disp('Plotting waveforms, not sure this will be useful...')
% ff = plot_AP_map_cds(cds)
% clear cds; % unfortunately the earliest it looks like we can do this...
% wfFilename = [subFolder,filesep,'AP_map'];
% saveas(ff,wfFilename,'fig'); % I don't really remember what this looks like...
% close(ff);

%%
%-------------------------------------------------------------------------%
% Weiner filter -- let's try it out and see what happens
ex.bin.weinerConfig.inputList = binnedUnitNames; % unit names
ex.bin.weinerConfig.outputList = emgNames; % emgNames
ex.bin.weinerConfig.numFolds = 10; % run mfxval

ex.bin.fitWeiner;

save(exFilename,'ex','-v7.3')

%%
%-------------------------------------------------------------------------%
% store errthing inside the csv log

% logCell = {monkey,...
%             recordDate,...
%             lab,...
%             task,...
%             fileName,...
%             {mean([ex.bin.weinerData.VAF],2)},...
%             {emgNames},...
%             FREMGFilename,...
%             wfFilename};

mean([ex.bin.weinerData.VAF],2)

% dlmwrite(bmiDimAnLog,logCell,-append)