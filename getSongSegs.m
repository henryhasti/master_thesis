%% Data creation
% Given input folder selects 10 random songs, and shortens them to 5 random
% seconds, storing them in a new folder
% Data is taken from the test subset of the mixing secrets dataset
% https://sigsep.github.io/datasets/dsd100.html
% If the target folder (anechoicData) already has tracks in it, this script
% will simply add to those

% Edited to update one track that was missing bass in the section

%% Select 10 random songs
% from 50 song Test subset. Move to anechoic data folder

randVec = [];
while length(randVec) < 10
    randNum = randi(50);
    if ~ismember(randNum, randVec)
        randVec = [randVec randNum];
    end
end

fileList = dir('/home/hhasti/Documents/Research/Data/Test/');

for idx = 1:length(randVec)
    
    startFile = ['/home/hhasti/Documents/Research/Data/Test/' fileList(randVec(idx)+2).name];
    command = ['cp -r ' char(39) startFile char(39) ' /home/hhasti/Documents/Research/Data/anechoicData'];
    system(command);
    
    %disp([num2str(randVec(idx)) ': ' fileList(randVec(idx)+2).name])
end

%% Shorten songs to just 5 second segments

addpath(genpath('/home/hhasti/Documents/Research/Data/anechoicData'))
workDir = '/home/hhasti/Documents/Research/Data/anechoicData/';
%fileList = dir(workDir);

%for idx = 3:length(fileList)
    
    %partsList = dir([workDir fileList(idx).name]); 
    partsList = '/home/hhasti/Documents/Research/Data/Test/013 - Drumtracks - Ghost Bitch';
    
    [bass, fs] = audioread([partsList '/bass.wav']);
    [drums, fs] = audioread([partsList '/drums.wav']);
    [other, fs] = audioread([partsList '/other.wav']);
    [vocals, fs] = audioread([partsList '/vocals.wav']);
    
    songLength = length(bass);
    
    % Select random 5-second sample of song
    startPoint = randi(songLength - 5*fs); 
    endPoint = startPoint + 5*fs;
    
    %%
    soundsc(vocals(startPoint:endPoint), fs);
    
    %% Re-write only shortened segment to wav file
    audiowrite([workDir '013 - Drumtracks - Ghost Bitch/bass.wav'], bass(startPoint:endPoint), fs);
    audiowrite([workDir '013 - Drumtracks - Ghost Bitch/drums.wav'], drums(startPoint:endPoint), fs);
    audiowrite([workDir '013 - Drumtracks - Ghost Bitch/other.wav'], other(startPoint:endPoint), fs);
    audiowrite([workDir '013 - Drumtracks - Ghost Bitch/vocals.wav'], vocals(startPoint:endPoint), fs);
    
%end



