%% sepHOA estimator verification master parser
% Parses data in master to be useful
% FYI - generating this data is painstakingly slow (over 30 hours)
% 10 is the song, the time is 118729.2895
% (32h, 58m, 49s)
%% Start with SAR (but a simple find and replace to work with SAR or SAR)
% master is stored as (angle, reverb, song, beamformer).SAR, SAR, SAR, perm
% Angle = 0 to 180º in 10º steps
% reverb = 0.01, 0.2, 0.4, 0.7 seconds
% songs from 1 to 10
% beamformer = basic, MaxRE, in-phase
close all
load sepHOAverifyData.mat

drums=figure;
vocals=figure;
% We'll average across all songs for now
% fix reverb and beamformer type
angSep = 0:10:180;

clear reverb
reverb{1} = 0.01;
reverb{2} = 0.2;
reverb{3} = 0.4;
reverb{4} = 0.7;


for maxlim = 1:4
    
    % Store SARs for drums and vocal estimates, for every angle and for
    % every song
    SARdrums = zeros(10, 19);
    SARvocals = zeros(10, 19);
    
    
    for angleIdx = angSep/10 + 1
        
        for songIdx = 1:10
            
            SARdrums(songIdx, angleIdx) = master(angleIdx, maxlim, songIdx).SAR(1);
            SARvocals(songIdx, angleIdx) = master(angleIdx, maxlim, songIdx).SAR(2);
            
        end
    end
    
    % Plot max, min, and average across the 10 songs, for both
    % instruments
    figure(drums)
    subplot(2,2, maxlim)
    plot(angSep, mean(SARdrums, 'omitnan')-std(SARdrums, 'omitnan'), 'r', angSep, ...
        mean(SARdrums, 'omitnan')+std(SARdrums, 'omitnan'), 'r', angSep, mean(SARdrums, 'omitnan'), 'k')
    title([num2str(reverb{maxlim}) ' s reverb'])
    ylabel('SAR (dB)')
    xlabel('Degrees between sources')
    xlim([0 180])
    ylim([-20 40])
    grid on
    grid minor
    
    figure(vocals)
    subplot(2,2, maxlim)
    plot(angSep, mean(SARvocals, 'omitnan')-std(SARvocals, 'omitnan'), 'r', angSep, ...
        mean(SARvocals, 'omitnan')+std(SARvocals, 'omitnan'), 'r', angSep, mean(SARvocals, 'omitnan'), 'k')
    title([num2str(reverb{maxlim}) ' s reverb'])
    ylabel('SAR (dB)')
    xlabel('Degrees between sources')
    xlim([0 180])
    ylim([-20 40])
    grid on
    grid minor
end

figure(drums)
sgtitle('Drums mean SAR and error')

figure(vocals)
sgtitle('Vocals mean SAR and error')

