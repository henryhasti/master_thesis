%% sepHOA estimator verification master parser
% Parses data in master to be useful
% FYI - generating this data is painstakingly slow (over 30 hours)
% 10 is the song, the time is 118729.2895
% (32h, 58m, 49s)
%% Start with SIR (but a simple find and replace to work with SIR or SIR)
% master is stored as (angle, reverb, song, beamformer).SIR, SIR, SIR, perm
% Angle = 0 to 180º in 10º steps
% reverb = 0.01, 0.2, 0.4, 0.7 seconds
% songs from 1 to 10
% beamformer = basic, MaxRE, in-phase
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
    
    % Store SIRs for drums and vocal estimates, for every angle and for
    % every song
    SIRdrums = zeros(10, 19);
    SIRvocals = zeros(10, 19);
    
    
    for angleIdx = angSep/10 + 1
        
        for songIdx = 1:10
            
            SIRdrums(songIdx, angleIdx) = master(angleIdx, maxlim, songIdx).SIR(1);
            SIRvocals(songIdx, angleIdx) = master(angleIdx, maxlim, songIdx).SIR(2);
            
        end
    end
    
    % Plot max, min, and average across the 10 songs, for both
    % instruments
    figure(drums)
    subplot(2,2, maxlim)
    plot(angSep, min(SIRdrums), angSep, max(SIRdrums), angSep, ...
        mean(SIRdrums, 'omitnan'), angSep, zeros(size(angSep)))
    title([num2str(reverb{maxlim}) ' s reverb'])
    ylabel('SIR (dB)')
    xlabel('Degrees between sources')
    xlim([0 180])
    ylim([-25 60])
    
    figure(vocals)
    subplot(2,2, maxlim)
    plot(angSep, min(SIRvocals), angSep, max(SIRvocals), angSep, ...
        mean(SIRvocals, 'omitnan'), angSep, zeros(size(angSep)))
    title([num2str(reverb{maxlim}) ' s reverb'])
    ylabel('SIR (dB)')
    xlabel('Degrees between sources')
    xlim([0 180])
    ylim([-25 60])
end

figure(drums)
sgtitle('Drums SIR performance: min, mean, and max')

figure(vocals)
sgtitle('Vocals SIR performance: min, mean, and max')

