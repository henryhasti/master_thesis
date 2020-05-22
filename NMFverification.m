%% Prepare song directories
clear

fileList = dir('/home/hhasti/Documents/Research/Data/anechoicData');
for idx = 3:length(fileList) % ignore . and .. directories
    song_master(idx).title = fileList(idx).name;
end

%% Loop through, calculating beamformed signals and performance

estimateDir = 'results/'; % Where all signal estimates will be stored
anechoicDir = 'Data/anechoicData/'; % Where all 10 songs are
maxlim_master = [100, 2000, 4000, 7000];

% This will only get used for fs, src, and rec
matFile = 'azim_180_rev_100_song_1.mat';
load(matFile)

master(4, 10).SDR = [];
master(4, 10).SIR = [];
master(4, 10).SAR = [];
master(4, 10).perm = [];
tic
for songIdx = 1:10
    
    % Clean, anechoic signals to be compared against
    songDir = song_master(songIdx+2).title;
    src_wav(1).track = [anechoicDir songDir '/drums.wav'];
    src_wav(2).track = [anechoicDir songDir '/vocals.wav'];
    for maxlim = maxlim_master
        
        % wav file of combined signals (NMF script will use)
        filename = ['azim_180_rev_' num2str(maxlim) '_song_' num2str(songIdx) '.wav'];
        NMFsepDrums;
        
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
        master(maxlimCtr, songIdx).SDR = SDR;
        master(maxlimCtr, songIdx).SIR = SIR;
        master(maxlimCtr, songIdx).SAR = SAR;
        master(maxlimCtr, songIdx).perm =perm;
        
    end
    
    save('NMFverifyDataSepDrums.mat', 'master')
    disp([num2str(songIdx) ' is the song, the time is ' num2str(toc)])
end

save('NMFverifyDataSepDrums.mat', 'master')



