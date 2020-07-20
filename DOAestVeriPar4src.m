%% Standard error calculator
% Great circle distance between calcDOA and realDOA is the error
clear
load('MUSICDOAestVerifyData4src.mat');
%load(['DOAestVerifyData_round' num2str(roundNum) '.mat']);

DOAerror = zeros(4, 4, 10); % az_case, maxlim, song

for maxlim = 1:4
    for azCase = 1:4
        for songIdx = 1:10
            calcDOA = master(azCase, maxlim, songIdx).DOA;
            realDOA = master(azCase, maxlim, songIdx).realDOA;
            
            arclen = zeros(4,4); 
            for idx = 1:4
                for jdx = 1:4
                    
                    arclen(idx, jdx) = greatCircleDistance(calcDOA(2, idx), ...
                        calcDOA(1, idx), realDOA(2, jdx), realDOA(1, jdx), 1);
                    %This function downloaded from
                    %https://www.mathworks.com/matlabcentral/fileexchange/
                    %23026-compute-the-great-circle-distance-between-two-points
                    
                end
            end
            
            % match DOAs, record errors
            for idx = 1:4
                minArc = min(min(arclen));
                [row,col] = find(arclen == minArc);
                DOAerror(azCase, maxlim, songIdx) = DOAerror(azCase, maxlim, songIdx) + minArc;
                arclen(row,:) = [];
                arclen(:, col) = [];
            end 
        end
    end
end

%% Graphically display
figure
for idx = 1:4
    
    subplot(2,2,idx)
    meanVal = mean(squeeze(DOAerror(idx,:,:)), 2, 'omitnan');
    plot([0.01, 0.2, 0.4, 0.7], rad2deg(meanVal(1:end)))
    
    title([num2str(idx) ' azimuth case'])
    xlabel('Reverberation times (s)')
    ylabel('Average error (degreess)')
    
end