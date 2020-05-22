%% Test selected song dataset
% Check length of all songs
% Check that all parts are present
% Conclusion: Good to go. Songs are all the appropriate length and seem to
% sample representative parts of the songs (all 4 mix components are
% present)

workDir = '/home/hhasti/Documents/Research/Data/anechoicData/';
fileList = dir(workDir);

fileList = fileList(3:end);

song2play = 10; % Vary between 1 and 10

[bass, fs] = audioread([workDir fileList(song2play).name '/bass.wav']);
[drums, fs] = audioread([workDir fileList(song2play).name '/drums.wav']);
[other, fs] = audioread([workDir fileList(song2play).name '/other.wav']);
[vocals, fs] = audioread([workDir fileList(song2play).name '/vocals.wav']);

soundsc(bass+drums+other+vocals, fs)