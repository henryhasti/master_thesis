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
            drumsHOA(songIdx, angleIdx) = sepHOA(angleIdx, maxlim, songIdx).SDR(1);
            vocalsHOA(songIdx, angleIdx) = sepHOA(angleIdx, maxlim, songIdx).SDR(2);
            
            drumsSpat(songIdx, angleIdx) = spatFilt(angleIdx, maxlim, songIdx, 2).SDR(1);
            vocalsSpat(songIdx, angleIdx) = spatFilt(angleIdx, maxlim, songIdx, 2).SDR(2);
            
            drumsNMF(songIdx, angleIdx) = NMF(maxlim, songIdx).SDR(1);
            vocalsNMF(songIdx, angleIdx) = NMF(maxlim, songIdx).SDR(2);
        end
    end
    
    figure(drums)
    subplot(2, 2, maxlim)
    plot(angSep, mean(drumsHOA, 'omitnan'), angSep, mean(drumsSpat), ...
        angSep, mean(drumsNMF), angSep, zeros(size(angSep)))
    title([num2str(reverb{maxlim}) ' s reverb'])
    ylabel('SDR (dB)')
    xlabel('Degrees between sources')
    legend({'HOA', 'spatial', 'NMF'}, 'Location', 'southeast')
    
    figure(vocals)
    subplot(2, 2, maxlim)
    plot(angSep, mean(vocalsHOA, 'omitnan'), angSep, mean(vocalsSpat), ...
        angSep, mean(vocalsNMF), angSep, zeros(size(angSep)))
    title([num2str(reverb{maxlim}) ' s reverb'])
    ylabel('SDR (dB)')
    xlabel('Degrees between sources')
    legend({'HOA', 'spatial', 'NMF'}, 'Location', 'southeast')
    
    
end

figure(drums)
sgtitle('Drums SDR performance - average')

figure(vocals)
sgtitle('Vocals SDR performance - average')

