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
movedFileList = struct('FileName',[],'OriginalDirectory',[],'NewPath',[]);
skippedFileList = struct('FileName',[],'Path',[],'Reason',[]);
scannedDirs = {};

%%
% first deal with all of the nevs
for ii = 1:length(nevList)
    try
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
        tempFN = strsplit(matchFileList{jj},filesep);
        tempDir = strjoin(tempFN(1:end-1),filesep); % get the directory name
        if strcmpi(tempDir(1),filesep) % to return the leading filesep for shared drive addresses in windows
            tempDir = [filesep,tempDir];
        end
        tempFN = tempFN{end}; % only take the actual filename
        targetFN = [currTargetDir,filesep,tempFN]; % get the future name of the file
        if ~exist(targetFN,'file')
            movefile(matchFileList{jj},targetFN)
            movedFileList(end+1).FileName = tempFN;
            movedFileList(end).OriginalDirectory = tempDir;
            movedFileList(end).NewPath = targetFN;
%             movedFileList(end,2).NewPath = targetFN;
%             movedFileList{end+1} = {matchFileList{jj},targetFN};
            scannedDirs{end+1} = tempDir;
        else
            skippedFileList(end+1).FileName = tempFN;
            skippedFileList(end).Path = tempDir;
            skippedFileList(end).Reason = 'File already exists in target location';
%             skippedFileList(end+1) = cell2table({tempFN, 'File Already Exists in target location'});
        end
    end
    
    catch
        warning(['Unable to work on file ',nevList{ii}])
        % split out the filename 
        tempFN = strsplit(nevList{ii},filesep);
        tempDir = strjoin(tempFN(1:end-1),filesep); % get the directory name
        if strcmpi(tempDir(1),filesep) % to return the leading filesep for shared drive addresses in windows
            tempDir = [filesep,tempDir];
        end
        tempFN = tempFN{end}; % only take the actual filename
        skippedFileList(end+1).FileName = tempFN;
        skippedFileList(end).Path = tempDir;
        skippedFileList(end).Reason = 'Unknown error -- skipped due to try/catch exception';
    end
    
end

% because row #1 is empty
movedFileList(1) = [];
skippedFileList(1) = [];


%% Now for the plx files

for ii = 1:length(plxList)
    try
    tic
    [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, createDate] = plx_information(plxList{ii})
    createDate = datestr(createDate,'yyyymmdd');
    toc
    currTargetDir = [targetDir,filesep,createDate];

    if ~exist(currTargetDir,'dir') % create it if it doesn't exist
        mkdir(currTargetDir)
    end
    
    
    matchFileList = getMatchFiles(plxList{ii},baseDir,'.plx'); % get all of the files with the same name, different extensions
    
    for jj = 1:length(matchFileList) % get all of the matching files and move them over
        tempFN = strsplit(matchFileList{jj},filesep);
        tempDir = strjoin(tempFN(1:end-1),filesep); % get the directory name
        if strcmpi(tempDir(1),filesep) % to return the leading filesep for shared drive addresses in windows
            tempDir = [filesep,tempDir];
        end
        tempFN = tempFN{end}; % only take the actual filename
        targetFN = [currTargetDir,filesep,tempFN]; % get the future name of the file
        if ~exist(targetFN,'file')
            movefile(matchFileList{jj},targetFN)
            movedFileList(end+1).FileName = tempFN;
            movedFileList(end).OriginalDirectory = tempDir;
            movedFileList(end).NewPath = targetFN;
            scannedDirs{end+1} = tempDir;
        else
            skippedFileList(end+1).FileName = tempFN;
            skippedFileList(end).Path = tempDir;
            skippedFileList(end).Reason = 'File already exists in target location';
        end
    end
    
    catch
        warning(['Unable to work on file ',plxList{ii}])
        % split out the filename 
        tempFN = strsplit(plxList{ii},filesep);
        tempDir = strjoin(tempFN(1:end-1),filesep); % get the directory name
        if strcmpi(tempDir(1),filesep) % to return the leading filesep for shared drive addresses in windows
            tempDir = [filesep,tempDir];
        end
        tempFN = tempFN{end}; % only take the actual filename
        skippedFileList(end+1).FileName = tempFN;
        skippedFileList(end).Path = tempDir;
        skippedFileList(end).Reason = 'Unknown error -- skipped due to try/catch exception';
    end
    
