%% cds_path
% adds directories for the path that are relevent for cds stuff


switch getenv('ComputerName')
    case 'GOB'
        addpath('C:\Users\klb807\Documents\git\ClassyDataAnalysis')
        df = dir('C:\Users\klb807\Documents\git\ClassyDataAnalysis');
        for ii = 1:length(df) % all relevent subdirectories
            if df(ii).isdir && ~any(strcmp(df(ii).name(1),{'.','@'}))
                addpath(['C:\Users\klb807\Documents\git\ClassyDataAnalysis',...
                    filesep,df(ii).name]);
            end
        end
        
        % adding stuff to easily create cds functions
        addpath('C:\Users\klb807\Documents\git\proc-kevin\Helpful_Functions');
        
        disp('CDS stuff added to the path')
    otherwise
        disp('This function hasn''t been implemented for anything besides GOB')
end
