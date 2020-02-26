function [SDR, SIR, SNR, SAR] = eval_separation(sigOrig, sigReturned)

% Given original and returned signal, calculate the signal to distortion,
% interference, noise, and artifact ratios

s_target = dot(sigOrig, sigReturned)*sigOrig/dot(sigOrig, sigOrig);

e_interf = 0; % for now; only one signal

noise_sum = 0; % Since we don't have known noise sources?

e_noise = noise_sum - e_interf;

e_artif = sigReturned - sigOrig - noise_sum;

% Now calculate measures

SDR = 10*log10(dot(sigOrig, sigOrig)/dot(sigReturned-sigOrig, sigReturned-sigOrig));

SIR = 10*log10(dot(sigOrig, sigOrig)/dot(e_interf, e_interf));

SNR = 10*log10(dot(sigOrig + e_interf)/dot(e_noise, e_noise));

SAR = 10*log10(dot(sigOrig+e_interf+e_noise, sigOrig+e_interf+e_noise)/...
    dot(e_artif, e_artif));



end