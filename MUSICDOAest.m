%% Henry edited this section
% Reference: https://ieeexplore.ieee.org/abstract/document/1143830
% R.O. Schmidt
function est_dirs_music = MUSICDOAest(sh_sigs, nSrc)
% Returns DOA info (az in first row, el in second)
% sh_sigs is the ambisonic info for the song (4 channels)

aziElev2aziPolar = @(dirs) [dirs(:,1) pi/2-dirs(:,2)]; % function to convert from azimuth-inclination to azimuth-elevation
grid_dirs = grid2dirs(5,5,0,0); % Grid of directions to evaluate DoA estimation
fs = 44100;
%%% ---MUSIC spectrum
%
% The MUSIC method decomposes the spatial correlation matrix of the Sh
% signals into a signal dominated-subspace, and a noise-dominated subspace.
% Assuming orthogonality between the two, the MUSIC spectrum gives in a
% very fine resolution view of source DoAs in the sound-field. However that
% assumption can be violated again in the presence of correlated sources
% (e.g. early reflections), in which case additional processing should be
% employed to decorrelate these components.

% signal modeling
order = 1;
nSH = (order+1)^2;


% Calculate sphCOV


for idx = 1:4
    winSize = 2048;
    % B: spectrogram for each HOA
    [B(idx).spec, w, t] = spectrogram(sh_sigs(:, idx), hann(winSize), ...
        winSize/2, winSize, fs, 'yaxis');
    
end
M = nSH;
[K, N] = size(B(1).spec);

% Load into one tensor
spec = zeros(M,K,N);
for idx = 1:M
    spec(idx,:,:) = B(idx).spec;
end

PSD_mat = zeros(K,M,M);
for m1 = 1:M
    for m2 = 1:M
        
        PSD_mat(:,m1,m2) = cpsd(sh_sigs(:,m1), sh_sigs(:,m2), hann(winSize));
        
    end
end
PSD_mat = squeeze(mean(PSD_mat));
sphCOV = real(PSD_mat);

% DoA estimation
[P_music, est_dirs_music] = sphMUSIC(sphCOV, grid_dirs, nSrc);
est_dirs_music = est_dirs_music';
if false
    est_dirs_music = est_dirs_music*180/pi;
    % plots results
    plotDirectionalMapFromGrid(P_music, 5, 5, [], 0, 0);
    %src_dirs_deg = src_dirs*180/pi;
    line_args = {'linestyle','none','marker','o','color','r', 'linewidth',1.5,'markersize',12};
    %line(src_dirs_deg(:,1), src_dirs_deg(:,2), line_args{:});
    line_args = {'linestyle','none','marker','x','color','r', 'linewidth',1.5,'markersize',12};
    line(est_dirs_music(:,1), est_dirs_music(:,2), line_args{:});
    xlabel('Azimuth (deg)'), ylabel('Elevation (deg)'), title('MUSIC DoA, o: true directions, x: estimated')
    h = gcf; h.Position(3) = 1.5*h.Position(3); h.Position(4) = 1.5*h.Position(4);
end