%% DOA estimator verification master parser
% Parses data in master to be useful

%% Start with SAR (but a simple find and replace to work with SAR or SAR)
% master is stored as (angle, reverb, song, beamformer).SAR, SAR, SAR, perm
% Angle = 0 to 180º in 10º steps
% reverb = 0.01, 0.2, 0.4, 0.7 seconds
% songs from 1 to 10
% beamformer = basic, MaxRE, in-phase
load spatFiltVerifyData4src.mat

bass = figure;
drums = figure;
other = figure;
vocals=figure;
% We'll average across all songs for now
% fix reverb and beamformer type
azcase = 1:4;

reverb{1} = 0.01;
reverb{2} = 0.2;
reverb{3} = 0.4;
reverb{4} = 0.7;
reverb_master = [0.01, 0.2, 0.4, 0.7];

for azIdx = 1:4
    
    % Store SARs for drums and vocal estimates, for every angle and for
    % every song
    SARbass = zeros(10, 4);
    SARdrums = zeros(10, 4);
    SARother = zeros(10,4);
    SARvocals = zeros(10, 4);
    
    
    for maxlim = 1:4
        
        for songIdx = 1:10
            
            SARbass(songIdx, maxlim) = master(azIdx, maxlim, songIdx).SAR(1);
            SARdrums(songIdx, maxlim) = master(azIdx, maxlim, songIdx).SAR(2);
            SARother(songIdx, maxlim) = master(azIdx, maxlim, songIdx).SAR(3);
            SARvocals(songIdx, maxlim) = master(azIdx, maxlim, songIdx).SAR(4);
            
        end
    end
    % Plot max, min, and average across the 10 songs, for all
    % instruments
    figure(bass)
    subplot(2, 2, azIdx)
    plot(reverb_master, mean(SARbass)-std(SARbass), 'or', reverb_master, ...
        mean(SARbass)+std(SARbass), 'or', reverb_master, mean(SARbass), ...
        'ok', reverb_master, zeros(size(maxlim)))
    title(['Room setup ' num2str(azIdx)])
    ylabel('SAR (dB)')
    xlabel('Reverb times (s)')
    grid on
    grid minor
    ylim([-5 40]);
    sgtitle('Bass mean SAR and error')
    
    figure(drums)
    subplot(2, 2, azIdx)
    plot(reverb_master, mean(SARdrums)-std(SARdrums), 'or', reverb_master, ...
        mean(SARdrums)+std(SARdrums), 'or', reverb_master, mean(SARdrums), ...
        'ok', reverb_master, zeros(size(maxlim)))
    title(['Room setup ' num2str(azIdx)])
    ylabel('SAR (dB)')
    xlabel('Reverb times (s)')
    grid on
    grid minor
    ylim([-5 40]);
    sgtitle('Drums mean SAR and error')
    
    figure(other)
    subplot(2, 2, azIdx)
    plot(reverb_master, mean(SARother)-std(SARother), 'or', reverb_master, ...
        mean(SARother)+std(SARother), 'or', reverb_master, mean(SARother), ...
        'ok', reverb_master, zeros(size(maxlim)))
    title(['Room setup ' num2str(azIdx)])
    ylabel('SAR (dB)')
    xlabel('Reverb times (s)')
    grid on
    grid minor
    ylim([-5 40]);
    sgtitle('Other mean SAR and error')
    
    figure(vocals)
    subplot(2, 2, azIdx)
    plot(reverb_master, mean(SARvocals)-std(SARvocals), 'or', reverb_master, ...
        mean(SARvocals)+std(SARvocals), 'or', reverb_master, mean(SARvocals), ...
        'ok', reverb_master, zeros(size(maxlim)))
    title(['Room setup ' num2str(azIdx)])
    ylabel('SAR (dB)')
    xlabel('Reverb times (s)')
    grid on
    grid minor
    ylim([-5 40]);
    sgtitle('Vocals mean SAR and error')
    
    
    
end
