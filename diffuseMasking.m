%% Implement binary mask based on diffuseness threshold
counter = 1;
if ~exist('thresh')
    thresh  = .6;%[.1 .2 .3] + .3; % Max allowable diffuseness
end
for binidx = thresh
    mask = ones(m, n);
    mask(psi > binidx) = nan;
    
    revMask = ones(m,n); % Values that do get cut out
    revMask(~isnan(mask)) = nan;
    
    
    psiMask = psi.*mask;
    phiMask = Omega(1).angle.*mask;
    phiRevMask = Omega(1).angle.*revMask;
    thetaMask = Omega(2).angle.*mask;
    thetaRevMask = Omega(2).angle.*revMask;
    angularStats;
    
    % Plot it all
    if plots
        figure
        subplot(2, 2, counter)
        plot(theta(1,:), theta(2,:), theta(1,:), theta(3,:))
        title(['Elevation: diffuseness ' num2str(binidx)])
        legend('Saved', 'masked')
        
        subplot(2, 2, counter + 2)
        polarplot(theta(1,:), theta(2,:), theta(1,:), theta(3,:))
        title(['Elevation: diffuseness ' num2str(binidx)])
        legend('Saved', 'masked')
        
        counter = counter + 1;
        
        subplot(2, 2, counter)
        plot(phi(1,:), phi(2,:), phi(1,:), phi(3,:))
        title(['Azimuth: diffuseness ' num2str(binidx)])
        legend('Saved', 'masked')
        
        subplot(2, 2, counter + 2)
        polarplot(phi(1,:), phi(2,:), phi(1,:), phi(3,:))
        title(['Azimuth: diffuseness ' num2str(binidx)])
        legend('Saved', 'masked')
    end
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