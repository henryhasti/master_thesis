function eval_matrix = eval_separation(mix, estimate, searchRange, noise)
% Given original and returned signal, calculate the signal to distortion,
% interference, noise, and artifact ratios of all combinations of oringial
% to returned.
% According to paper:  Emmanuel Vincent, Rémi Gribonval, Cédric Févotte.
% Performance measurement in blind audio source separation. IEEE
% Transactions on Audio, Speech and Language Processing, Institute of
% Electrical and Electronics Engineers, 2006, 14 (4), pp.1462–1469.
% inria-00544230

% mix is the combination of all sources, before transmission. Stored as T*J
%   matrix, where T is signal length and J is the number of signals.
% estimate is the separated signal(s) calculated from the mix, stored as a
%   T*(number of estimates calculated) matrix
% noise is the noise source known to be at each microphone, stored as a T*I
%   matrix, where I is the number of microphones
% searchRange is the number of samples we are willing to shift the mix in
%   order to search for the estimate. Should be set to roughly 
%   (src-rec distance)/(speed of light)*(sampling frquency). Stored as a
%   tuple: [minimum shift, maximum shift] relative to zero. [1,0] is no
%   shift
% eval_matrix is 3-d: estimate, source, (SDR, SIR, SNR, SAR)

if nargin < 4
    noise = []; % assume no noise if unspecified (size will be adjusted later)
end

J = length(mix(1,:)); % number of sources

% results saved as: estimate, source, (SDR, SIR, SNR, SAR)
eval_matrix = zeros(length(estimate(1,:)), J, 4);


% Extend mix and noise to include time-delayed versions

% Zero pad endings (so that shifts only add zeros and not signal endings)
if searchRange(2) > searchRange(1) %only if requesting shift
    mix = vertcat(mix, zeros(searchRange(2), J));
    if ~isempty(noise)
        noise = vertcat(noise, zeros(searchRange(2), J));
    end
    
    mixTmp = mix;
    noiseTmp = noise;
    for idx = searchRange(1):searchRange(2)
        
        mix = [mix circshift(mixTmp, idx)]; % Add time-shifted version to the subspace
        noise = [noise circshift(noiseTmp, idx)];
        
    end
end


% Find signal length to be used (others will be zero padded)
if ~isempty(noise)
    T = max([length(mix(:,1)), length(estimate(:,1)), length(noise(:,1))]); 
else
    T = max([length(mix(:,1)), length(estimate(:,1))]);
end

% Make all signals the same length by zero-padding if too short
mix = vertcat(mix, zeros(T-length(mix(:,1)), length(mix(1,:))));
estimate = vertcat(estimate, zeros(T-length(estimate(:,1)), length(estimate(1,:))));
if ~isempty(noise)
    noise = vertcat(noise, zeros(T-length(noise(:,1)), length(noise(1,:))));
end

for sourceIdx = 1:J % check every actual source
    for estimateIdx = 1:length(estimate(1,:)) % against every estimate
                
        % target signal to be reconstructed (and time delayed versions)
        s_src = mix(:,sourceIdx:J:end); 
        s_est = estimate(:, estimateIdx); % estimate of target signal
        
        % Calculate projection matrices
        Psj = projMat(s_src);
        Ps = projMat(mix);
        Psn = projMat([mix, noise]);
        
        % calculate components of s_hat (could be done more efficiently,
        % since some terms are calculated twice)
        s_target = Psj*s_est;
        e_interf = Ps*s_est - s_target;
        e_noise = Psn*s_est - Ps*s_est;
        e_artif = s_est - Psn*s_est;
        
        % Calculate ratios
        SDR = 10*log10(energy(s_target)/energy(e_interf + e_noise + e_artif));
        SIR = 10*log10(energy(s_target)/energy(e_interf));
        SNR = 10*log10(energy(s_target + e_interf)/energy(e_noise));
        SAR = 10*log10(energy(s_target + e_interf + e_noise)/energy(e_artif));
        
        % insert ratios into output matrix
        eval_matrix(estimateIdx, sourceIdx, :) = [SDR, SIR, SNR, SAR]';
    end
end
end

function projMat = projMat(Y)
% Given a matrix Y containing column vectors spanning a subspace, return the
% projection matrix into that subspace

projMat = Y*inv(Y'*Y)*Y';
% projMat can also be seen as the least squares estimatemultiplier matrix:
% multiplying by it provides the estimate of the multiplicant in projMat's
% subspace
end
function dotP = energy(vec)
% calculate energy of signal (dot product with itself)
dotP = dot(vec, vec);
end