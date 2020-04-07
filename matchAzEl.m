function correlatedAngles = matchAzEl(hop, phiMask, thetaMask, phiEst)

% Correlated angles= azimuth/elevation column vectors for each estimated 
%   source
% hop is the angular sampling rate (rad/sample)
% phiMask and thetaMask are the masked angle spectrograms
% phiEst and thetaEst are the estimated angles of where sources are
%   *The way I'm planning to do this means there's no need to peakpick
%   theta

%% Correlate phi with theta
% Current output from peakPick: angular locations in terms of phi and
% theta, but not angles of individual sources. Correlate them

% Assume more likely that phis are distinct than that theta are (most
% instruments are probably at a comparable elevation)

% Let's go back to our masked angle spectrograms and look for the k-n bins
% that clearly correspond to a given phi and find which theta they most
% likely go with


 correlatedAngles = vertcat(phiEst, zeros(1,length(phiEst)));
for idx = 1:length(phiEst) % match each phi with its theta
    
    thetaMaskTmp = thetaMask;
    phi = phiEst(idx); % azimuth angle being checked
    thetaMaskTmp(phiMask < phi) = nan; 
    thetaMaskTmp(phiMask > phi + hop) = nan;
       
    thetaDist = genAngleStats(hop, thetaMaskTmp, pi/2);
    
    thetaDist(2,:) = smooth(smooth(smooth(thetaDist(2,:))));
    
    theta = peakPick(thetaDist, -0.3, 0.5, 1/hop);
    
    correlatedAngles(2,idx) = theta;
    
end
end