function beam_sigs = beamforming(DOA, sh_sigs, weights)

%% Beamform towards desired signal sources
% Given direction of arrival pairs stored in DOA (columns of az, el pairs)
% Given signals to be separated sh_sigs (column vectors)
% Given weighting system for channels (to implement corrective gains)

% Output beam_sigs: .sigs = each channel weighted by beamformer
% .summed: beamformed channels summed (final estimate)


if nargin < 3
    weights = [1, 1, 1, 1];
end

%% Calculate beamformer

for idx = 1:length(DOA(1,:)) % for every pair
    
    beam_sigs(idx).sigs = zeros(size(sh_sigs));
    
    az = DOA(1,idx); % Direction to beamform towards
    el = DOA(2,idx);
    beamformer = ones(length(sh_sigs(:,1)), 1) * ...
        weights.*[1, sqrt(3)*sin(az)*sin(el2pol(el)), ...
        sqrt(3)*cos(el2pol(el)), sqrt(3)*cos(az)*sin(el2pol(el))];
    
    beam_sigs(idx).sigs = (sh_sigs .* beamformer);
    beam_sigs(idx).summed = sum(beam_sigs(idx).sigs, 2); %sum(beam_sigs(idx).sigs(:, 2:4), 2);
end

if false % Only run next sections if called individually
    %%
    
    hold on
    plot(beam_sigs(1).summed)
    plot(src_sigs(1:44100, 1))
    
    %% Play original sounds
    
    secsToPlay = 6;
    source = 1;
    
    soundsc(src_sigs(1:44100*secsToPlay,source), fs)
    
    %% Play total sound (mix)
    
    secsToPlay = 5;
    
    soundsc(sum(sh_sigs(1:44100*secsToPlay,:),2), fs)
    
    %% Play individual SH signals
    
    secsToPlay = 6;
    channel = 3;
    soundsc(sh_sigs(1:44100*secsToPlay,channel), fs)
    %% Check out reconstructions
    
    secsToPlay = 10;
    source = 4;
    soundsc(beam_sigs(source).summed(1:44100*secsToPlay), fs)
    
end
end