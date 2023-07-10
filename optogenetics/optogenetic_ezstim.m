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


function optogenetic_ezstim(varargin)

    % default values:
    monkey = 'Sherry';
    savedir = 'C:\data\Sherry\20230622\';
    amplitude = 5; % control voltage value
    frequency = 1; % frequency in hertz
    pw = 20; % pulse width in ms
    stim_length = 60; % length of stimulus train (seconds)



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
    if strcmp(savedir,'') == 1
        savedir = ['C:\Data\',monkey,filesep,datestr(now,'yyyymmdd')];
    end

    % create the recording folder as necessary etc
    if ~exist(savedir)
        mkdir(savedir);
    end

    % storage file name
    %filename = strjoin([savedir,filesep,datestr(now,'yyyymmdd_HHMMSS'),'_',monkey,...
    %            '_amp',num2str(amplitude),...
    %            '_freq',num2str(frequency),...
    %            '_pw',num2str(pw),...
    %            '_stimLen',num2str(stim_length)],'');
    filename = [savedir,filesep,datestr(now,'yyyymmdd_HHMMSS'),'_',monkey,...
                '_amp',num2str(amplitude),...
                '_freq',num2str(frequency),...
                '_pw',num2str(pw),...
                '_stimLen',num2str(stim_length)];
    disp(filename)


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

    % EMG channels 1-4 on at 2khz sampling, 10-250hz BP filter
    for ii = 257:260
        cbmex('config',ii,'smpgroup',5,'smpfilter',0)
    end

    % recording the pulse control signal -- channel 6
    cbmex('config',262,'smpgroup',5,'smpfilter',0)


    % convert values to cerebus 
    % voltages to DAQ steps (5V = 32676, -5 = -32676)
    volt_c = amplitude*(32676);

    % seconds to 30000 samples
    period_samp = 33333/frequency;
    % pw to 30000 samples
    hi_samp = pw*33.332;
    lo_samp = period_samp-hi_samp;


    % recording start 
    % start recording, wait half a second, then start stimulating
    cbmex('trialconfig',1)
    cbmex('fileconfig',char(filename),'',1)
    pause(.5)
    
    % comment telling the cerebus we're sampling
    comment = strjoin(['Starting stimulation -- ',string(amplitude),' volts, ',...
            string(frequency),' hertz',string(pw),' ms pulse width for',...
            string(stim_length),' seconds']);
    cbmex('comment',0,0,char(comment))
    
    % start the stim
    cbmex('analogout',1,'sequence',[hi_samp,volt_c,lo_samp,0])

    % stop stim
    pause(stim_length)

    % stop the stim
    cbmex('analogout',1,'sequence',[1000,0])

    % pause another half second
    pause(.5)

    % stop the recording
    cbmex('fileconfig',char(filename),'',0)
    cbmex('trialconfig',0)
    cbmex('close')

end




