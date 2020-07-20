%% Parse through results from all three methods

load('sepHOAverifyData.mat')
sepHOA = master;
load('spatFiltVerifyData.mat') % But only use MaxRE performance
spatFilt = master;
load('NMFverifyData.mat')
NMF = master;

% We'll only look at averages to keep it clean

drums=figure;
vocals=figure;
angSep = 0:10:180;

reverb{1} = 0.01;
reverb{2} = 0.2;
reverb{3} = 0.4;
reverb{4} = 0.7;
for maxlim=1:4
    
    drumsHOA = zeros(10,19);
    vocalsHOA = zeros(10,19);
    drumsSpat = zeros(10,19);
    vocalsSpat = zeros(10,19);
    drumsNMF = zeros(10,19);
    vocalsNMF = zeros(10,19);
    
    for angleIdx = angSep/10+1
        
        for songIdx = 1:10
            drumsHOA(songIdx, angleIdx) = sepHOA(angleIdx, maxlim, songIdx).SAR(1);
            vocalsHOA(songIdx, angleIdx) = sepHOA(angleIdx, maxlim, songIdx).SAR(2);
            
            drumsSpat(songIdx, angleIdx) = spatFilt(angleIdx, maxlim, songIdx, 2).SAR(1);
            vocalsSpat(songIdx, angleIdx) = spatFilt(angleIdx, maxlim, songIdx, 2).SAR(2);
            
            drumsNMF(songIdx, angleIdx) = NMF(maxlim, songIdx).SAR(1);
            vocalsNMF(songIdx, angleIdx) = NMF(maxlim, songIdx).SAR(2);
        end
    end
    
    figure(drums)
    subplot(2, 2, maxlim)
    plot(angSep, mean(drumsHOA, 'omitnan'), 'k', angSep, mean(drumsSpat), 'b',...
        angSep, mean(drumsNMF), 'r')
    title([num2str(reverb{maxlim}) ' s reverb'])
    ylabel('SAR (dB)')
    xlabel('Degrees between sources')
    ylim([-15 35])
    xlim([0 180])
    if maxlim==1
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'southeast')
    else
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'northeast')
    end
    grid on
    grid minor
    
    figure(vocals)
    subplot(2, 2, maxlim)
    plot(angSep, mean(vocalsHOA, 'omitnan'), 'k', angSep, mean(vocalsSpat), 'b', ...
        angSep, mean(vocalsNMF), 'r')
    title([num2str(reverb{maxlim}) ' s reverb'])
    ylabel('SAR (dB)')
    xlabel('Degrees between sources')
    ylim([-15 35])
    xlim([0 180])
    if maxlim==1
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'southeast')
    else
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'northeast')
    end
    grid on
    grid minor
    
end

figure(drums)
sgtitle('Drums mean SAR for three methods')

figure(vocals)
sgtitle('Vocals mean SAR for three methods')

