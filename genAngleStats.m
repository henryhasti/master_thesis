function angleVec = genAngleStats(hop, spec, maxAngle)
% Function calculates distribution of angles in spectrogram
% Hop = angular sampling rate (rad/sample)
% Spec = spectrogram to search for angle values
% maxAngle = maximum angle expected in distribution (assumes symmetric)
% angleVec = row vector: angle bins, number of points belonging to each
%   bin. Angles are always mapped to the next LOWEST angle bin

angleVec = -maxAngle:hop:maxAngle;
angleVec = [angleVec (angleVec(end) + hop)];

% Angle; number of DOAs at angle
angleVec = vertcat(angleVec, zeros(1, length(angleVec)));

for idx = 1:length(spec(:,1))
    for jdx = 1:length(spec(1,:))
        
            angTemp = spec(idx, jdx); % angle value
            if isnan(angTemp)
                continue
            end
            angBin = ceil((angTemp + maxAngle)/hop) + 1; % nearest sampled angle
            angleVec(2, angBin) = angleVec(2, angBin) + 1; % Add angle to that angle
    end
end