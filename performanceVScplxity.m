%% Creates scatter plot of performance vs complexity for the 5 methods

%% Parse through results from all three separation methods

load('sepHOAverifyData.mat')
sepHOA = master;
load('spatFiltVerifyData.mat') % But only use MaxRE performance
spatFilt = master;
load('NMFverifyData.mat')
NMF = master;

angSep = 0:10:180;

reverb{1} = 0.01;
reverb{2} = 0.2;
reverb{3} = 0.4;
reverb{4} = 0.7;

drumsHOASIR = zeros(4, 10,19);
drumsHOASAR = zeros(4, 10,19);

vocalsHOASIR = zeros(4, 10,19);
vocalsHOASAR = zeros(4, 10,19);

drumsSpatSIR = zeros(4, 10,19);
drumsSpatSAR = zeros(4, 10,19);

vocalsSpatSIR = zeros(4, 10,19);
vocalsSpatSAR = zeros(4, 10,19);

drumsNMFSIR = zeros(4, 10,19);
drumsNMFSAR = zeros(4, 10,19);

vocalsNMFSIR = zeros(4, 10,19);
vocalsNMFSAR = zeros(4, 10,19);

for maxlim=1:4
    
    for angleIdx = angSep/10+1
        
        for songIdx = 1:10
            
            drumsHOASIR(maxlim, songIdx, angleIdx) = sepHOA(angleIdx, maxlim, songIdx).SIR(1);
            vocalsHOASIR(maxlim, songIdx, angleIdx) = sepHOA(angleIdx, maxlim, songIdx).SIR(2);
            
            drumsSpatSIR(maxlim, songIdx, angleIdx) = spatFilt(angleIdx, maxlim, songIdx, 2).SIR(1);
            vocalsSpatSIR(maxlim, songIdx, angleIdx) = spatFilt(angleIdx, maxlim, songIdx, 2).SIR(2);
            
            drumsNMFSIR(maxlim, songIdx, angleIdx) = NMF(maxlim, songIdx).SIR(1);
            vocalsNMFSIR(maxlim, songIdx, angleIdx) = NMF(maxlim, songIdx).SIR(2);
            
            
            
            drumsHOASAR(maxlim, songIdx, angleIdx) = sepHOA(angleIdx, maxlim, songIdx).SAR(1);
            vocalsHOASAR(maxlim, songIdx, angleIdx) = sepHOA(angleIdx, maxlim, songIdx).SAR(2);
            
            drumsSpatSAR(maxlim, songIdx, angleIdx) = spatFilt(angleIdx, maxlim, songIdx, 2).SAR(1);
            vocalsSpatSAR(maxlim, songIdx, angleIdx) = spatFilt(angleIdx, maxlim, songIdx, 2).SAR(2);
            
            drumsNMFSAR(maxlim, songIdx, angleIdx) = NMF(maxlim, songIdx).SAR(1);
            vocalsNMFSAR(maxlim, songIdx, angleIdx) = NMF(maxlim, songIdx).SAR(2);
        end
    end
    
end

% Calculate extremes of values to scale axes
separationMax = max([max(max(max(drumsHOASIR))), max(max(max(drumsHOASAR))), ...
    max(max(max(vocalsHOASIR))), max(max(max(vocalsHOASAR))), ...
    max(max(max(drumsNMFSIR))), max(max(max(drumsNMFSAR))), ...
    max(max(max(vocalsNMFSIR))), max(max(max(vocalsNMFSAR))), ...
    max(max(max(drumsSpatSIR))), max(max(max(drumsSpatSAR))), ...
    max(max(max(vocalsSpatSIR))), max(max(max(vocalsSpatSAR)))]);

separationMin = min([min(min(min(drumsHOASIR))), min(min(min(drumsHOASAR))), ...
    min(min(min(vocalsHOASIR))), min(min(min(vocalsHOASAR))), ...
    min(min(min(drumsNMFSIR))), min(min(min(drumsNMFSAR))), ...
    min(min(min(vocalsNMFSIR))), min(min(min(vocalsNMFSAR))), ...
    min(min(min(drumsSpatSIR))), min(min(min(drumsSpatSAR))), ...
    min(min(min(vocalsSpatSIR))), min(min(min(vocalsSpatSAR)))]);

HOAmeanSIR = mean([mean(mean(mean(drumsHOASIR, 'omitnan'), 'omitnan'), 'omitnan'), mean(mean(mean(vocalsHOASIR, 'omitnan'), 'omitnan'), 'omitnan')]);
HOAmeanSAR = mean([mean(mean(mean(drumsHOASAR, 'omitnan'), 'omitnan'), 'omitnan'), mean(mean(mean(vocalsHOASAR, 'omitnan'), 'omitnan'), 'omitnan')]);

