% clear all
% close all

% keyboard;

if exist('fname')
    NS6 = openNSx(fname);
else
    NS6 = openNSx(); 
end

SampleLengthCutoff = 300; % Minimum length of dropouts to display in the output vector
actualData = [NS6.ElectrodesInfo.ElectrodeID] ~= 96;
NS6.Data = NS6.Data(actualData,:);



lock = zeros(size(NS6.Data));
for ii = 1:size(NS6.Data,1)
    lock(ii,:) = abs([1 diff(NS6.Data(ii,:))])>1;
end

LossSum = sum(lock,1);
% LossSum = LossSum(200:end); %Lose timestamp buffering period

LossVec = zeros(1,length(LossSum)-6);


% keyboard

for ii = 3:length(LossSum)-3
    if LossSum(ii) == 0 && LossSum(ii+1) == 0 && LossSum(ii+2) == 0
        LossVec(ii) = 1;
    end
    if LossSum(ii) == 0 && LossSum(ii-1) == 0 && LossSum(ii+1) == 0
        LossVec(ii) = 1;
    end
    if LossSum(ii) == 0 && LossSum(ii-1) == 0 && LossSum(ii-2) == 0
        LossVec(ii) = 1;
    end
end

streakStarts = find(diff([0 LossVec 0]) == 1);
streakStops = find(diff([0 LossVec 0]) == -1);
lossLengths = double(streakStops-streakStarts);

disp('Median dropout length (in seconds):');
medDrop = (median(lossLengths))/30000;
disp(medDrop);

disp('Mean dropout length (in seconds):');
meanDrop = (mean(lossLengths))/30000;
disp(meanDrop);

disp('Longest dropout (in seconds):')
maxDrop = (max(lossLengths))/30000;
disp(maxDrop);

disp('Number of Dropouts Greater than 10 ms:');
threshDrop = length(find(lossLengths>301));
disp(threshDrop);

disp('Loss Percentage:')
percDrop = 100*sum(lossLengths)/length(LossSum);
disp(percDrop);


LossVec = [zeros(1,200+NS6.MetaTags.Timestamp) LossVec];

dropoutsTimestamps = streakStarts(find(lossLengths>SampleLengthCutoff+1));
dropoutsTimestamps = dropoutsTimestamps + 198 + NS6.MetaTags.Timestamp; % Timestamps of thresholded dropouts in 30,000 Hz timestamps
dropoutsSeconds = dropoutsTimestamps/30000; % Timestamps of thresholded dropouts in seconds. 





