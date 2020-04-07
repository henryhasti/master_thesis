%% Implement binary mask based on diffuseness threshold
global plots;
counter = 1;
if ~exist('thresh', 'var')
    thresh  = .6; % Max allowable diffuseness
end
% Bins with too much diffuseness cut out. Mask==1 is what is saved
mask = ones(m, n);
mask(psi > thresh) = nan;

% Values that do get cut out
revMask = ones(m,n); 
revMask(~isnan(mask)) = nan;

% Mask applied to diffuseness and DOA
psiMask = psi.*mask;
phiMask = Omega(1).angle.*mask;
phiRevMask = Omega(1).angle.*revMask;
thetaMask = Omega(2).angle.*mask;
thetaRevMask = Omega(2).angle.*revMask;

%% Angular statistics
% Plot energy as a function of azimuth and elevation angles

hop = 0.01; % "sampling frequency" of angles
phi = -pi:hop:pi;
phi = [phi (phi(end) + hop)];
theta = -pi/2:hop:pi/2;
theta = [theta (theta(end) + hop)];

% Angle; number of DOAs at angle; number of elements eliminated by mask
phi = vertcat(phi, zeros(1, length(phi)), zeros(1, length(phi)));
theta = vertcat(theta, zeros(1, length(theta)), zeros(1, length(theta)));

% Loop through every bin of elev and azim angles
for idx = 1:length(w)
    for jdx = 1:length(t)
        % Process DOAs that mask cuts out
        if isnan(mask(idx, jdx))
            phiTemp = phiRevMask(idx, jdx); % angle value
            angBin = ceil((phiTemp + pi)/hop) + 1; % nearest sampled angle
            phi(3, angBin) = phi(3, angBin) + 1; % Add angle to that angle
            
            thetaTemp = thetaRevMask(idx, jdx);
            angBin = ceil((thetaTemp + pi/2)/hop) + 1;
            theta(3, angBin) = theta(3, angBin) + 1;
        else
            % Process DOAs that mask leaves in place
            phiTemp = phiMask(idx, jdx); 
            angBin = ceil((phiTemp + pi)/hop) + 1;
            phi(2, angBin) = phi(2, angBin) + 1;
            
            thetaTemp = thetaMask(idx, jdx); 
            angBin = ceil((thetaTemp + pi/2)/hop) + 1;
            theta(2, angBin) = theta(2, angBin) + 1;
        end
    end
end


if plots
    %% Plot it all
    figure
    subplot(2, 2, counter)
    plot(theta(1,:), theta(2,:), theta(1,:), theta(3,:))
    title(['Elevation: diffuseness ' num2str(thresh)])
    legend('Saved', 'masked')
    
    subplot(2, 2, counter + 2)
    polarplot(theta(1,:), theta(2,:), theta(1,:), theta(3,:))
    title(['Elevation: diffuseness ' num2str(thresh)])
    legend('Saved', 'masked')
    
    counter = counter + 1;
    
    subplot(2, 2, counter)
    plot(phi(1,:), phi(2,:), phi(1,:), phi(3,:))
    title(['Azimuth: diffuseness ' num2str(thresh)])
    legend('Saved', 'masked')
    
    subplot(2, 2, counter + 2)
    polarplot(phi(1,:), phi(2,:), phi(1,:), phi(3,:))
    title(['Azimuth: diffuseness ' num2str(thresh)])
    legend('Saved', 'masked')
end

%%
if plots
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