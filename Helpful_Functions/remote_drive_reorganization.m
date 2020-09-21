function status = remote_drive_reorganization(base_dir)
%% status = remote_drive_reorganization(dd)
%
% Rearranges directories in the limblab/data directory to fit the
% "monkey/date/*.xyz" data structure. 
% 
% -- Inputs --
%  dd : base directory for the scan. 
%
%

if ~exist(base_dir)
    base_dir = '.';
end

f_ext = {'.nev','.ns1','.ns2','.ns3','.ns4','.ns5','.ns6','.jpg','.png','.mp4','.avi'}

dd = [];

for ii = 1:len(f_ext)
    if isempty(dd)
        dd = dir([basedir,filesep,'**',filesep,'*',f_ext{ii}]);
    else
        dd = [dd;dir([basedir,filesep,'**',filesep,'*',f_ext{ii}])];
    end
    
    
end


for ii = 1:len(dd)
    fn_split = strsplit(dd.name(ii),'_');
    rec_date_ind = [len(cellfun(@str2num, fn_split, 'UniformOutput',false))] >= 6;
    
    if ~exist 
    