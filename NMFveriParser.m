%% NMF estimator verification master parser
% Parses data in master to be useful

%% Start with SIR (but a simple find and replace to work with SIR or SIR)
% master is stored as (reverb, song).SIR, SIR, SIR, perm
% reverb = 0.01, 0.2, 0.4, 0.7 seconds
% songs from 1 to 10
load NMFverifyDataSepDrums.mat

% We'll average across all songs for now
% fix reverb and beamformer type

SIRdrums = zeros(10, 4);
SIRvocals = zeros(10, 4);

for maxlim = 1:4
    
    % Store SIRs for drums and vocal estimates, for every angle and for
    % every song
    
    for songIdx = 1:10
        
        SIRdrums(songIdx, maxlim) = master(maxlim, songIdx).SIR(1);
        SIRvocals(songIdx, maxlim) = master(maxlim, songIdx).SIR(2);
        
    end
end

% Plot max, min, and average across the 10 songs, for both
% instruments
figure
subplot(121)
reverb = [0.01, 0.2, 0.4, 0.7];
plot(reverb, min(SIRdrums), 'ok', reverb, max(SIRdrums), 'ok', reverb, ...
    mean(SIRdrums), 'ok', reverb, zeros(size(reverb)))
ylabel('SIR (dB)')
xlabel('Reverb times (s)')
title('Drums')
ylim([-30 30])
xlim([0 0.7])

subplot(122)
plot(reverb, min(SIRvocals), 'ok', reverb, max(SIRvocals), 'ok', reverb, ...
    mean(SIRvocals), 'ok', reverb, zeros(size(reverb)))
ylabel('SIR (dB)')
xlabel('Reverb times (s)')
title('Vocals')
ylim([-30 30])
xlim([0 0.7])
sgtitle('SIR performance: Max, Min, and Mean')

clear reverb % other parsers use a different structure