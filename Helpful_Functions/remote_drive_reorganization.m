function remote_drive_reorganization(baseDir,targetDir)
%% remote_drive_reorganization(baseDir, targetDir)
%
% Rearranges directories in the limblab/data directory to fit the
% "monkey/date/*.xyz" data structure. 
% 
% -- Inputs --
%  dd : base directory for the scan. 
%
%

if ~exist('baseDir')
    baseDir = pwd;
end

if ~exist('targetDir')
    targetDir = pwd;
end


% we're going to use .nev and .plx files as our base to figure out
% dates, then move all of the other related files.
f_ext = {'.nev','.plx'};
%f_ext = {'.nev','.ns1','.ns2','.ns3','.ns4','.ns5','.ns6','.plx','.mat','.ccf','.png','.fig','.jpg', '.rhd'};



%% get a list of files

nevList = listFile(baseDir,'.nev');
plxList = listFile(baseDir,'.plx');


%% create necessary directories and move all files
movedFiles = {'Filename','name matches creation date'};
duplicateFiles = {'Filename', 'name matches creation date'};

% first deal with all of the nevs
for ii = 1:length(nevList) 
    nev = openNev(nevList{ii},'nomat','nosave','noread') % only want the header info
    createDate = datestr(nev.MetaTags.DateTime,'yyyymmdd'); % file recording date -- should be independent of sorting etc!
    currTargetDir = [targetDir,filesep,createDate];

    if ~exist(currTargetDir,'dir') % create it if it doesn't exist
        mkdir(currTargetDir)
    end
    
    matchFileList = getMatchFiles(nevList{ii},baseDir,'.nev'); % get all of the files with the same name, different extensions
    matchFileList{end+1} = nevList{ii};
    

    
end

%% Clean up empty directories

log_file = [baseDir,filesep,'log.xlsx'];

rem_dirs = {};
untouch_file = {};

scanned_dirs = unique({dd.folder});

for ii = 1:numel(scanned_dirs)
    sd_info = dir(scanned_dirs{ii});
    sd_info = sd_info(3:end);
    if isempty(sd_info)
        rem_dirs{end+1} = scanned_dirs{ii};
        rmdir(scanned_dirs{ii})
    else
        sd_info = sd_info(~[sd_info.isdir]);
        untouch_file(end+1:end+numel(sd_info)) = {sd_info.name};
    end
    
end



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
    xlswrite(log_file, duplicate_files, 'Duplicate files')
catch
    disp('No duplicate files detected')
end


try
    xlswrite(log_file,moved_files,'Moved Files')
catch
    disp('No files moved')
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
        [stat,fileList] = system(['ls -R ',currDir,filesep,'*',fileExt]);
    end
    
    fileList = strsplit(fileList); % split by line breaks and tab delimiters
    fileList = fileList(~cellfun(@isempty,fileList)); % remove any empty entries

    
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
        [stat,matchFileList] = system(['dir /s /b ',currDir,filesep,'*',baseFN,'.*']);
    else
        [stat,matchFileList] = system(['ls -R ',currDir,filesep,'*',baseFN,'.*']);
    end
    
    matchFileList = strsplit(matchFileList); % split by line breaks and tab delimiters
    matchFileList = matchFileList(~cellfun(@isempty,matchFileList)); % remove any empty entries
end
            