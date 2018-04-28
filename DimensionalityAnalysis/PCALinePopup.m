function handleObj = PCALinePopup(handleObj,hit)
% PCALinePopup

h = datacursormode(handleObj.Parent.Parent);
h.Enable = 'on';
% keyboard
h.UpdateFcn = @update_function;


end


function updateTxt = update_function(~,eventObj)
    timeFrame = eventObj.Target.UserData.timeFrame;
    sgmnt = eventObj.Target.UserData.segment;
    updateTxt = sprintf('Start: %s\nEnd: %s\nSegment: %i',datestr(timeFrame(1)),...
            datestr(timeFrame(2)),sgmnt);
end