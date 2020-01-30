function plotSpec(data, t, w, plotTtitle)
% Plot spectrogram of requested data. Must already be converted to log
% Assumes scale of spectrogram (t,w) already exists
if nargin < 4
    plotTitle = '';
end

figure
imagesc( t, w(1:floor(end/2)), data);
set(gca,'YDir', 'normal');
col = colorbar;
col.Label.String = plotTitle;
title(plotTitle)
xlabel('Time (seconds)')
ylabel('Frequency (Hz)')

end