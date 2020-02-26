%% Implement DirAC equations
c = 343; % speed of sound (m/s)
rho0 = 1.29; % density (kg/m³)
Z0 = c*rho0; % Characteristic impedance of the medium (kg/m²s)

% All calculations taken from Pulkki's DirAC theory
% Intensity (stored X, Y, Z after this step)
counter = 1; % X, Y, Z for intensity
if plots
    figure
end
for idx = [4,2,3] % Y, Z, X for B
    I(counter).intensity = -1/Z0 * real(B(idx).spec .* conj(B(1).spec));
    % Plot the intensity spectrograms
    if plots
        subplot(2,2,counter)
        plotSpec(I(counter).intensity, t, w, ...
            ['Intensity: Direction ' num2str(counter)])
    end
    counter = counter + 1;
    
end

% DOA = angle of intensity vector
[Omega(1).angle, Omega(2).angle] = cart2sph(-I(1).intensity, ...
    -I(2).intensity, -I(3).intensity);
% Energy
E = (abs(B(1).spec).^2 + abs(B(2).spec).^2 + abs(B(3).spec).^2 + ...
    abs(B(4).spec).^2)/2/Z0/c;

%% Diffuseness
numFrames = 4; % Number of frames to average over in each time direction

[m, n] = size(I(1).intensity); % All have same size

Eaveraged = zeros(m,n);
for idx = 1:3 % for X, Y, and Z
    I(idx).averaged = zeros(m,n);
    for shift = -numFrames:numFrames % Calculate average over this range
        addMatrix = circshift(I(idx).intensity, shift, 2);
        if shift < 0
            % Backfilled values don't have real-world meaning
            addMatrix(:, n+shift+1:n) = zeros(m, -shift);
        end
        if shift > 0
            addMatrix(:, 1:shift) = zeros(m, shift);
        end
        I(idx).averaged = I(idx).averaged + addMatrix;
        
        if idx == 1 % Only need to calculate Eavg once
            
            % Same logic as for intensity
            addMatrixE = circshift(E, shift, 2);
            if shift < 0
                addMatrixE(:, n+shift+1:n) = zeros(m, -shift);
            end
            if shift > 0
                addMatrixE(:, 1:shift) = zeros(m, shift);
            end
            Eaveraged = Eaveraged + addMatrixE;
        end
    end
    I(idx).averaged = I(idx).averaged/(2*numFrames + 1);
end
Eaveraged = Eaveraged/(2*numFrames + 1);

% Diffuseness
psi = sqrt(abs(I(1).averaged).^2 + abs(I(2).averaged).^2 + ...
    abs(I(3).averaged).^2);
psi = 1 - psi./Eaveraged/c;

%% Plot everything
if plots
    figure
    subplot(221)
    plotSpec(Omega(1).angle, t, w, 'Azimuth angle (radians)', plots)
    
    subplot(222)
    plotSpec(Omega(2).angle, t, w, 'Elevation angle (radians)', plots)
    
    subplot(223)
    plotSpec(log(E), t, w, 'Energy (dB)', plots)
    
    subplot(224)
    plotSpec(psi, t, w, 'Diffuseness', plots)
end