end






%% Clean up empty directories

% looks through all of the directories that had .nev files that were moved,
% then looks inside of those directories to see what wasn't moved.
%
% Will also remove any empty directories that are in that list

remDirs = {}; % a list of the directories we end up deleting

scannedDirs = unique(scannedDirs); % to avoid repetition

for ii = 1:numel(scannedDirs)

    % get contents of all scanned directories
    if ispc
        [~,sdContents] = system(['dir /b ',scannedDirs{ii}]);
    else
        [~,sdContents] = system(['ls ',scannedDirs{ii}]);
    end

    sdContents = strsplit(sdContents,'\n','CollapseDelimiters',true); % splitting long string into filenames
    sdContents = sdContents(~cellfun(@isempty,sdContents)); % get rid of empty cells
    
    if isempty(sdContents)
        remDirs{end+1} = scannedDirs{ii}; %can we pre-allocate?
        rmdir(scannedDirs{ii})             %remove empty folder
    else
        for jj = 1:numel(sdContents) % fill out the skipped file list for all remaining files
            ext = strsplit(sdContents{jj},'.');
            ext = ext{end};
            if ~strcmpi('nev',ext)
                tempFN = strsplit(sdContents{jj},filesep);
                tempFN = tempFN{end};
                skippedFileList(end+1).FileName = tempFN;
                skippedFileList(end).Path = scannedDirs{ii};
                skippedFileList(end).Reason = 'No associated nev found';
            end
        end
    end
    
    
end


%% Spreadsheets with info about the session

save([targetDir,filesep,'fileReorganizationData'],'movedFileList','skippedFileList',...
    'scannedDirs','remDirs','untouchFile');

    
end

%% supporting subfunctions

% lists out all of the .nev files in the current folder, recursively
function fileList = listFile(currDir,fileExt)
    % tack a period on the front if needed
    if ~any(strfind(fileExt,'.'))
        fileExt = ['.',fileExt];
    end
    
    % check whether pc or *nix
    if ispc
       [~,fileList] = system(['dir /s /b ',currDir,filesep,'*',fileExt]);
    else
       [~,fileList] = system(['ls -R ', currDir, '| grep \\', fileExt]);  %looking recursively
    end
    
  fileList = strsplit(fileList,'\n','CollapseDelimiters',true); % split by line breaks and tab delimiters
  fileList = fileList(~cellfun(@isempty,fileList)); % remove any empty entries

    
end


%% looks for filenames with the same "base" filename
function matchFileList = getMatchFiles(filepath,baseDir,fileExt)
    % tack a period on the front of the extension if needed
    if ~any(strfind(fileExt,'.'))
        fileExt = ['.',fileExt];
    end

    % get the filename without its whole path or extension
    baseFN = strsplit(filepath,filesep);
    baseFN = strsplit(baseFN{end},fileExt);
    baseFN = baseFN{1};
    
    % recursively look for files with the same name
    if ispc
        [~,matchFileList] = system(['dir /s /b ',baseDir,filesep,'*',baseFN,'*.*']);
    else
        [~,matchFileList] = system(['ls -R ',baseDir,filesep,'*',baseFN,'*.*']);
    end
    
    matchFileList = strsplit(matchFileList,'\n','CollapseDelimiters',true); % split by line breaks and tab delimiters
    matchFileList = matchFileList(~cellfun(@isempty,matchFileList)); % remove any empty entries
end
            