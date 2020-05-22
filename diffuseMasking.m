function [phi, theta, phiMask, thetaMask] = diffuseMasking(psi, Omega, hop, thresh, w)
%% Implement binary mask based on diffuseness threshold
% psi = spectrogram showing diffuseness values
% Omega = (1).angle is azimuth spectrogram, (2) is elevation
% hop = sampling frequency of angles
% w = scale of frequency axis. Optional. If passed in, a mel scale
% weighting will be used in calculating the angular histograms
% 
% phi = azimuth angle distribution
% theta = elevation angle distribution
% phi and thetaMask = spectrograms with only thresholded angles remaining
% Organized as row vectors with angles; number of spectrogram bins at angle
% Angles always get mapped to the next LOWEST angle bin
global plots;

if nargin < 5 % don't want to use mel weighting
    w = nan;
end

% Bins with too much diffuseness cut out. Mask==1 is what is saved
mask = ones(size(psi));
mask(psi > thresh) = nan;

% Mask applied to diffuseness and DOA
psiMask = psi.*mask;
phiMask = Omega(1).angle.*mask;
thetaMask = Omega(2).angle.*mask;

%% Angular statistics
% Track energy as a function of azimuth and elevation angles

% Calculate histograms for azimuth and elevation angles
phi = genAngleStats(hop, phiMask, pi, w);
theta = genAngleStats(hop, thetaMask, pi/2, w);

%% Make plots of everything
if plots
    counter = 1;
    %% Plot angular histograms
    figure
    subplot(2, 2, counter)
    plot(theta(1,:), theta(2,:))
    title(['Elevation: diffuseness ' num2str(thresh)])
    
    subplot(2, 2, counter + 2)
    polarplot(theta(1,:), theta(2,:))
    title(['Elevation: diffuseness ' num2str(thresh)])
    
    counter = counter + 1;
    
    subplot(2, 2, counter)
    plot(phi(1,:), phi(2,:))
    title(['Azimuth: diffuseness ' num2str(thresh)])
    
    subplot(2, 2, counter + 2)
    polarplot(phi(1,:), phi(2,:))
    title(['Azimuth: diffuseness ' num2str(thresh)])
    
    %% Plot masking results
end
if false
    %%
    figure
    plotSpec(psiMask, t, w, 'psi')
    colormap(vertcat([1,1,1], colormap)) %sets nan to white
    figure
    plotSpec(phiMask, t, w,'azimuth')
    colormap(vertcat([1,1,1], colormap))
    figure
    plotSpec(thetaMask, t, w, 'elevation')
    colormap(vertcat([1,1,1], colormap))
end
end