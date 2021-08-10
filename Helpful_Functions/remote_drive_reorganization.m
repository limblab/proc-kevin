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
f_ext = {'.nev','.plx'};
%f_ext = {'.nev','.ns1','.ns2','.ns3','.ns4','.ns5','.ns6','.plx','.mat','.ccf','.png','.fig','.jpg', '.rhd'};



%% get a list of files

nevList = listFile(baseDir,'.nev'); %need the list to be the full filepath, not just the .nevs
plxList = listFile(baseDir,'.plx');


%% create necessary directories and move all files
moved_files = {'Filename','name matches creation date'}; %do we want to fill out structures here?
duplicate_files = {'Filename', 'name matches creation date'}; %still to be developed

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
%    matchFileList{end+1} = nevList{ii}; %this seems to make a repeat of the .nev
    
    for jj = 1:length(matchFileList)
        movefile(char(matchFileList(jj)), currTargetDir);  
    end
    
    moved_files = dir(currTargetDir);
    moved_files = moved_files(3:end); %fix: just get the names
    
end

%% Clean up empty directories

log_file = [baseDir,filesep,'log.xlsx'];

rem_dirs = {};
untouch_file = {};

%scanned_dirs = unique({baseDir.folder}); %think this is attempting to get 
                                          %all folders within the directory 
                                          %specified, but this can't be dot
                                          %indexed, at least on Mac
                                         
%try this instead:
scanned_dirs = dir(fullfile(baseDir,'**'));         %recursively gets all folders, subfolders, and files from baseDir
%scanned_dirs = scanned_dirs([scanned_dirs.isdir]);  %keeps only the folders...but causes problems, see below
scanned_dirs = scanned_dirs(~ismember({scanned_dirs.name},{'.','..'})); %gets rid of current and parent directories

for ii = 1:numel(scanned_dirs)            %this will be a problem if it's all files inside
%    sd_info = dir(scanned_dirs(ii));     %trying to get all the contents of each directory?
%    sd_info = sd_info(3:end);            %and remove ., ..?

    %try this instead:
    sd_info = dir(strcat(scanned_dirs(ii).folder,filesep,scanned_dirs(ii).name)); %since everything in 'name' is a folder
    sd_info = sd_info(3:end);
    
    % i added this stuff but at this point sd_info is just one file
%    if ismac
%        sd_info = sd_info(4:end);  %Mac also has .DS_Store
%    else
%        sd_info = sdinfo(3:end);
        
    if isempty(sd_info)
        rem_dirs{end+1} = scanned_dirs{ii}; %can we pre-allocate?
        rmdir(scanned_dirs{ii})             %remove empty folder
    else
        sd_info = sd_info(~[sd_info.isdir]);
        untouch_file(end+1:end+numel(sd_info)) = {sd_info.name};  %if there's something left in the original folder?
    end
    
    
end


%% Spreadsheets with info about the session

try
    xlswrite(log_file,rem_dirs,'Removed Directories')
catch
    disp('No directories removed')
end

try
    xlswrite(log_file,untouch_file,'Untouched Files')
catch
    disp('No files untouched')
end

try 
    xlswrite(log_file, duplicate_files, 'Duplicate files') %causes a problem trying to write cell arrays
catch
    disp('No duplicate files detected')
end


try
    xlswrite(log_file,moved_files,'Moved Files')
catch
    disp('No files moved') %says no files moved, but that's not true
end
    
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
        [stat,fileList] = system(['dir /s /b ',currDir,filesep,'*',fileExt]);
    else
%        [stat,fileList] = system(['ls -R ',currDir,filesep,'*',fileExt]);  %not looking recursively
        %Try this:
        fileList = dir(fullfile(currDir,'**')); %look recursively
        fileList = (struct2cell(fileList))';    %easier format to work with
        fileList(:,2:end) = [];                 %only need names
        fileList = fileList(contains(fileList,fileExt));
    end
    
%   fileList = strsplit(fileList); % split by line breaks and tab delimiters
%   fileList = fileList(~cellfun(@isempty,fileList)); % remove any empty entries

    
end


% strips files to just get the "base" filename
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
        [stat,matchFileList] = system(['dir /s /b ',baseDir,filesep,'*',baseFN,'.*']);
    else
        [stat,matchFileList] = system(['ls -R ',baseDir,filesep,'*',baseFN,'.*']);
    end
    
    matchFileList = strsplit(matchFileList); % split by line breaks and tab delimiters
    matchFileList = matchFileList(~cellfun(@isempty,matchFileList)); % remove any empty entries
end
            