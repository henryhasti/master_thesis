function plotSpec(data, t, w, plotTitle, plotBool)
% Plot spectrogram of requested data. Must already be converted to log
% plotBool controls whether plot should be made (convenient to suppress
% output)
if nargin < 5
    plotBool = true;
end
if nargin < 4
    plotTitle = '';
end

if plotBool
    imagesc( t, w, data);
    set(gca,'YDir', 'normal');
    col = colorbar;
    col.Label.String = plotTitle;
    title(plotTitle)
    xlabel('Time (seconds)')
    ylabel('Frequency (Hz)')
end
end