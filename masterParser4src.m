%% Parse through results from all three methods
close all
clear
clc

load('sepHOAverifyData4src.mat')
sepHOA = master;
load('spatFiltVerifyData4src.mat') % But only use MaxRE performance
spatFilt = master;
load('NMFverifyData4src.mat')
NMF = master;

% We'll only look at averages to keep it clean

bass = figure;
drums=figure;
other = figure;
vocals=figure;
angSep = 0:10:180;

reverbs = [0.01, 0.2, 0.4, 0.7];

for angleIdx=1:4
    
    bassHOA = zeros(10,4);
    drumsHOA = zeros(10,4);
    otherHOA = zeros(10,4);
    vocalsHOA = zeros(10,4);
    
    bassSpat = zeros(10,4);
    drumsSpat = zeros(10,4);
    otherSpat = zeros(10,4);
    vocalsSpat = zeros(10,4);
    
    bassNMF = zeros(10,4);
    drumsNMF = zeros(10,4);
    otherNMF = zeros(10,4);
    vocalsNMF = zeros(10,4);
    
    for maxlim = 1:4
        
        for songIdx = 1:10
            bassHOA(songIdx, maxlim) = sepHOA(angleIdx, maxlim, songIdx).SAR(1);
            drumsHOA(songIdx, maxlim) = sepHOA(angleIdx, maxlim, songIdx).SAR(2);
            otherHOA(songIdx, maxlim) = sepHOA(angleIdx, maxlim, songIdx).SAR(3);
            vocalsHOA(songIdx, maxlim) = sepHOA(angleIdx, maxlim, songIdx).SAR(4);
            
            bassSpat(songIdx, maxlim) = spatFilt(angleIdx, maxlim, songIdx).SAR(1);
            drumsSpat(songIdx, maxlim) = spatFilt(angleIdx, maxlim, songIdx).SAR(2);
            otherSpat(songIdx, maxlim) = spatFilt(angleIdx, maxlim, songIdx).SAR(3);
            vocalsSpat(songIdx, maxlim) = spatFilt(angleIdx, maxlim, songIdx).SAR(4);
            
            bassNMF(songIdx, maxlim) = NMF(maxlim, songIdx).SAR(1);
            drumsNMF(songIdx, maxlim) = NMF(maxlim, songIdx).SAR(2);
            otherNMF(songIdx, maxlim) = NMF(maxlim, songIdx).SAR(3);
            vocalsNMF(songIdx, maxlim) = NMF(maxlim, songIdx).SAR(4);
        end
    end
    
    figure(bass)
    subplot(2, 2, angleIdx)
    plot(reverbs, mean(bassHOA, 'omitnan'), 'k', reverbs, mean(bassSpat), 'b',...
        reverbs, mean(bassNMF), 'r')
    title(['Room configuration ' num2str(angleIdx)])
    ylabel('SAR (dB)')
    xlabel('Reverb time (s)')
    if maxlim==1
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'southeast')
    else
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'northeast')
    end
    grid on
    grid minor
    ylim([-10 40]);
    
    figure(drums)
    subplot(2, 2, angleIdx)
    plot(reverbs, mean(drumsHOA, 'omitnan'), 'k', reverbs, mean(drumsSpat), 'b',...
        reverbs, mean(drumsNMF), 'r')
    title(['Room configuration ' num2str(angleIdx)])
    ylabel('SAR (dB)')
    xlabel('Reverb time (s)')
    if maxlim==1
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'southeast')
    else
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'northeast')
    end
    grid on
    grid minor
    ylim([-10 40]);
    
    figure(other)
    subplot(2, 2, angleIdx)
    plot(reverbs, mean(otherHOA, 'omitnan'), 'k', reverbs, mean(otherSpat), 'b',...
        reverbs, mean(otherNMF), 'r')
    title(['Room configuration ' num2str(angleIdx)])
    ylabel('SAR (dB)')
    xlabel('Reverb time (s)')
    if maxlim==1
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'southeast')
    else
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'northeast')
    end
    grid on
    grid minor
    ylim([-10 40]);
    
    figure(vocals)
    subplot(2, 2, angleIdx)
    plot(reverbs, mean(vocalsHOA, 'omitnan'), 'k', reverbs, mean(vocalsSpat), 'b', ...
        reverbs, mean(vocalsNMF), 'r')
    title(['Room configuration ' num2str(angleIdx)])
    ylabel('SAR (dB)')
    xlabel('Reverb time (s)')
    if maxlim==1
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'southeast')
    else
        legend({'HOA', 'Spatial', 'NMF'}, 'Location', 'northeast')
    end
    grid on
    grid minor
    ylim([-10 40]);
    
end

figure(bass)
sgtitle('Bass mean SAR for three methods')

figure(drums)
sgtitle('Drums mean SAR for three methods')

figure(other)
sgtitle('Other mean SAR for three methods')

figure(vocals)
sgtitle('Vocals mean SAR for three methods')

