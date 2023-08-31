function fig_handle = plot_preds(recording, prediction, time, titles)
%PLOT_PREDS 
% Easy method to consistently predictions vs recordings
% with R2 etc

if any(size(recording) ~= size(prediction)) % need the same sizes
    warning('prediction and recording must be the same sizes')
end

fig_handle = figure;
[num_signals,signal_dim] = min(size(recording)); % what dimension are we working along?
if signal_dim == 1 % flip if needed so time is the first dimension
    recording = recording';
    prediction = prediction';
end

% plot each signal on a separate axis
for ii = 1:num_signals
    R2 = 1 - mean((recording(:,ii)-prediction(:,ii)).^2,1)/var(recording(:,ii),1);

    ax(ii) = subplot(num_signals,1,ii);
    plot(time, recording(:,ii))
    hold on
    plot(time, prediction(:,ii))
    legend('Recorded','Predicted')
    title_array = [titles{ii}, ' R2 = ', num2str(R2, '%.2f')];
    title(title_array)


end

xlabel('time (s)')
linkaxes(ax,'x')
