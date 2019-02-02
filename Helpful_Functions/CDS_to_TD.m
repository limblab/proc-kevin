%%
f = dir('C:\Users\klb807\Documents\Data\ForAlessandro\Jaco*.nev');
cd('C:\Users\klb807\Documents\Data\ForAlessandro\')




for ii = 1:length(f)
    signal_info = {};
    signal_info{1}.filename = f(ii).name;
    signal_info{1}.routine = @processNEV;
    signal_info{1}.name = 'M1_thr';
    signal_info{1}.label = {};
    for jj = 1:96
        signal_info{1}.label{jj} = ['elec',num2str(jj)];
    end
    signal_info{1}.type = 'spikes';
    
    temp_filename = strsplit(f(ii).name,'.nev');
    signal_info{2}.filename = [temp_filename{1},'.ns3'];
    signal_info{2}.routine = @processNSx;
    signal_info{2}.name = 'EMG';
    signal_info{2}.label = {'EMG_FDSr','EMG_FDSu','EMG_FDPr','EMG_FDPu',...
        'EMG_FCR1','EMG_ECU1','EMG_ECU2','EMG_ECR1','EMG_ECR2','EMG_EPL',...
        'EMG_EDC2','EMG_FCU1'};
    signal_info{2}.type = 'EMG';
    
    
    signal_info{3}.filename = [temp_filename{1},'.ns2'];
    signal_info{3}.routine = @processNSx;
    signal_info{3}.name = 'Force';
    signal_info{3}.label = 'Force_AirDevice';
    signal_info{3}.type = 'general';
    
    signal_info{4}.filename = f{ii}.name;
    signal_info{4}.routine = @processNEV;
    signal_info{4}.name = 'Trial_Info';
    signal_info.label = {};
    
end



%%

f = dir('C:\Users\klb807\Documents\Data\ForAlessandro\03-21-11\*_cds.mat');
cd('C:\Users\klb807\Documents\Data\ForAlessandro\03-21-11')

params.array_name = 'rightM1';
params.cont_signal_names = {'pos','vel'};
params.extract_emg = true;
params.trial_meta = {'result','touchPad','goCue','catchFlag','gadgetOn',...
    'tgtCorners','tgtCenter','tgtDir'};

for ii = 1:length(f)
    trial_data = loadTDfromCDS([pwd,filesep,f(ii).name],params);
    shortFilename = strsplit(f(ii).name,'.');
    save([strjoin(shortFilename(1:end-1),'.'),'_TD.mat'],'trial_data','-v7.3');
end


    