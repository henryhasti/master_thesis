%% Angular statistics
% Plot energy as a function of azimuth and elevation angles

hop = 0.01;
phi = -pi:hop:pi;
phi = [phi (phi(end) + hop)];
theta = -pi/2:hop:pi/2;
theta = [theta (theta(end) + hop)];

phi = vertcat(phi, zeros(1, length(phi)), zeros(1, length(phi)));
theta = vertcat(theta, zeros(1, length(theta)), zeros(1, length(theta)));
% First row tracks angle, 2nd row tracks number found, 3rd tracks masked
% elements number found

for idx = 1:length(w)
    for jdx = 1:length(t)
        % Process phis
        if isnan(mask(idx, jdx))
            phiTemp = phiRevMask(idx, jdx);
            angBin = ceil((phiTemp + pi)/hop) + 1;
            phi(3, angBin) = phi(3, angBin) + 1;
            
            thetaTemp = thetaRevMask(idx, jdx);
            angBin = ceil((thetaTemp + pi/2)/hop) + 1;
            theta(3, angBin) = theta(3, angBin) + 1;
        else
            phiTemp = phiMask(idx, jdx); %Omega(1).angle(idx, jdx);
            angBin = ceil((phiTemp + pi)/hop) + 1;
            phi(2, angBin) = phi(2, angBin) + 1;
            
            thetaTemp = thetaMask(idx, jdx); %Omega(1).angle(idx, jdx);
            angBin = ceil((thetaTemp + pi/2)/hop) + 1;
            theta(2, angBin) = theta(2, angBin) + 1;
        end
       
                
%         thetaTemp = thetaMask(idx, jdx); %Omega(2).angle(idx, jdx);
%         angBin = ceil((thetaTemp + pi/2)/hop);
%         theta(2, angBin) = theta(2, angBin) + 1;
%         % Angle always gets mapped to the next highest angle bin
        
    end
end

%% Plot
% subplot(121)
% polarplot(theta(1,:), theta(2,:))
% title('DOA histogram: elevation (theta)')
% subplot(122)
% polarplot(phi(1,:), phi(2,:))
% title('DOA histogram: azimuth (phi)')



