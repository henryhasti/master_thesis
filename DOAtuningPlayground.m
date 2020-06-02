%% DOA estimator verification
% Justifies accuracy of DOA estimator algorithm.
% Test cases:

%load DOAestVerifyData.mat

fs = 44100;
hop = 0.01;
thresh = 0.7;
noiseFloor = 0.05; % pct of highest peak that lower peaks can be
minSep = 0.1; % radians. Peaks must be at least this far apart
peakFs = 1/hop; % resolution of angle bins

angSep_master = 10;
maxlim_master = 100;
song_master = 9;
% Calculate error between actual and calculated DOA for every test case
for angSep = angSep_master
    for maxlim = maxlim_master
        for song = song_master
            
            matFile = ['azim_' num2str(angSep) '_rev_' num2str(maxlim)...
                '_song_' num2str(song) '.mat'];
            load(matFile)
            
            % Calculate DirAC parameters
            [I, Omega, E, psi, t, w] = dirAC_calculation(sh_sigs, fs);
            
            
            
            % Ranking diffuseness
            psiSum = sum(sum(psi));
            
            thresh = psiSum/219350;
            
            % Get angle distributions
            [phi, theta, phiMask, thetaMask] = diffuseMasking(psi, Omega, hop, thresh, w);
            
            % Get azimuth DOAs
            nsrc = 2;
            DOAaz = peakPick(phi, nsrc, minSep, peakFs);
            
            % Get complete DOA pairs (azimuth, elevation)
            DOA = matchAzEl(hop, phiMask, thetaMask, DOAaz);
                       
            figure
            clf
            plot(phi(1,:), smooth(phi(2,:)))
            hold on
            xlabel('Azimuth angle')
            ylabel('distribution')
            for idx = 1:length(DOA(1,:)) % Every azimuth DOA
                xline(DOA(1,idx));
            end
                        
            % Where noiseFloor appears
            angleVecSmooth = smooth(phi(2,:));
%             noise = min(angleVecSmooth(2:end-1)); % Lowest point in histogram: noise floor
%             peak = max(angleVecSmooth(2:end-1)); % highest point in histogram: most prominent DOA
%             minPeak = (peak-noise)*noiseFloor + noise; % peaks must get above noise floor
%             yline(minPeak);
            
        end
    end
end