NMFmeanSIR = mean([mean(mean(mean(drumsNMFSIR))), mean(mean(mean(vocalsNMFSIR)))]);
NMFmeanSAR = mean([mean(mean(mean(drumsNMFSAR))), mean(mean(mean(vocalsNMFSAR)))]);

spatmeanSIR = mean([mean(mean(mean(drumsSpatSIR))), mean(mean(mean(vocalsSpatSIR)))]);
spatmeanSAR = mean([mean(mean(mean(drumsSpatSAR))), mean(mean(mean(vocalsSpatSAR)))]);

%% Parse through results from both DOA estimation methods

% First do parametric method
load('DOAestVerifyData.mat');


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
                DOAerrormax(maxlim, angSep, songIdx) = max(arclen(1,1), arclen(2,2));
                DOAerrormin(maxlim, angSep, songIdx) = min(arclen(1,1), arclen(2,2));
            else
                DOAerrormax(maxlim, angSep, songIdx) = max(arclen(1,2), arclen(2,1));
                DOAerrormin(maxlim, angSep, songIdx) = min(arclen(1,2), arclen(2,1));
            end
        end
    end
end

DOAmax = max(max(max(DOAerrormax)));
DOAmin = min(min(min(DOAerrormin)));

paramMean = mean([mean(mean(mean(DOAerrormax))), mean(mean(mean(mean(DOAerrormin))))]);

% Now do MUSIC method
load('MUSICDOAestVerifyData.mat');


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
                DOAerrormax(maxlim, angSep, songIdx) = max(arclen(1,1), arclen(2,2));
                DOAerrormin(maxlim, angSep, songIdx) = min(arclen(1,1), arclen(2,2));
            else
                DOAerrormax(maxlim, angSep, songIdx) = max(arclen(1,2), arclen(2,1));
                DOAerrormin(maxlim, angSep, songIdx) = min(arclen(1,2), arclen(2,1));
            end
        end
    end
end

MUSICDOAmax = max(max(max(DOAerrormax)));
MUSICDOAmin = min(min(min(DOAerrormin)));

DOAmax = max(DOAmax, MUSICDOAmax);
DOAmin = min(DOAmin, MUSICDOAmin);

MUSICMean = mean([mean(mean(mean(DOAerrormax))), mean(mean(mean(mean(DOAerrormin))))]);

%% Scale performance axis and plot

DOAscale = DOAmax - DOAmin;
DOAoffset = DOAmin/DOAscale; % scale first, then offset
sepScale = separationMax - separationMin;
sepOffset = -separationMin/sepScale; 
load realTimeResults.mat % for real time factor

SIRs = [HOAmeanSIR, NMFmeanSIR, spatmeanSIR];
SARs = [HOAmeanSAR, NMFmeanSAR, spatmeanSAR];
DOAs = [MUSICMean, paramMean];

scatter(RTFave(1:3), SIRs/sepScale+sepOffset, [], [[0; 0; 0], [1; 0; 0], [0; 0; 1]]', 'filled')
hold on
scatter(RTFave(1:3), SARs/sepScale+sepOffset, [], [[0; 0; 0], [1; 0; 0], [0; 0; 1]]', 'filled')
hold on 
scatter(RTFave(4:5), 1-(DOAs/DOAscale+DOAoffset), [], [[0;1;0], [0;0;1]]', 'filled')

% Label it
text(2, 0.22, ['NMF SAR ' num2str(NMFmeanSAR) ' dB'], 'Color', 'r')
text(2, 0.3, ['NMF SIR ' num2str(NMFmeanSIR) ' dB'], 'Color', 'r')
text(1.1, 0.34, ['Spatial SAR ' num2str(spatmeanSAR) ' dB'], 'Color', 'b')
text(1, 0.38, ['Spatial SIR ' num2str(spatmeanSIR) ' dB'], 'Color', 'b')
text(2.1, 0.79, ['MUSIC ' num2str(rad2deg(MUSICMean)) ' degrees'], 'Color', 'g')
text(1, 0.86, ['Parametric ' num2str(rad2deg(paramMean)) ' degrees'], 'Color', 'b')
text(24, 0.27, ['HOA SAR ' newline num2str(HOAmeanSAR) ' dB'], 'Color', 'k')
text(23, 0.43, ['HOA SIR ' newline num2str(HOAmeanSIR) ' dB'], 'Color', 'k')
grid on
grid minor

title('Algorithm performance vs computational complexity')
xlabel('Real time factor')
ylabel('Normalized performance score')








