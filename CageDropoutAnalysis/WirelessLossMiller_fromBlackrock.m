clear all
close all

NS6 = openNSx(); 

SampleLengthCutoff = 300; % Minimum length of dropouts to display in the output vector

for i = 1:size(NS6.Data,1)
    NS6.Data(i,:) = [1 diff(NS6.Data(i,:))];
    NS6.Data(i,NS6.Data(i,:)>0) = 1;
    NS6.Data(i,NS6.Data(i,:)<0) = 1;
end

LossSum = sum(abs(NS6.Data),1);
LossSum = LossSum(200:end); %Lose timestamp buffering period

LossVec = zeros(1,length(LossSum)-6);

for i = 3:length(LossSum)-3
    if LossSum(i) == 0 && LossSum(i+1) == 0 && LossSum(i+2) == 0
        LossVec(i) = 1;
    end
    if LossSum(i) == 0 && LossSum(i-1) == 0 && LossSum(i+1) == 0
        LossVec(i) = 1;
    end
    if LossSum(i) == 0 && LossSum(i-1) == 0 && LossSum(i-2) == 0
        LossVec(i) = 1;
    end
end

streakStarts = find(diff([0 LossVec 0]) == 1);
streakStops = find(diff([0 LossVec 0]) == -1);
lossLengths = streakStops-streakStarts;

disp('Median dropout length (in samples):');
disp(median(lossLengths)-1);

disp('Mean dropout length (in samples):');
disp(mean(lossLengths)-1);

disp('Longest dropout (in samples):')
disp(max(lossLengths)-1);

disp('Number of Dropouts Greater than 10 ms:');
disp(length(find(lossLengths>301)));

disp('Loss Percentage:')
disp(round((length(find(LossVec==1))-length(lossLengths))/length(LossSum),2));


LossVec = [zeros(1,200+NS6.MetaTags.Timestamp) LossVec];

dropoutsTimestamps = streakStarts(find(lossLengths>SampleLengthCutoff+1));
dropoutsTimestamps = dropoutsTimestamps + 198 + NS6.MetaTags.Timestamp; % Timestamps of thresholded dropouts in 30,000 Hz timestamps
dropoutsSeconds = dropoutsTimestamps/30000; % Timestamps of thresholded dropouts in seconds. 





