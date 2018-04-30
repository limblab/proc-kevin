%
% Plot action potential waveforms of Utah array recordings
%
%       The function takes one cds or group of multiple cds (generated 
%       from a commonDataStructure) as input. 
%       The function returns a handle to the figure.
%
%       PLOT_AP_MAP( cds ): plots the mean +/- SD waveform. Channels
%           are ordered sequentially, not using an array map file
%       PLOT_AP_MAP( cds, plot_std ): bool 'plot_std' defines
%           whether the SD of the AP waveform will be plotted  
%       PLOT_AP_MAP( cds, array_map_file): 'array_map' is the path
%           to a Blacrock map file  
%       PLOT_AP_MAP( cds, ch_nbr ): 'ch_nbr' is an array that
%           defines the channels the user wants to plot. Use this to plot
%           only a subset of channels      
%       PLOT_AP_MAP( cds, array_map_file, plot_std ): 'array_map' is
%           the path to the map file provided by Blackrock. Bool 'plot_std'
%           defines whether the SD of the AP waveform will be plotted
%       PLOT_AP_MAP( cds, ch_nbr, plot_std ): 'ch_nbr' is an array
%           that defines the channels the user wants to plot. Bool
%           'plot_std' defines whether the SD of the AP waveform will be
%           plotted  
%       PLOT_AP_MAP( cds, array_map_file, plot_std, Vpp ):
%           'array_map' is the path to the map file provided by Blackrock.
%           Bool 'plot_std' defines whether the SD of the AP waveform will
%           be plotted. 'Vpp' is the peak-to-peak voltage (uV) --when not
%           specified, matlab will automatically adjust the scale of each
%           AP plot
%       PLOT_AP_MAP( cds, ch_nbr, plot_std, Vpp ): 'ch_nbr' is an
%           array that defines the channels that will be (orderly) plotted.
%           Bool 'plot_std' defines whether the SD of the AP waveform will
%           be plotted. 'Vpp' is the peak-to-peak voltage (uV) --when not
%           specified, matlab will automatically adjust the scale of each
%           AP plot
%
%
% Last edited by Kevin Bodkin - July 13, 2017
%


function varargout = plot_AP_map_cds( cds, varargin )

% get parameters
if nargin == 2
    if islogical(varargin{1})
        plot_std        = varargin{1};
    elseif isnumeric(varargin{1})
        ch_nbrs         = varargin{1};
    elseif ischar(varargin{1})
        array_map_file  = varargin{1};
    end
elseif nargin >= 3
    if isnumeric(varargin{1})
        ch_nbrs         = varargin{1};
    elseif ischar(varargin{1}) || iscell(varargin{1})
        array_map_file  = varargin{1};
    end
    plot_std            = varargin{2};
    if nargin == 4
        Vpp             = varargin{3};
    end
end

% set missing params to defaults
if ~exist('plot_std','var')
    plot_std            = true;
end

%% -------------------------------------------------------------------------
a = whos('cds');
if strcmp(a.class,'commonDataStructure')
    nbr_cds = numel(cds);
else
    error('input cds is neither a cds nor a structure')
end




%% -------------------------------------------------------------------------
% Create an array with the channels that will be plotted
if ~exist('ch_nbrs','var')
    ch_nbrs             = 1:length(cds(1).units);
    for ii = 2:nbr_cds
        if ch_nbrs ~= 1:length(cds(ii).units);
            error('CDSs have different numbers of channels')
        end
    end
end

% Define colors for each of the files
color_array             = ['k','r','b','g','m','c'];


% If an array_map file was passed, use it
if exist('array_map_file','var')
   if iscell(array_map_file)
       nbr_arr_map_files = numel(array_map_file);
   else
       nbr_arr_map_files = 1;
   end
   % if several map files have been passed, each of them will be assigned
   % to a different CDS. If not, the same will be used for all CDSs
   if nbr_arr_map_files > 1
       if nbr_arr_map_files ~= nbr_cds
           error('ERROR: The number of array_map files does not match the number of CDSs');
       end
       for jj = 1:nbr_arr_map_files
          map(jj)  = get_array_mtsapping(array_map_file{jj});
       end
   else
       for jj = 1:nbr_cds
          map(jj)  = get_array_mapping(array_map_file);
       end
   end      
