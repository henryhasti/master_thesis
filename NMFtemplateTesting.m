%% Quick testing to determine best template size for NMF
% Azim doesn't matter, I suspect reverberation either
clear

results(10, 11).SDR = [];
results(10, 11).SIR = [];
results(10, 11).SAR = [];
results(10, 11).perm = [];

fileList = dir('/home/hhasti/Documents/Research/Data/anechoicData');
for idx = 3:length(fileList) % ignore . and .. directories
    song_master(idx).title = fileList(idx).name;
end
load azim_0_rev_100_song_1.mat
tic
for template = 95:5:145
    for songIdx = 1:10
        filename = ['azim_0_rev_100_song_' num2str(songIdx) '.wav'];
        numTemplateFrames = template;
        NMFseparation; % This puts files into 'results' folder
        
        src_wav(1).track = ['Data/anechoicData/' song_master(songIdx+2).title '/drums.wav'];
        src_wav(2).track = ['Data/anechoicData/' song_master(songIdx+2).title '/vocals.wav'];
        
        [SDR,SIR,SAR,perm] = eval_caller('results', src_wav, src, rec);
        clear src_wav
        
        results(songIdx, template/5-18).SDR = SDR;
        results(songIdx, template/5-18).SIR = SIR;
        results(songIdx, template/5-18).SAR = SAR;
        results(songIdx, template/5-18).perm = perm;
    end
    disp([num2str(template) ' is the template. The time is ' num2str(toc)]);
    save('NMFtempTestData.mat', 'results')
end

save('NMFtempTestData.mat', 'results')

%% Parse through results
load 'NMFtempTestData_backup95_5_145.mat'
templateSize = 95:5:145;
SIRmax = zeros(size(templateSize));
SIRmin = zeros(size(templateSize));
SIRavg = zeros(size(templateSize));

for tempIdx = 1:11
    songStats = [];
    for songIdx = 1:10
        for idx = 1:2 % pick up SIR values from both sources
            try
            songStats = [songStats results(songIdx, tempIdx).SIR(idx)];
            end
        end       
    end
    
    SIRmax(tempIdx) = max(songStats);
    SIRmin(tempIdx) = min(songStats);
    SIRavg(tempIdx) = mean(songStats);
    
end

plot(templateSize, SIRmax, templateSize, SIRmin, templateSize, SIRavg);
% It would seem any template size around 100 (preferably higher) works
% about equally in terms of SIR performace. 130 was the max for SIRavg. 105
% was the max for SIRmax. 100 was the max for SIRmin. 115 was the min for
% SIRavg

%%
[audio, fs] = audioread('EstimatedSource_1.wav');
soundsc(audio, fs)
