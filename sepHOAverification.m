%% Beamformer testing
% Tests spatial filtering approach, with variables all songs, all maxlims,
% and all angle separations

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

% Store ratio results
master(4, 4, 10).SDR = []; % Az case, maxlim, song
master(4, 4, 10).SIR = [];
master(4, 4, 10).SAR = [];
master(4, 4, 10).perm = [];
%%
tic
for song = 1:10 % song being evaluated
    
    % Clean, anechoic signals to be compared against
    songDir = song_master(song+2).title;
    src_wav(1).track = [anechoicDir songDir '/bass.wav'];
    src_wav(2).track = [anechoicDir songDir '/drums.wav'];
    src_wav(3).track = [anechoicDir songDir '/other.wav'];
    src_wav(4).track = [anechoicDir songDir '/vocals.wav'];
    
    for azCase = 1:4 % separation angle being evaluated
        
        for maxlim = maxlim_master % Reverb time being evaluated
            
            % Received SH signals to be separated
            matFile = ['azcase_' num2str(azCase) '_rev_' num2str(maxlim)...
                '_song_' num2str(song) '.mat'];
            mixture_wavname = ['/home/hhasti/Documents/Research/Data/4srcSimWavs/azcase_' ...
                num2str(azCase) '_rev_' num2str(maxlim) '_song_' num2str(song) '.wav'];
            load(matFile)
            
            sepInHOA; % Performs computation, returns wavs to 'results'
            
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
            
            disp([num2str(song) ' is the song, the time is ' num2str(toc)])
            % Evaluate separation
            [SDR,SIR,SAR,perm] = eval_caller(estimateDir, src_wav, src, rec);
            master(azCase, maxlimCtr, song).SDR = SDR;
            master(azCase, maxlimCtr, song).SIR = SIR;
            master(azCase, maxlimCtr, song).SAR = SAR;
            master(azCase, maxlimCtr, song).perm = perm;
        end
    end
    % Partway through save
    save('sepHOAverifyData4src.mat', 'master')
end

save('sepHOAverifyData4src.mat', 'master')
