%% DOA estimator verification master parser
% Parses data in master to be useful

%% Start with SIR (but a simple find and replace to work with SIR or SIR)
% master is stored as (angle, reverb, song, beamformer).SIR, SIR, SIR, perm
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
    
    % Store SIRs for drums and vocal estimates, for every angle and for
    % every song
    SIRbass = zeros(10, 4);
    SIRdrums = zeros(10, 4);
    SIRother = zeros(10,4);
    SIRvocals = zeros(10, 4);
    
    
    for maxlim = 1:4
        
        for songIdx = 1:10
            
            SIRbass(songIdx, maxlim) = master(azIdx, maxlim, songIdx).SIR(1);
            SIRdrums(songIdx, maxlim) = master(azIdx, maxlim, songIdx).SIR(2);
            SIRother(songIdx, maxlim) = master(azIdx, maxlim, songIdx).SIR(3);
            SIRvocals(songIdx, maxlim) = master(azIdx, maxlim, songIdx).SIR(4);
            
        end
    end
    % Plot max, min, and average across the 10 songs, for all
    % instruments
    figure(bass)
    subplot(2, 2, azIdx)
    plot(reverb_master, min(SIRbass), 'ok', reverb_master, max(SIRbass), 'ok', reverb_master, mean(SIRbass, 'omitnan'), 'ok', reverb_master, zeros(size(maxlim)))
    title(['Room setup ' num2str(azIdx)])
    ylabel('SIR (dB)')
    xlabel('Reverb times (s)')
    sgtitle('Bass')
    
    figure(drums)
    subplot(2, 2, azIdx)
    plot(reverb_master, min(SIRdrums), 'ok', reverb_master, max(SIRdrums), 'ok', reverb_master, mean(SIRdrums, 'omitnan'), 'ok', reverb_master, zeros(size(maxlim)))
    title(['Room setup ' num2str(azIdx)])
    ylabel('SIR (dB)')
    xlabel('Reverb times (s)')
    sgtitle('Drums')
    
    figure(other)
    subplot(2, 2, azIdx)
    plot(reverb_master, min(SIRother), 'ok', reverb_master, max(SIRother), 'ok', reverb_master, mean(SIRother, 'omitnan'), 'ok', reverb_master, zeros(size(maxlim)))
    title(['Room setup ' num2str(azIdx)])
    ylabel('SIR (dB)')
    xlabel('Reverb times (s)')
    sgtitle('other')
    
    figure(vocals)
    subplot(2, 2, azIdx)
    plot(reverb_master, min(SIRvocals), 'ok', reverb_master, max(SIRvocals), 'ok', reverb_master, mean(SIRvocals, 'omitnan'), 'ok', reverb_master, zeros(size(maxlim)))
    title(['Room setup ' num2str(azIdx)])
    ylabel('SIR (dB)')
    xlabel('Reverb times (s)')
    sgtitle('vocals')
    
    
    
    
    
    
    
    
    
end
