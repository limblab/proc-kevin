function Leefy(fhandle)% Sets properties of figure to what Lee likes

if nargin == 0
    longassfigurename = gcf; %get current figure
else
    longassfigurename = fhandle;
end

for a = 1:length(longassfigurename.Children) % for all axes on the figure
    longassaxisname = longassfigurename.Children(a);
    if isa(longassaxisname,'matlab.graphics.axis.Axes')
        longassaxisname.TickDir = 'out';
        longassaxisname.Box = 'off';
    elseif isa(longassaxisname,'matlab.graphics.illustration.Legend')
        longassaxisname.Box = 'off';
    end
end

%
% clear longassaxisname longassfigurename % make sure we don't have any issues bla bla

end