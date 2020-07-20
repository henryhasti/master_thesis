%% Compares time effectiveness of all methods with real time factor
% RTF = (audio length)/(computation time)
estimateDir = 'results/'; %HOA
fs = 44100; %HOA
maxlim_master = [100, 2000, 4000, 7000];
%master = zeros(4, 5); % 4 reverbs, 3 sep methods + 2 DOA methods
for maxlim = 2:4
    
    file = ['azim_0_rev_' num2str(maxlim_master(maxlim)) '_song_1'];
    load([file '.mat']);
    
    %% Ambisonic domain separation
    mixture_wavname = ['/home/hhasti/Documents/Research/Data/simWavs/' file '.wav'];
    
    tic
    sepInHOA;
    sepHOATime = toc;
    
    %% NMF separation
    
    filename = [file '.wav'];
    tic
    NMFsepDrums;
    NMFtime = toc;
    
    %% Spatial filtering
    tic
    beam_sigs = beamforming(realDOA, sh_sigs, [.775, .4, .4, .4]); % Do beamforming
    SFtime = toc;
    
    %% MUSIC DOA
    tic
    deleteMe = MUSICDOAest(sh_sigs, 2);
    MUSICtime = toc;
    
    %% Own DOA estimation
    tic
    fs = 44100;
    hop = 0.01;
    noiseFloor = 0.15; % pct of highest peak that lower peaks can be
    minSep = 0.1; % radians. Peaks must be at least this far apart
    peakFs = 1/hop;
    nsrc = 2;
    
    [I, Omega, E, psi, t, w] = dirAC_calculation(sh_sigs, fs);
    
    % Ranking diffuseness
    psiSum = sum(sum(psi));
    thresh = 0.2 + psiSum/219350;
    
    % Get angle distributions
    [phi,theta,phiMask,thetaMask]=diffuseMasking(psi,Omega,hop,thresh,w);
    
    % Get azimuth DOAs
    DOAaz = peakPick(phi, nsrc, minSep, peakFs);
    
    DOA = matchAzEl(hop, phiMask, thetaMask, DOAaz);
    
    DOAtime = toc;
    
    master(maxlim, :) = [sepHOATime, NMFtime, SFtime, MUSICtime, DOAtime];
    
    
end

%% Plot results - Turns out pretty bad. Use table below instead
if false
for idx = 1:5
    
   plot(maxlim_master, master(:,idx))
   hold on
    
end
xlabel('Reverberation time (seconds)')
ylabel('5-s clip rocessing time (seconds)')
legend('HOA', 'NMF', 'Spatial', 'MUSIC', 'Intensity')
title('Computation time method comparison')

end

%% Table of results
% Table to be copied/pasted into latex

load realTimeResults.mat

RTF = master ./5;
RTFave = mean(RTF);

str = '\hline';
meth{1} = 'Ambisonic domain';
meth{2} = 'NMF';
meth{3} = 'Spatial';
meth{4} = 'MUSIC';
meth{5} = 'Intensity';

for idx = 1:5
    
    str = [str ' ' meth{idx} ' & ' num2str(RTFave(idx)) ' ' '\hline'];
    
end




