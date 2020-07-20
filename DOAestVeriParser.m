%% DOA estimator verification master parser
% Parses data in master to be useful

%% Standard error calculator
% Great circle distance between calcDOA and realDOA is the error
%clear
all = figure;
roundNum = 3;
hop = 2*0.01;
load('DOAestVerifyData.mat');


%load(['DOAestVerifyData_round' num2str(roundNum) '.mat']);

DOAerrormax = zeros(4, 19, 10);
DOAerrormin = zeros(4, 19, 10);

for maxlim = 1:4
    for angSep = 1:19
        for songIdx = 1:10
            calcDOA = master(angSep, maxlim, songIdx).DOA;
            realDOA = master(angSep, maxlim, songIdx).realDOA;
            
            arclen = zeros(2,2);
            for idx = 1:2
                for jdx = 1:2
                    
                    arclen(idx, jdx) = greatCircleDistance(calcDOA(2, idx), ...
                        calcDOA(1, idx), realDOA(2, jdx), realDOA(1, jdx), 1);
                    %This function downloaded from
                    %https://www.mathworks.com/matlabcentral/fileexchange/
                    %23026-compute-the-great-circle-distance-between-two-points
                    
                end
            end
            
            if arclen(1,1)+arclen(2,2) < arclen(1,2)+arclen(2,1)
                if arclen(1,1) > pi-hop && arclen(1,1) < pi+hop
                    arclen180(1,1) = 0;
                end
                if arclen(2,2) > pi-hop && arclen(2,2) < pi+hop
                    arclen180(2,2) = 0;
                end
                DOAerrormax(maxlim, angSep, songIdx) = max(arclen(1,1), arclen(2,2));
                DOAerrormin(maxlim, angSep, songIdx) = min(arclen(1,1), arclen(2,2));
            else
                if arclen(1,2) > pi-hop && arclen(1,2) < pi+hop
                    arclen180(1,2) = 0;
                end
                if arclen(2,1) > pi-hop && arclen(2,1) < pi+hop
                    arclen180(2,1) = 0;
                end
                DOAerrormax(maxlim, angSep, songIdx) = max(arclen(1,2), arclen(2,1));
                DOAerrormin(maxlim, angSep, songIdx) = min(arclen(1,2), arclen(2,1));
            end
            
        end
        
    end
end

%% Graphically display
reverb{1} = 0.01;
reverb{2} = 0.2;
reverb{3} = 0.4;
reverb{4} = 0.7;

DOAerror = DOAerrormax + DOAerrormin; % total error at configuration
angles = 0:10:180;

figure(all)
for idx = 1:4
    
    DOAerr = rad2deg(squeeze(DOAerror(idx,:,:)))';
    %DOAerrMUS = rad2deg(squeeze(DOAerrMUSIC(idx,:,:)))';
    
    hold on
    subplot(2,2,idx)
    plot(angles, mean(DOAerr)-std(DOAerr), 'r', angles, ...
        mean(DOAerr)+std(DOAerr), 'r', angles, mean(DOAerr), 'k')
    %meanVal180 = mean(squeeze(DOAerrormin(idx,:,:)), 2, 'omitnan');
    %plot(0:10:180, rad2deg(meanVal180(1:end)))
    title([num2str(reverb{idx}) ' s reverb time'])
    xlabel('Degrees btwn sources')
    ylabel('Average error (degrees)')
    ylim([-50 200])
%     if idx == 1
%         legend('Parametric', 'MUSIC', 'Location', 'northwest')
%     else
%         legend('Parametric', 'MUSIC')
%     end
    
end

sgtitle('DOA error average and standard deviation')

