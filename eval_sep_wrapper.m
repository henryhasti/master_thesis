%% Script to carry out evaluation of separation

d = sqrt(sum((src-[rec; rec]).^2, 2)); % distance of each source to receiver

c = 343; % m/s speed of sound

sampDel = d/c*fs; % number of samples later signals are expected

sampDel = [floor(min(sampDel))-5 ceil(max(sampDel))+5]; % extremes of possible signal delays

estimate = zeros(4410, length(beam_sigs));

% Put estimates into one matrix
for idx = 1:length(beam_sigs)
    % Shift signal so direct sound is at 0
    %beam_sigs(idx).summed = circshift(beam_sigs(idx).summed(1:4410), -sampDel(1));
    
    estimate(:, idx) = beam_sigs(idx).summed(1:4410); %((1:4410) + sampDel(1));
end
%sampDel(2) = sampDel(2) - sampDel(1);

tic
eval_matrix = eval_separation(src_sigs(1:4410, :), estimate, sampDel);
toc

global PPEidx;
master(PPEidx).eval_matrix = eval_matrix;