%% Angular statistics
% Plot energy as a function of azimuth and elevation angles

hop = 0.01;
phi = -pi:hop:pi;
phi = [phi (phi(end) + hop)];
theta = -pi/2:hop:pi/2;
theta = [theta (theta(end) + hop)];

phi = vertcat(phi, zeros(1, length(phi)));
theta = vertcat(theta, zeros(1, length(theta)));
% First row tracks angle, 2nd row tracks number found

for idx = 1:length(w)
    for jdx = 1:length(t)
        phiTemp = Omega(1).angle(idx, jdx);
        angBin = ceil((phiTemp + pi)/hop) + 1;
        phi(2, angBin) = phi(2, angBin) + 1;
        
        thetaTemp = Omega(2).angle(idx, jdx);
        angBin = ceil((thetaTemp + pi/2)/hop);
        theta(2, angBin) = theta(2, angBin) + 1;
        % Angle always gets mapped to the next highest angle bin
        
    end
end

%% Plot
figure
polarplot(theta(1,:), theta(2,:))
title('DOA histogram: elevation (theta)')
figure
polarplot(phi(1,:), phi(2,:))
title('DOA histogram: azimuth (phi)')



