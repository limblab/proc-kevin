% %% With the original nev
% [fn,pn] = uigetfile('*.nev');
% 
% tempfilename = split(fn,'.nev');
% tempfilename = tempfilename{1};
% signal_info = {
%     initSignalStruct('filename', [pn,filesep,fn],...
%         'routine', @processNEV,...
%         'params',struct(),...
%         'name',{'rightM1','SerialDigitalIO'},...
%         'type',{'spikes','event'},...
%         'label','');
% 
%     
%     initSignalStruct('filename',[pn,filesep,tempfilename,'.ns3'],...
%         'routine',@processNSx,...
%         'params',struct(),...
%         'name',{'EMG_FDSr','EMG_FDSu','EMG_FDPr','EMG_FDPu','EMG_FCR1','EMG_ECU1','EMG_ECU2','EMG_ECR1','EMG_ECR2','EMG_EPL','EMG_EDC2','EMG_FCU1'},...
%         'label',{'EMG_FDSr','EMG_FDSu','EMG_FDPr','EMG_FDPu','EMG_FCR1','EMG_ECU1','EMG_ECU2','EMG_ECR1','EMG_ECR2','EMG_EPL','EMG_EDC2','EMG_FCU1'},...
%     	'type','EMG');
% 
%     initSignalStruct('filename',[pn,filesep,tempfilename,'.ns2'],...
%         'routine',@processNSx,...
%         'params',struct(),...
%         'name','Force_AirDevice',...
%         'label','',...
%         'type','generic');
% 
% 
% 
% };

%% with CDS
% [fn,pn] = uigetfile('*_cds.mat');
pn = uigetdir('.');

df = dir(pn);
relfile = df(contains({df.name},'_cds.mat'));

for ii = 1:numel(relfile)
    fn = relfile(ii).name;
    load([pn,filesep,fn]);
    tempfilename = strsplit(fn,'_cds.mat');
    tempfilename = [pn,filesep,tempfilename{1}];


    emg_signal_names = cds.emg.Properties.VariableNames(2:end);
    params = struct('bin_size',.001);

    meta = cds.meta;
    meta.date = datestr(meta.processedTime,'yyyymmdd');
    meta.td_taskname = meta.task;
    meta.EMGrecorded = true;


    switch meta.task
        case 'multi_gadget'
            event_names = {'startTime','endTime','touchPadTime','goCueTime','gadgetOnTime'};
            trial_meta = {'result','catchFlag','gadgetNumber','tgtCorners','tgtCenter','tgtDir'};
        case 'ball_drop'
            event_names = {'startTime','endTime','touchPadTime','goCueTime','pickupTime'};
            trial_meta = {'result','catchFlag'};
        case 'WF'
            event_names = {'startTime','endTime','tgtOnTime','goCueTime'};
            trial_meta = {'result','tgtCorners','tgtCtr','tgtDir','isCatch','adapt'};
    end



    signal_info = {
        initSignalStruct('filename', [pn,filesep,fn],...
            'routine', @processCDSspikes,...
            'params',struct(),...
            'name','rightM1',...
            'type','spikes',...
            'label','');


        initSignalStruct('filename',[pn,filesep,fn],...
            'routine',@processCDSevents,...
            'params',struct('trial_meta',{trial_meta}),...
            'name',event_names,...
            'label',event_names,...
            'type',repmat({'event'},1,length(event_names)));


        initSignalStruct('filename',[pn,filesep,fn],...
            'routine',@processCDScontinuous,...
            'params',struct('trial_meta',{trial_meta}),...
            'name',emg_signal_names,...
            'label',emg_signal_names,...
            'type',repmat({'emg'},1,length(emg_signal_names)));


    };


    if strcmp(meta.task,'multi_gadget')
        signal_info{end+1} = ...
            initSignalStruct('filename',[tempfilename,'.ns2'],...
                'routine',@processNSx,...
                'params',struct(),...
                'name','Force_AirDevice',...
                'label','Force_AirDevice',...
                'type','generic');
    end


    [TD,td_params,flag] = convertDataToTD(signal_info);
    save([tempfilename,'_TD.mat'],'TD','-v7.3')

    disp(['saved ',tempfilename,'_TD.mat'])



end



disp('done and done')

