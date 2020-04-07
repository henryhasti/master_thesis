%% Test out DOA calculation

% Run with random levels of RT60/maxlim, diffuseness thresholds, source
% positions

%% Prepare audio

if ~exist('bass', 'var') || ~exist('drums', 'var')|| ...
        ~exist('other', 'var') || ~exist('vocals', 'var')
    % Load, convert to mono
    [bass, ~] = audioread('bass.wav');
    bass = sum(bass, 2)/2;
    [drums, ~] = audioread('drums.wav');
    drums = sum(drums, 2)/2;
    [other, ~] = audioread('other.wav');
    other = sum(other, 2)/2;
    [vocals, ~] = audioread('vocals.wav');
    vocals = sum(vocals, 2)/2;
end

src_sigs = [drums, other];

if true
    rt60 = 0.3; %rand(1)*1.5 + 0.01;
    maxlim = 0.5; %rt60;
    thresh = 0.8; %rand(1)*0.9 + 0.1;
    % Each source coordinate can be anywhere except within 0.5 meters of rec
    % position or wall

    %     src = zeros(1,3);
%     src(1) = rand(1)*4 + (randi(2)-1) * 5;
%     src(2) = rand(1)*4 + (randi(2)-1) * 5;
%     src(3) = rand(1)*4 + (randi(2)-1) * 5;

% Multiple sources, same plane. This case behaves as expected
% src = [9, 5.5, 5;
%     5.5, 9, 5;
%     1, 5.5, 5;
%     5.5, 1, 5];

% Multiple sources, constant phi, changing theta. Behaves as expected
% src = [5.5,5.5,9;
%     8,8,7;
%     8,8, 3;
%     5.5,5.5,1];

% New test case: using matchAzEl
% Matching works (pretty well). Beamforming does not at all
% src = [9, 5.5, 9;
%     5.5, 9, 3;
%     1, 5.5, 4;
%     5.5, 1, 2];

% RETURN TO THIS TEST
% src = [1,1,1;
%     9,5,9;
%     1,9,4];

src = [9, 4.5, 5;
    5.5, 9, 5];

    master(PPEidx).rt60 = rt60;
    master(PPEidx).thresh = thresh;
    master(PPEidx).src = src;
    
    dirAC_calc_printout;
    diffuseMasking;

    %%
    % angleVec, noiseFloor, minSep, peakFs
    noiseFloor = 0.3; % pct of highest peak that lower peaks can be
    minSep = 0.5; % radians. Peaks must be at least this far apart
    peakFs = 1/hop; % resolution of angle bins
    DOAaz = peakPick(phi, noiseFloor, minSep, peakFs);
    
    % Column vector pairs of az, el (estimates)
    DOA = matchAzEl(hop, phiMask, thetaMask, DOAaz);
    
    master(PPEidx).calcDOA = DOA;
    
end