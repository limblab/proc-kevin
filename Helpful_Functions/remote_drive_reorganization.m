function remote_drive_reorganization(baseDir,targetDir)
%% remote_drive_reorganization(baseDir, targetDir)
%
% Rearranges directories in the limblab/data directory to fit the
% "monkey/date/*.xyz" data structure. 
% 
% -- Inputs --
%  baseDir :  base directory for the scan. Not 'dd', right?
%  targetDir: pretty obvious
% ----------------------------------------------------------------
% 
% From Mac terminal, connect to the VPN then
% open 'smb://netID:password@fsmresfiles.fsm.northwestern.edu/fsmresfiles/Basic_Sciences/Phys/L_MillerLab'
% 
% Then your baseDir is '/Volumes/L_MillerLab/data/etc.'


if ~exist('baseDir')
    baseDir = pwd;
end

if ~exist('targetDir')
    targetDir = pwd;
end


% we're going to use .nev and .plx files as our base to figure out         %some .plx in Tiki, and probably other old monkeys
% dates, then move all of the other related files.
% f_ext = {'.nev','.plx'};
%f_ext = {'.nev','.ns1','.ns2','.ns3','.ns4','.ns5','.ns6','.plx','.mat','.ccf','.png','.fig','.jpg', '.rhd'};



%% get a list of files

nevList = listFile(baseDir,'.nev'); %need the list to be the full filepath, not just the .nevs
plxList = listFile(baseDir,'.plx');


%% create necessary directories and move all files
movedFileList = {};
skippedFileList = {};
scannedDirs = {};


% first deal with all of the nevs
for ii = 1:length(nevList) 
    tic
    nev = openNEV(nevList{ii},'nomat','nosave','noread'); % only want the header info. Issue: In a folder with sorted .nev, it's going to re-open the .nev unnecessarily
    toc
    createDate = datestr(nev.MetaTags.DateTime,'yyyymmdd'); % file recording date -- should be independent of sorting etc!
    currTargetDir = [targetDir,filesep,createDate];

    if ~exist(currTargetDir,'dir') % create it if it doesn't exist
        mkdir(currTargetDir)
    end
    
    matchFileList = getMatchFiles(nevList{ii},baseDir,'.nev'); % get all of the files with the same name, different extensions
    
    for jj = 1:length(matchFileList) % get all of the matching files and move them over
        tempFN = strsplit(matchFileList{ii},filesep);
        tempDir = strjoin(tempFN(1:end-1),filesep);
        tempFN = tempFN{end};
        targetFN = [currentTargetDir,filesep,tempFN];
        if ~exist(targetFN,'file')
            movefile(matchFileList{ii},targetFN)
            movedFileList{end+1} = {matchFileList{ii},targetFN};
            scannedDirectories{end+1} = tempDir;
        else
            skippedFileList{end+1} = {tempFN, 'File Already Exists in target location'};
        end
    end
    
    
end

%% Clean up empty directories

% looks through all of the directories that had .nev files that were moved,
% then looks inside of those directories to see what wasn't moved.
%
% Will also remove any empty directories that are in that list

remDirs = {};
untouchFile = {};

scannedDirs = unique(scannedDirs); % to avoid repetition

for ii = 1:numel(scannedDirs)

    if ispc
        [~,sdContents] = system(['dir /b ',baseDir,filesep,scannedDirs{ii}]);
    else
        [~,sdContents] = system(['ls ',baseDir,filesep,scannedDirs{ii}]);
    end

    if isempty(sdContents)
        remDirs{end+1} = scannedDirs{ii}; %can we pre-allocate?
        rmdir(scannedDirs{ii})             %remove empty folder
    else
        untouchFile{end+1:end+numel(sdContents)} = {sdContents};  %if there's something left in the original folder?
    end
    
    
end


%% Spreadsheets with info about the session

save([targetDir,filesep,'fileReorganizationData'],'movedFileList','skippedFileList',...
    'scannedDirs','remDirs','untouchFile');


% try
%     xlswrite(log_file,rem_dirs,'Removed Directories')
% catch
%     disp('No directories removed')
% end
% 
% try
%     xlswrite(log_file,untouch_file,'Untouched Files')
% catch
%     disp('No files untouched')
% end
% 
% try 
%     xlswrite(log_file, duplicate_files, 'Duplicate files') %causes a problem trying to write cell arrays
% catch
%     disp('No duplicate files detected')
% end
% 
% 
% try
%     xlswrite(log_file,moved_files,'Moved Files')
% catch
%     disp('No files moved') %says no files moved, but that's not true
% end
    
end

%% supporting subfunctions

% lists out all of the .nev files in the current folder, recursively
function fileList = listFile(currDir,fileExt)
    % tack a period on the front if needed
    if ~contains(fileExt,'.')
        fileExt = ['.',fileExt];
    end
    
    % check whether pc or *nix
    if ispc
       [~,fileList] = system(['dir /s /b ',currDir,filesep,'*',fileExt]);
    else
       [~,fileList] = system(['ls -R ', currDir, '| grep \\', fileExt]);  %looking recursively
    end
    
  fileList = strsplit(fileList); % split by line breaks and tab delimiters
  fileList = fileList(~cellfun(@isempty,fileList)); % remove any empty entries

    
end


%% looks for filenames with the same "base" filename
function matchFileList = getMatchFiles(filepath,baseDir,fileExt)
    % tack a period on the front of the extension if needed
    if ~contains(fileExt,'.')
        fileExt = ['.',fileExt];
    end

    % get the filename without its whole path or extension
    baseFN = strsplit(filepath,filesep);
    baseFN = strsplit(baseFN{end},fileExt);
    baseFN = baseFN{1};
    
    % recursively look for files with the same name
    if ispc
        [~,matchFileList] = system(['dir /s /b ',baseDir,filesep,'*',baseFN,'.*']);
    else
        [~,matchFileList] = system(['ls -R ',baseDir,filesep,'*',baseFN,'.*']);
    end
    
    matchFileList = strsplit(matchFileList); % split by line breaks and tab delimiters
    matchFileList = matchFileList(~cellfun(@isempty,matchFileList)); % remove any empty entries
end
            