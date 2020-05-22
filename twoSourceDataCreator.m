%% Data creator
% Generates parameters for data, calls createData, saves data

azim1 = 0; % First source always at same position
azim2_master = 0:10:180; % possible positions for second source
maxlim_master = [0.01, 0.2, 0.4, 0.7];
workDir = '/home/hhasti/Documents/Research/Data/anechoicData/';
saveDir = '/home/hhasti/Documents/Research/Data/simData/';
saveDirWav = '/home/hhasti/Documents/Research/Data/simWavs/';
songFolder = dir(workDir);

for azim2=azim2_master
   for maxlim=maxlim_master
       for songIdx = 3:12
           
           song = [workDir songFolder(songIdx).name];
           [drums, fs] = audioread([song '/drums.wav']);
           [vocals, fs] = audioread([song '/vocals.wav']);
           src_sigs = [drums, vocals];
           azim = deg2rad([azim1, azim2]);
           createData
           
           saveName = ['azim_' num2str(azim2) '_rev_' num2str(maxlim*10e3) '_song_' ...
               num2str(songIdx-2)];
           
           save([saveDir saveName '.mat'], 'realDOA', 'sh_sigs', 'src', 'rec');
           
           audiowrite([saveDirWav saveName '.wav'], sh_sigs/max(max(abs(sh_sigs))),fs)
           
       end
   end
end
   
