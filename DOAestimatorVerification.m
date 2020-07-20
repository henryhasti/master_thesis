%% DOA estimator verification
% Justifies accuracy of DOA estimator algorithm.
% Updated for 4 sources
% Test cases:
fs = 44100;
hop = 0.01;
thresh = 0.7;
noiseFloor = 0.15; % pct of highest peak that lower peaks can be
minSep = 0.1; % radians. Peaks must be at least this far apart
peakFs = 1/hop; % resolution of angle bins

% Set up storage variable.
% Angular separation in degrees: (idx-1)*10
% Maxlim for reverb: [0.01, 0.2, 0.4, 0.7] seconds
% Song number: 1 to 10 (corresponding to the testing subset alphabetically
master(4, 4, 10).DOA = []; % Estimated DOA
master(4, 4, 10).realDOA = []; % Actual DOA
nsrc = 4;

%angSep_master = 0:10:180;
maxlim_master = [100, 2000, 4000, 7000];
song_master = 1:10;
tic
% Calculate error between actual and calculated DOA for every test case
for azCase = 1:4 %angSep = angSep_master
    for maxlim = maxlim_master
        for song = song_master
            
            matFile = ['azcase_' num2str(azCase) '_rev_' num2str(maxlim)...
                '_song_' num2str(song) '.mat'];
            load(matFile)
            
            % Calculate DirAC parameters
            [I, Omega, E, psi, t, w] = dirAC_calculation(sh_sigs, fs);
            
            % Ranking diffuseness
            psiSum = sum(sum(psi));
            thresh = 0.2 + psiSum/219350;
            
            % Get angle distributions
            [phi,theta,phiMask,thetaMask]=diffuseMasking(psi,Omega,hop,thresh,w);
            
            % Get azimuth DOAs
            DOAaz = peakPick(phi, nsrc, minSep, peakFs);
            if isempty(DOAaz)
                disp(['Song ' num2str(song) ' reverb ' num2str(maxlim) ...
                    ' angSep ' num2str(angSep)])
            end
            
            % Get complete DOA pairs (azimuth, elevation)
            DOA = matchAzEl(hop, phiMask, thetaMask, DOAaz);
                        
            % Which reverberation time we have
            if maxlim == 100
                maxlimCtr = 1;
            elseif maxlim == 2000
                maxlimCtr = 2;
            elseif maxlim == 4000
                maxlimCtr = 3;
            elseif maxlim == 7000
                maxlimCtr = 4;
            end
            
            % Add values
            master(azCase, maxlimCtr, song).DOA = DOA;
            master(azCase, maxlimCtr, song).realDOA = realDOA;
            
        end
        save('DOAestVerifyData4src', 'master')
    end
    disp(['Completed loop ang_sep = ' num2str(azCase)])
    toc
end
save('DOAestVerifyData4src', 'master')