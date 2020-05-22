function DOA = peakPick(angleVec, noiseFloor, minSep, peakFs)

% Pick peaks to determine where sounds come from
% angleVec is 2+ rows by many columns: 1st row is angle, 2nd row is
% energy values
% Peaks must be at least noiseFloor*max peak to be considered
% Returned peaks must be at least minSep (angle) apart
% fs is the angular sampling rate

% Finds peaks and locations:
% -smooths energy values
% -only considers DOAs at least minSep (degrees or radians) apart
% -only considers peaks above noiseFloor*max_energy

% Built in flag: received negative noiseFloor means this function is being
% called recursively, and should not check for peak at pi case

prom = 500; % prominence. Test value for now

if noiseFloor > 0
    angleVecSmooth = smooth(angleVec(2,:));
    
    noise = min(angleVecSmooth(2:end-1)); % Lowest point in histogram: noise floor
    peak = max(angleVecSmooth(2:end-1)); % highest point in histogram: most prominent DOA
    minPeak = (peak-noise)*noiseFloor + noise; % peaks must get above noise floor
    [~,locs, w, p] = findpeaks(angleVecSmooth, peakFs, 'MinPeakDistance', ...
        minSep, 'MinPeakHeight',minPeak, 'MinPeakProminence', prom); % locs in indices
    locsRad = angleVec(1,round(locs*peakFs)); % in radians
else
    [~,locs] = max(angleVec(2,:));
    locsRad = angleVec(1, locs);
end

%% Temporary debugging step (need permanent fix) 20 May
if isempty(locsRad)
    disp('No peaks found')
    DOA = [];
    return
end

if noiseFloor > 0 && angleVec(1,1) < -3.11 && ...
        (locsRad(1) < angleVec(1,1)+minSep/2 || locsRad(end) > angleVec(1,end) - minSep/2)
    % Noisefloor negative indicates this is the second time through the
    % fucntion. This case has already been checked.
    % If angleVec doesn't span from -pi:pi, it is the elevation angle
    % A location of a peak is within minSep of pi => Check if source is at pi
    
    energy = circshift(angleVec(2,2:end-1), round(minSep/2*peakFs)); % Shift minSep/2 to the right
    angles = angleVec(1,2:end-1) - minSep/2;
    energy(angles > angleVec(1,1)+minSep/2) = 0; % delete activity higher than minSep/2
    DOApi = peakPick(vertcat(angles, energy), -noiseFloor, minSep, peakFs);
    
    if DOApi < - pi
        DOApi = DOApi + 2*pi;
    elseif DOApi > pi
        DOApi = DOApi - 2*pi;
    end
    % Eliminate the fractured peak
    locsRad(locsRad < angleVec(1,1)+minSep/2) = [];
    locsRad(locsRad > angleVec(1,end) - minSep/2) = [];
    
    locsRad = [locsRad, DOApi];
end

DOA = locsRad;


end