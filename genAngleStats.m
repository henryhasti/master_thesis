function angleVec = genAngleStats(hop, spec, maxAngle, w)
% Function calculates distribution of angles in spectrogram
% Hop = angular sampling rate (rad/sample)
% Spec = spectrogram to search for angle values
% maxAngle = maximum angle expected in distribution (assumes symmetric)
% w (optional) = frequency scale of spectrogram. If passed in as non-nan 
%    value, function will weight angle bins using the mel-scale. Initial
%    testing implies this allows bass tracks to be more easily identified
% angleVec = row vector: angle bins, number of points belonging to each
%   bin. Angles are always mapped to the next LOWEST angle bin

% Only weight according to mel scale if frequencies are available
if nargin < 4
    melWeight = false;
else
    if length(w) == 1 && isnan(w)
        melWeight = false;
    else
        melWeight = true;
    end
end
angleVec = -maxAngle:hop:maxAngle;
angleVec = [angleVec (angleVec(end) + hop)];

% Angle; number of DOAs at angle
angleVec = vertcat(angleVec, zeros(1, length(angleVec)));

if melWeight == true
    % Scale frequencies by mel scale
    wDif = f2mel(w) - circshift(f2mel(w), 1);
    wDif(1) = 35; % Approximation
end

for idx = 1:length(spec(:,1)) % w (frequencies)
    for jdx = 1:length(spec(1,:))
        
        angTemp = spec(idx, jdx); % angle value
        if isnan(angTemp)
            continue
        end
        angBin = ceil((angTemp + maxAngle)/hop) + 1; % nearest sampled angle
        
        % Add angle to that angle bin, weighting if requested
        if melWeight == false
            angleVec(2, angBin) = angleVec(2, angBin) + 1;
        else
            angleVec(2, angBin) = angleVec(2, angBin) + wDif(idx)^4;
        end
    end
end