function remote_drive_reorganization(base_dir,target_dir)
%% remote_drive_reorganization(base_dir, target_dir)
%
% Rearranges directories in the limblab/data directory to fit the
% "monkey/date/*.xyz" data structure. 
% 
% -- Inputs --
%  dd : base directory for the scan. 
%
%

if ~exist('base_dir')
    base_dir = pwd;
end

if ~exist('target_dir')
    target_dir = pwd;
end

f_ext = {'.nev','.ns1','.ns2','.ns3','.ns4','.ns5','.ns6','.plx','.mat','.ccf','.png','.fig','.jpg'};

dd = [];


%% get a list of files
for ii = 1:length(f_ext)
    if isempty(dd)
        dd = dir([base_dir,filesep,'**',filesep,'*',f_ext{ii}]);
    else
        dd = [dd;dir([base_dir,filesep,'**',filesep,'*',f_ext{ii}])];
    end
    
end

%% create necessary directories and move all files
moved_files = {'Filename','name matches creation date'};

for ii = 1:length(dd)
    fn_split = strsplit(dd(ii).name,'_');
%     
%     rec_date_ind = cellfun(@str2num, fn_split, 'UniformOutput',false);
%     rec_date_ind = ~cell2mat(cellfun(@isempty, rec_date_ind, 'UniformOutput', false));
%     rec_date = fn_split{rec_date_ind};
%     
    create_date = datestr(dd(ii).date,'yyyymmdd');
    new_dir = [target_dir,filesep,create_date];
    
    % want to see if we have consistency in named date v putative creation
    % date
    rec_date_cmp = any(strcmpi(fn_split,create_date)) | any(strcmpi(fn_split,datestr(dd(ii).date,'mmddyy')));
    
    
    
    if ~exist(new_dir,'dir')
        mkdir(new_dir)
    end
    
    try
        movefile([dd(ii).folder,filesep,dd(ii).name],new_dir);
        moved_files(end+1,:) = {[dd(ii).folder,filesep,dd(ii).name],rec_date_cmp};
    end
    
end

%% Clean up empty directories

log_file = [base_dir,filesep,'log.xlsx'];

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
    xlswrite(log_file,moved_files,'Moved Files')
catch
    disp('No files moved')
end
    
    