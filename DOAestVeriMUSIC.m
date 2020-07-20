%% DOA estimator verification - for MUSIC algorithm
% Justifies accuracy of MUSIC DOA estimator algorithm.
% Test cases:
% Modified for 4 sources
clear
% Set up storage variable.
% Angular separation in degrees: (idx-1)*10
% Maxlim for reverb: [0.01, 0.2, 0.4, 0.7] seconds
% Song number: 1 to 10 (corresponding to the testing subset alphabetically
master(4, 4, 10).DOA = []; % Estimated DOA %az case, maxlim, song
master(4, 4, 10).realDOA = []; % Actual DOA
nsrc = 4;

angSep_master = 0:10:180;
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
                        
            DOA = MUSICDOAest(sh_sigs, nsrc);
            
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
        save('MUSICDOAestVerifyData4src', 'master')
    end
    disp(['Completed loop ang_sep = ' num2str(azCase)])
    toc
end
save('MUSICDOAestVerifyData4src', 'master')