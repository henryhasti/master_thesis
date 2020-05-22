%% Data creation
% Given input folder selects 10 random songs, and shortens them to 5 random
% seconds, storing them in a new folder
% Data is taken from the test subset of the mixing secrets dataset
% https://sigsep.github.io/datasets/dsd100.html
% If the target folder (anechoicData) already has tracks in it, this script
% will simply add to those

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
fileList = dir(workDir);

for idx = 3:length(fileList)
    
    partsList = dir([workDir fileList(idx).name]); 
    
    [bass, fs] = audioread([workDir fileList(idx).name '/' partsList(3).name]);
    [drums, fs] = audioread([workDir fileList(idx).name '/' partsList(4).name]);
    [other, fs] = audioread([workDir fileList(idx).name '/' partsList(5).name]);
    [vocals, fs] = audioread([workDir fileList(idx).name '/' partsList(6).name]);
    
    songLength = length(bass);
    
    % Select random 5-second sample of song
    startPoint = randi(songLength - 5*fs); 
    endPoint = startPoint + 5*fs;
    
    % Re-write only shortened segment to wav file
    audiowrite([workDir fileList(idx).name '/' partsList(3).name], bass(startPoint:endPoint), fs);
    audiowrite([workDir fileList(idx).name '/' partsList(4).name], drums(startPoint:endPoint), fs);
    audiowrite([workDir fileList(idx).name '/' partsList(5).name], other(startPoint:endPoint), fs);
    audiowrite([workDir fileList(idx).name '/' partsList(6).name], vocals(startPoint:endPoint), fs);
    
end



