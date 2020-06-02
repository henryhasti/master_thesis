%% 4 source Data creator
% Generates parameters for data, calls createData, saves data
clear

azim_master{1} = [-pi, -pi/2, 0, pi/2];
azim_master{2} = [-pi, -deg2rad(10), 0, pi/2];
azim_master{3} = [-deg2rad(20), -deg2rad(10), 0, pi/2];
azim_master{4} = [-deg2rad(30), -deg2rad(20), -deg2rad(10), 0];

maxlim_master = [0.01, 0.2, 0.4, 0.7];
workDir = '/home/hhasti/Documents/Research/Data/anechoicData/';
saveDir = '/home/hhasti/Documents/Research/Data/4srcSimData/';
saveDirWav = '/home/hhasti/Documents/Research/Data/4srcSimWavs/';
songFolder = dir(workDir);

tic
for songIdx = 3:12
    
    song = [workDir songFolder(songIdx).name];
    [bass, fs] = audioread([song '/bass.wav']);
    [drums, fs] = audioread([song '/drums.wav']);
    [other, fs] = audioread([song '/other.wav']);
    [vocals, fs] = audioread([song '/vocals.wav']);
    src_sigs = [bass, drums, other, vocals];
    
    for azidx=1:4
        for maxlim=maxlim_master
            
            azim = azim_master{azidx};
            createData
            
            saveName = ['azcase_' num2str(azidx) '_rev_' num2str(maxlim*10e3) '_song_' ...
                num2str(songIdx-2)];
            
            save([saveDir saveName '.mat'], 'realDOA', 'sh_sigs', 'src', 'rec');
            
            audiowrite([saveDirWav saveName '.wav'], sh_sigs/max(max(abs(sh_sigs))),fs)
            
        end
    end
    disp([num2str(songIdx) ' just finished. The time is ' num2str(toc)])
end

