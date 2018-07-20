function thisFrame=getScreenshot(hf)
    orig_mode = get(hf, 'PaperPositionMode');
    set(hf, 'PaperPositionMode', 'auto');
    %hardcopy has been removed from MATLAB
    %thisFrame = hardcopy(hf, '-Dzbuffer', '-r0');
    % We will try using print with the '-RGBImage'
    thisFrame = print(hf, '-RGBImage');
    % Restore figure to original state
    set(hf, 'PaperPositionMode', orig_mode); % end
    