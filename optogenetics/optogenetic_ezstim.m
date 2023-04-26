%% optogenetic_ezstim.m
%
% Tells the system to stimulate with a specific frequency, amplitude,
% and pulse width.
%
% inputs are optional key/value pairs:
%   - monkey: monkey's name [default: Sherry]
%   - savedir: directory to save the file [default: C:\Data\{monkey}\{date}]
%   - amplitude: control line voltage in volts [default: 5]
%   - frequency: pulse frequency in hertz [default: 1]
%   - pw: pulse width in milliseconds [default: 20]
%   


function = optogenetic_ezstim(varargin)

    % default values:
    monkey = 'Sherry';
    savedir = '';
    amplitude = 5; % control voltage value
    frequency = 1; % frequency in hertz
    pw = 20; % pulse width in ms
    stim_length = 10; % length of stimulus train (seconds)



    % parse inputs
    for ii = 1:2:length(varargin)
        switch varargin(ii)
            case 'monkey'
                monkey = varargin(ii+1);
            case 'savedir'
                savedir = varargin(ii+1);
            case 'amplitude'
                amplitude = varargin(ii+1);
            case 'frequency'
                frequency = varargin(ii+1);
            case 'pw'
                pw = varargin(ii+1);
            case 'stim_length'
                stim_length = varargin(ii+1);
            otherwise
                error('Unexpected key/value pair')
        end
    end


    % -------------
    % File storage preparations
    % -------------

    % setup the default save directory if needed
    if strcmp(savedir,'') == 1:
        savedir = ['C:\Data\',monkey,filesep,datestr(today,'yyyymmdd')];
    end

    % create the recording folder as necessary etc
    if ~exists(savedir)
        mkdir(savedir);
    end

    % storage file name
    filename = [savedir,filesep,datestr(today,'yyyymmdd_HH:MM:SS'),'_',monkey,
                '_amp',amp,...
                '_freq',frequency,...
                '_pw',pw,...
                '_stimLen',stim_length];


    % -----------
    % Cerebus setups
    % -----------

    % initialize cbmex
    cbmex('open')
    cbmex('trialconfig',0)

    % cerebus parameters -- this is designed for the 256 channel cerebus!
    % neural channels off
    for ii = 1:256
        cbmex('config',ii,'smpgroup',0)
    end

    % EMG channels 1-5 on at 2khz sampling, 10-250hz BP filter
    for ii = 257:261
        cbmex('config',ii,'smpgroup',3,'smpfilter',9)
    end

    % recording the pulse control signal -- channel 6
    cbmex('config',262,'smpgroup',3,'smpfilter',0)


    % convert values to cerebus 
    % voltages to DAQ steps (5V = 32676, -5 = -32676)
    volt_c = amp*(32676/5);

    % seconds to 30000 samples
    period_samp = 30000/freq;
    % pw to 30000 samples
    hi_samp = pw*33;
    lo_samp = period_samp-hi_samp;


    % recording start 
    % start recording, wait half a second, then start stimulating
    cbmex('trialconfig',1)
    cbmex('fileconfig',filename,'',1)
    sleep(.5)
    
    % comment telling the cerebus we're sampling
    cbmex('comment',0,0,['Starting stimulation -- ',amp,' volts, ',...
            frequency,' hertz',pw,' ms pulse width for',stim_length,' seconds'])
    
    % start the stim
    cbmex('analogout',1,'sequence',hi_samp,volt_c,lo_samp,0)

    % stop stim
    sleep(stim_length)

    % stop the stim
    cbmex('analogout',1,'sequence',0,1000)

    % pause another half second
    sleep(.5)

    % stop the recording
    cbmex('fileconfig',filename,'',0)
    cbmex('trialconfig',0)
    cbmex('close')

end




