%% DOA estimator verification master parser
% Parses data in master to be useful

%% Start with SAR (but a simple find and replace to work with SAR or SAR)
% master is stored as (angle, reverb, song, beamformer).SAR, SAR, SAR, perm
% Angle = 0 to 180º in 10º steps
% reverb = 0.01, 0.2, 0.4, 0.7 seconds
% songs from 1 to 10
% beamformer = basic, MaxRE, in-phase
load NMFverifyData4src.mat
% We'll average across all songs for now
% fix reverb and beamformer type

reverb{1} = 0.01;
reverb{2} = 0.2;
reverb{3} = 0.4;
reverb{4} = 0.7;
reverb_master = [0.01, 0.2, 0.4, 0.7];

% Store SARs for drums and vocal estimates, for every angle and for
% every song
SARbass = zeros(10, 4);
SARdrums = zeros(10, 4);
SARother = zeros(10,4);
SARvocals = zeros(10, 4);


for maxlim = 1:4
    
    for songIdx = 1:10
        
        SARbass(songIdx, maxlim) = master(maxlim, songIdx).SAR(1);
        SARdrums(songIdx, maxlim) = master(maxlim, songIdx).SAR(2);
        SARother(songIdx, maxlim) = master(maxlim, songIdx).SAR(3);
        SARvocals(songIdx, maxlim) = master(maxlim, songIdx).SAR(4);
        
    end
end
% Plot max, min, and average across the 10 songs, for all
% instruments
figure
subplot(2, 2, 1)
plot(reverb_master, mean(SARbass)-std(SARbass), 'or', reverb_master, ...
        mean(SARbass)+std(SARbass), 'or', reverb_master, mean(SARbass), ...
        'ok', reverb_master, zeros(size(maxlim)))
title('Bass')
ylabel('SAR (dB)')
xlabel('Reverb times (s)')
ylim([-10 10])
grid on
grid minor

subplot(2, 2, 2)
plot(reverb_master, mean(SARdrums)-std(SARdrums), 'or', reverb_master, ...
        mean(SARdrums)+std(SARdrums), 'or', reverb_master, mean(SARdrums), ...
        'ok', reverb_master, zeros(size(maxlim)))
title('Drums')
ylabel('SAR (dB)')
xlabel('Reverb times (s)')
ylim([-10 10])
grid on
grid minor

subplot(2, 2, 3)
plot(reverb_master, mean(SARother)-std(SARother), 'or', reverb_master, ...
        mean(SARother)+std(SARother), 'or', reverb_master, mean(SARother), ...
        'ok', reverb_master, zeros(size(maxlim)))
title('Other')
ylabel('SAR (dB)')
xlabel('Reverb times (s)')
ylim([-10 10])
grid on
grid minor

subplot(2, 2, 4)
plot(reverb_master, mean(SARvocals)-std(SARvocals), 'or', reverb_master, ...
        mean(SARvocals)+std(SARvocals), 'or', reverb_master, mean(SARvocals), ...
        'ok', reverb_master, zeros(size(maxlim)))
title('Vocals')
ylabel('SAR (dB)')
xlabel('Reverb times (s)')
ylim([-10 10])
grid on
grid minor

sgtitle('Mean SAR and error')

