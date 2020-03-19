warning('off')    

files = dir('./*.nev');

    
%% Interpretation of statistics
% * Max is the longest gap between two spikes (any channel)
% * POF is the percentage of recording time that was during a gap over 10 ms long
% * 99Q is the .99 quantile of the multichannel ISI

    for ii = 1:length(files)
        nev = openNEV([pwd,filesep,files(ii).name],'nomat','nosave');
        oTimeStamps = diff(double(nev.Data.Spikes.TimeStamp)/30000);
        maxGap = max(oTimeStamps);
        quantGap = quantile(oTimeStamps,.99);
        percDrop = 100*sum(oTimeStamps(oTimeStamps>.01))/nev.MetaTags.DataDurationSec;
        
        display(sprintf('\n\n\n'))
        display(sprintf(' ------------------------------------------------------- '))
        display(sprintf('%s\n',files(ii).name))
        display(sprintf('File Length: %f seconds',nev.MetaTags.DataDurationSec))
        display(sprintf('Multichannel ISI statistics:'))
        display(sprintf('max: %0.2f sec\nPOF: %0.2f\n99Q: %0.2f sec',maxGap,percDrop,quantGap))

        histogram(oTimeStamps)
        set(gca,'XLim',[0 .02])
        xlabel('multichannel ISI')
        ylabel('Incidence')
        Leefy
        snapnow()

    end

    
close all
warning('on')