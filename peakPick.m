function DOA = peakPick(angleVec, noiseFloor, minSep, peakFs)

% Pick peaks to determine where sounds come from
% angleVec is is 2+ rows by many columns: 1st row is angle, 2nd row is
% energy values
% Peaks must be at least noiseFloor*max peak to be considered
% Returned peaks must be at least minSep (angle) apart
% fs is the angular sampling rate

% Finds peaks and locations:
% -smooths energy values
% -only considers DOAs at least minSep (degrees or radians) apart
% -only considers peaks above noiseFloor*max_energy
angleVecSmooth = smooth(angleVec(2,:));

[pks,locs] = findpeaks(angleVecSmooth, peakFs, 'MinPeakDistance', ...
    minSep, 'MinPeakHeight',noiseFloor*max(angleVecSmooth));

locs = angleVec(1,round(locs*peakFs));

if numel(locs) ~= 1
    % Check if we have a peak at roughly 180º
    % Theory: rotate peak diagram, do same check as before
    energy = circshift(angleVec(2,2:end-1), round(peakFs)); % Shift fs to the right
    angles = angleVec(1, 2:end-1) - 1;
    DOA = peakPick(vertcat(angles, energy), noiseFloor, minSep, peakFs);
    
else
    DOA = locs;
end
% Keep within unit circle
if DOA < - pi
    DOA = DOA + 2*pi; 
elseif DOA > pi
    DOA = DOA - 2*pi;
end

end