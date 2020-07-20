%% Beamformer testing
% Tests spatial filtering approach, with variables all songs, all maxlims,
% all angle separations, and 3 beamformer shapes:
% Basic: [1, 1, 1, 1]
% MaxRE: [.775, .4, .4, .4]
% In-phase: [.5, .1, .1, .1]

% Outputs are signal to distortion, interference, and artifact ratios for
% every performance
% Uses oracle DOA and not estimated DOA

clear

%% Prepare song directories
fileList = dir('/home/hhasti/Documents/Research/Data/anechoicData');
for idx = 3:length(fileList) % ignore . and .. directories
    song_master(idx).title = fileList(idx).name;
end

%% Loop through, calculating beamformed signals and performance

estimateDir = 'results/'; % Where all signal estimates will be stored
anechoicDir = 'Data/anechoicData/'; % Where all 10 songs are
maxlim_master = [100, 2000, 4000, 7000];
fs = 44100;
% different weighting schemes: Basic, MaxRE, in-phase
weights(1).wt = [1,1,1,1];
weights(2).wt = [.775, .4, .4, .4]; %MaxRE works best
weights(3).wt = [.5, .1, .1, .1];

% Store ratio results
load spatFiltVerifyData4src.mat
% master(4, 4, 10).SDR = [];
% master(4, 4, 10).SIR = [];
% master(4, 4, 10).SAR = [];
% master(4, 4, 10).perm = [];
%%
tic
for song = 1:10 % song being evaluated
    
    % Clean, anechoic signals to be compared against
    songDir = song_master(song+2).title;
    src_wav(1).track = [anechoicDir songDir '/bass.wav'];
    src_wav(2).track = [anechoicDir songDir '/drums.wav'];
    src_wav(3).track = [anechoicDir songDir '/other.wav'];
    src_wav(4).track = [anechoicDir songDir '/vocals.wav'];
    
    for azcase = 1:4 % separation angle being evaluated
        
        for maxlim = maxlim_master % Reverb time being evaluated
            
            % Received SH signals to be separated
            matFile = ['azcase_' num2str(azcase) '_rev_' num2str(maxlim)...
                '_song_' num2str(song) '.mat'];
            load(matFile)
            
            for cardioid = 2 % Beamform pattern being evaluated (MaxRE is best)
                
                beamWeights = weights(cardioid).wt; % Weights to implement pattern
                beam_sigs = beamforming(realDOA, sh_sigs, beamWeights); % Do beamforming
                
                % Write to file
                for idx = 1:length(beam_sigs)
                    audiowrite([estimateDir 'EstimatedSource_' num2str(idx) '.wav'], ...
                        beam_sigs(idx).summed/max(abs(beam_sigs(idx).summed)),fs)
                end
                
                % Which reverberation time we have
                if maxlim == 100
                    maxlimCtr = 1;
                elseif maxlim == 2000
                    maxlimCtr = 2;
                elseif maxlim == 4000
                    maxlimCtr = 3;
                elseif maxlim == 7000
                    maxlimCtr = 4;
                end
                
                % Evaluate separation
                [SDR,SIR,SAR,perm] = eval_caller(estimateDir, src_wav, src, rec);
                master(azcase, maxlimCtr, song).SDR = SDR;
                master(azcase, maxlimCtr, song).SIR = SIR;
                master(azcase, maxlimCtr, song).SAR = SAR;
                master(azcase, maxlimCtr, song).perm = perm;
                
                % Clear old estimates
                %system('rm results/EstimatedSource_1.wav')
                %system('rm results/EstimatedSource_2.wav')
            end
        end
    end
    % Partway through save
    save('spatFiltVerifyData4src.mat', 'master')
    disp([num2str(song) ' is the song, the time is ' num2str(toc)])
end

save('spatFiltVerifyData4src.mat', 'master')
