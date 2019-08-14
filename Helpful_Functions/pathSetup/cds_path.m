function cds_path
%% cds_path
% adds directories for the path that are relevent for cds stuff


switch getenv('ComputerName')
    case 'GOB'
        addpath('C:\Users\klb807\Documents\git\ClassyDataAnalysis')
        df = dir('C:\Users\klb807\Documents\git\ClassyDataAnalysis');
        add_sub_paths(df,'C:\Users\klb807\Documents\git\ClassyDataAnalysis')
        
        % adding stuff to easily create cds functions
        addpath('C:\Users\klb807\Documents\git\proc-kevin\Helpful_Functions');
        
        disp('CDS stuff added to the path')
    otherwise
        disp('This function hasn''t been implemented for anything besides GOB')
end






end




function add_sub_paths(fileList,baseDir)
        for ii = 1:length(fileList) % all relevent subdirectories
            if fileList(ii).isdir && ~any(strcmp(fileList(ii).name(1),{'.','@'}))
                fullPath = [baseDir,filesep,fileList(ii).name];
                addpath(fullPath);
                dd = dir(fullPath);
                add_sub_paths(dd,fullPath);
            end
        end
end