end

% -------------------------------------------------------------------------
% The plot itself

% Figure handle
AP_shapes_fig           = figure('units','normalized','outerposition',[0 0 1 1]);


for jj = 1:nbr_cds
    % if no array_map file has been passed, the channels will be plotted in
    % order
    if ~exist('array_map_file','var')

        panel_ctr       = 2; % not sure why this starts at 2, not 1. May change later

        for ii = ch_nbrs(:)'

            mean_AP     = mean(cds(jj).units(ii).spikes{:,2}); % converting the spikes table into an array for the mean
            std_AP      = std(double(cds(jj).units(ii).spikes{:,2})); % and same for the std

            nbr_rc      = ceil(sqrt(length(ch_nbrs))); % number of rows and columns, to create a square layout
            
            % Plot the mean (or mean +/- SD waveform), depending on the options
            subplot(nbr_rc,nbr_rc,panel_ctr-1);
            if plot_std
                hold on, LN(jj) = plot(mean_AP,'color',color_array(jj),'linewidth',1);
                plot(mean_AP+std_AP,'color',color_array(jj),'linewidth',1,'linestyle','-.');
                plot(mean_AP-std_AP,'color',color_array(jj),'linewidth',1,'linestyle','-.');
            else
                hold on, LN(jj) = plot(mean_AP,'color',color_array(jj),'linewidth',2);
            end
            title(['ch #' num2str(ii)])
            % Readjust the scale, if specified by the user
            if exist('Vpp','var'), ylim([-Vpp/2 Vpp/2]); end
            
            panel_ctr   = panel_ctr + 1;
            
%             % add labels
%             if ii == 1
%                 ylabel('ch 1');
%             elseif rem(ii-1,nbr_rc) == 0
%                 ylabel(['ch ' num2str(ii)])
%             end
%             if ii >= (nbr_rc*(nbr_rc-1)+1)
%                 xlabel(['ch ' num2str(ii)])
%             end
        end
    %----------------------------------------------------------------------    
    % if we passed an array file    
    else
        for ii = ch_nbrs(:)'
             
            mean_AP     = mean(cds(jj).units(ii).spikes{:,2}); % converting the spikes table into an array for the mean
            std_AP      = std(double(cds(jj).units(ii).spikes{:,2})); % and same for the std
            
                        
            [row, col]  = find( map(jj) == ii );
            
            % Plot the mean (or mean +/- SD waveform), depending on the options
            subplot(10,10,col+(row-1)*10);
            if plot_std
                hold on, LN(jj) = plot(mean_AP,'color',color_array(jj),'linewidth',1);
                plot(mean_AP+std_AP,'color',color_array(jj),'linewidth',1,'linestyle','-.');
                plot(mean_AP-std_AP,'color',color_array(jj),'linewidth',1,'linestyle','-.');
            else
                hold on, LN(jj) = plot(mean_AP,'color',color_array(jj),'linewidth',2);
            end
            % Readjust the scale, if specified by the user
            if exist('Vpp','var'), ylim([-Vpp/2 Vpp/2]); end
        end
    end
end

% % so far a legend just seems to make everything messy. Consider adding a
% % hover or tool tip that gives the names
% legend_names = {};
% for jj = 1:nbr_cds
%     legend_names(end+1) = cellstr(cds(jj).meta.rawFileName);
% end
% legend(LN,legend_names);

% -------------------------------------------------------------------------
% return the handle
if nargout == 1

    varargout{1}        = AP_shapes_fig;
elseif nargout > 1
   
    error('ERROR: the function takes at most 1 output argument');
end
