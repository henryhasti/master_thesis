function [SDR,SIR,SAR,perm] = eval_caller(estimateDir, src_wav, src, rec)

% Prepares audio to be sent to bss_eval/bss_eval_sources
% estimateDir = directory name that contains 1 wav file for each source
%   estimate and nothing else. The wav file can be made of many tracks;
%   these will be summed to mono.
% src_wav = structure containing the locations of the anechoic tracks;
%   e.g. src_wav(1).track = 'anechoicData/002-ANiMAL - Rockshow/bass.wav'
% src = the matrix containing the coordinates of each source, as created by
%   createData
% rec = the vector containing the receiver coordinates, as created by
%   createData

% SDR = source to distortion ratio
% SIR = source to interference ratio
% SAR = source to artifact ratio
% perm = which estimate source goes with which original source

% Calls function downloaded from http://bass-db.gforge.inria.fr/bss_eval/

% Calculate time delay from source to receiver
d = sqrt(sum((src(1, :)-rec).^2, 2)); % distance of each source to receiver (must be equal)

c = 343; % m/s speed of sound

% Put source estimates into matrix for evaluation
fileList = dir(estimateDir);
for idx = 3:length(fileList) % ignore . and .. directories
   [audio, fs] = audioread(fileList(idx).name); % load audio
   audio = sum(audio, 2); % To mono (if coming from sepHOA)
   
   if ~exist('se', 'var') % source estimate
       se = zeros(0);
   end
   se = [se audio]; % add this source estimate to se matrix
end

sampDel = round(d/c*fs); % number of samples later signals are expected

se = circshift(se, -sampDel); % start signal when mic first excited

[rowSE, ~] = size(se);


for idx = 1:length(src_wav)
   [audio, fs] = audioread(src_wav(idx).track); % load audio
   audio = sum(audio, 2); % To mono (if coming from sepHOA)
   
   if ~exist('s', 'var') % source estimate
       s = zeros(0);
   end
   s = [s audio]; % add this anechoic source to s matrix
end

[rowS, colS] = size(s);
s = vertcat(s, zeros(rowSE-rowS, colS)); %zero pad original signal

% Function from http://bass-db.gforge.inria.fr/bss_eval/
[SDR,SIR,SAR,perm]=bss_eval_sources(se',s');

end