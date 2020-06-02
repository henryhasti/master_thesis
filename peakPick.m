function DOA = peakPick(angleVec, nsrc, minSep, peakFs)

% Pick peaks to determine where sounds come from
% angleVec is 2+ rows by many columns: 1st row is angle, 2nd row is
% energy values
% There are nsrc DOAs to return
% Returned peaks must be at least minSep (angle) apart
% fs is the angular sampling rate

% Finds peaks and locations:
% -smooths energy values
% -only considers DOAs at least minSep (degrees or radians) apart
% -only considers peaks above noiseFloor*max_energy

% Built in flag: received negative noiseFloor means this function is being
% called recursively, and should not check for peak at pi case

% Extend graph by double so that pi singularity doesn't matter, smooth
if angleVec(1, end) > 3.1 % only for azimuth, not elevation
    angleVec = [angleVec(:, 1:end-1) angleVec(:, 2: end-1)];
    angleVec(1, round(end/2)+1:end) = angleVec(1, round(end/2+1:end)) +2*pi;
end
angleVecSmooth = smooth(angleVec(2,:));

% Find candidate peaks (4*nsrc: double spectrogram + echo false positives)
[pks,locs] = findpeaks(angleVecSmooth, peakFs, 'MinPeakDistance', minSep); % locs in indices
locsRad = angleVec(1,round(locs*peakFs))+1/peakFs; % in radians

% [~, index] = sort(pks); % indices smallest to largest peaks
% pks(index(1:end-nsrc*4)) = [];
% locsRad(index(1:end-nsrc*4)) = [];


DOA = [];
counter = 0;
while length(DOA) < nsrc
    
   [~, I] = max(pks); % index of max peak
   
   if isempty(I) % If no peaks detected
       if size(DOA) > 0
           DOA = [DOA DOA(1)]; % Assume two sources at biggest DOA
       else
           DOA = [DOA 0]; % Assume source at 0 (arbitrary)
       end
   else
       
       % Eliminate this peak and copied peak
       peakLoc = locsRad(I); % Radian location of this peak
       hiPeakLoc = locsRad(I) + 2*pi; % Locations of copied peaks
       loPeakLoc = locsRad(I) - 2*pi;
       idxToDelete = [locsRad > loPeakLoc-minSep/2 & locsRad < loPeakLoc+minSep/2; ...
           locsRad > peakLoc-minSep/2 & locsRad < peakLoc+minSep/2; ...
           locsRad > hiPeakLoc-minSep/2 & locsRad < hiPeakLoc+minSep/2];
       idxToDelete = logical(sum(idxToDelete));
       locsRad(idxToDelete) = [];
       pks(idxToDelete) = [];
       DOA = [DOA peakLoc];
   end
   
end

end