if false
%% Graphically represent data/error (obsolete)
% 4 plots, one for each reverb
% Average across songs
% Plot all DOAs that appear as function of angular separation
clear
roundNum = 3;
load(['DOAestVerifyData_round' num2str(roundNum) '.mat']);
reverb{1} = 0.01;
reverb{2} = 0.2;
reverb{3} = 0.4;
reverb{4} = 0.7;
figure
for maxlim = 1:4
    subplot(2,2,maxlim)
    realDOAs = zeros(19, 40);
    DOActr = ones(1,19); % Tracks how many DOAs were found for each angSep
    for angSep = 1:19
        for songIdx = 1:10
            realDOA = master(angSep, maxlim, songIdx).DOA;
            [~, numDOA] = size(realDOA);
            for idx = 1:numDOA
                realDOAs(angSep, DOActr(angSep)) = realDOA(1, idx);
                DOActr(angSep) = DOActr(angSep) + 1;
            end
        end
    end
    
    for idx = 1:max(DOActr)-1
        plot(deg2rad(0:18)*10, realDOAs(:, idx), '.')
        hold on
    end
    plot(deg2rad(0:18)*10, zeros(19,1), deg2rad(0:18)*10, deg2rad(0:18)*10)
    
    title(['Reverb time ' num2str(reverb{maxlim})])
    xlabel('Angular separation between sources (rad)')
    ylabel('Estimated DOAs (rad)')
end






%% Calculate true and false negatives and positives

clearvars -except roundNum
load(['DOAestVerifyData_round' num2str(roundNum) '.mat']);
hop = 0.01;

fpos = zeros(19, 4); % false positives (calcDOA that don't get matched)
fneg = zeros(19,4); % false negatives (realDOA that don't get matched
tpos = zeros(19,4); % true positives (calc and real DOA match)

numPerf = zeros(19,4); % songs with both DOAs correct, no extra DOAs
numHalf = zeros(19,4); % Songs with at least one DOA correct, maybe extras
numFail = zeros(19,4); % songs with no DOA correct


for idx = 1:19 % all angles
    for jdx = 1:4 % all reverbs
        for kdx = 1:10 % all songs
            
            calcDOA = master(idx, jdx, kdx).DOA;
            realDOA = master(idx, jdx, kdx).realDOA;
            
            [~, numDOAcalc] = size(calcDOA);
            numDOAreal = 2; % From 2 sources
            
            % Pair as many actual to calculated as possible
            for ldx = 1:numDOAreal
                for mdx = 1:numDOAcalc
                    
                    % If azimuths match (within hop size)
                    if calcDOA(1, mdx) < realDOA(1, ldx) + hop && ...
                            calcDOA(1, mdx) > realDOA(1, ldx) - hop
                        % if elevations match
                        if calcDOA(2, mdx) > -hop && calcDOA(2, mdx) < hop
                            calcDOA(:,mdx) = nan;
                            realDOA(:, ldx) = nan;
                            % One more correct match
                            tpos(idx, jdx) = tpos(idx, jdx) + 1;
                        end
                    end
                end
            end
            
            % Eliminate DOA value that matched
            realDOA(:,isnan(realDOA(1,:))) = [];
            calcDOA(:,isnan(calcDOA(1,:))) = [];
            
            % calculate false negatives and positives
            [~, numDOAcalcNew] = size(calcDOA);
            [~, numDOArealNew] = size(realDOA);
            
            % Calculate false detections
            fpos(idx, jdx) = fpos(idx, jdx) + numDOAcalcNew;
            fneg(idx, jdx) = fneg(idx, jdx) + numDOArealNew;
            
            % Calculate how each individual song did
            if numDOAcalc ==2 && numDOAcalcNew == 0
                numPerf(idx, jdx) = numPerf(idx, jdx) + 1;
            elseif numDOAcalc == numDOAcalcNew
                numFail(idx, jdx) = numFail(idx, jdx) + 1;
            else
                numHalf(idx, jdx) = numHalf(idx, jdx) + 1;
            end
        end
    end
end

precision = tpos./(tpos + fpos);
recall = tpos./(tpos + fneg);
fmeasure = 2*precision.*recall./(precision + recall);

%% Plot F-measure
figure
for idx = 1:4
    
    plot(deg2rad(0:18)*10, fmeasure(:,idx))
    hold on
    
end
legend('0.01', '0.2', '0.4', '0.7')




%% Save

%save('DOAestVerifyData.mat', 'master', 'fneg', 'fpos', 'tpos')
end