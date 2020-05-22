%% Spatial filtering
% Own implementation using only DirAC parameters and spatial beamforming

if ~exist('sh_sigs', 'var')
    [sh_sigs, fs] = audioread(currentData);
end

% Calculate DirAC parameters
[I, Omega, E, psi, t, w] = dirAC_calculation(sh_sigs, fs);

% Get angle distributions
hop = 0.01;
thresh = 0.7;
[phi, theta, phiMask, thetaMask] = diffuseMasking(psi, Omega, hop, thresh, w);

% Get azimuth DOAs
noiseFloor = 0.15; % pct of highest peak that lower peaks can be
minSep = 0.5; % radians. Peaks must be at least this far apart
peakFs = 1/hop; % resolution of angle bins
DOAaz = peakPick(phi, noiseFloor, minSep, peakFs);

% Get complete DOA pairs (azimuth, elevation)
DOA = matchAzEl(hop, phiMask, thetaMask, DOAaz);

% Beamform
weights = [0.775, 0.4, 0.4, 0.4]; % To implement corrective gains
beam_sigs = beamforming(realDOA, sh_sigs);

% Save separated signals
outPath = '/home/hhasti/Documents/Research/results/';

for idx = 1:length(beam_sigs)
    audiowrite([outPath 'EstimatedSource_' num2str(idx) '.wav'], ...
        beam_sigs(idx).summed/max(abs(beam_sigs(idx).summed)),fs)
end

if false
    %% Listen to results (only if run separately)
    source = 2;
    [audio, fs] = audioread(['EstimatedSource_' num2str(source) '.wav']);
    
    soundsc(audio, fs)
    
end