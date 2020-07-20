%% NMF estimator verification master parser
% Parses data in master to be useful

%% Start with SAR (but a simple find and replace to work with SAR or SAR)
% master is stored as (reverb, song).SAR, SAR, SAR, perm
% reverb = 0.01, 0.2, 0.4, 0.7 seconds
% songs from 1 to 10
load NMFverifyDataSepDrums.mat
close all
% We'll average across all songs for now
% fix reverb and beamformer type

SARdrums = zeros(10, 4);
SARvocals = zeros(10, 4);

for maxlim = 1:4
    
    % Store SARs for drums and vocal estimates, for every angle and for
    % every song
    
    for songIdx = 1:10
        
        SARdrums(songIdx, maxlim) = master(maxlim, songIdx).SAR(1);
        SARvocals(songIdx, maxlim) = master(maxlim, songIdx).SAR(2);
        
    end
end

% Plot max, min, and average across the 10 songs, for both
% instruments
figure
subplot(121)
reverb = [0.01, 0.2, 0.4, 0.7];
plot(reverb, mean(SARdrums)-std(SARdrums), 'or', reverb, mean(SARdrums)+std(SARdrums), 'or', reverb, ...
    mean(SARdrums), 'ok')
ylabel('SAR (dB)')
xlabel('Reverb times (s)')
title('Drums')
ylim([-10 15])
xlim([0 0.7])
grid on
grid minor

subplot(122)
plot(reverb, mean(SARvocals)-std(SARvocals), 'or', reverb, mean(SARvocals)+std(SARvocals), 'or', reverb, ...
    mean(SARvocals), 'ok')
ylabel('SAR (dB)')
xlabel('Reverb times (s)')
title('Vocals')
ylim([-10 15])
xlim([0 0.7])
grid on
grid minor
sgtitle('Mean SAR and error')

clear reverb % other parsers use a different structure