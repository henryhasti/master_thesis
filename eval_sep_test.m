%% Eval_separation testing
% Stand-alone function to call test cases on eval_separation function

% function eval_matrix = eval_separation(mix, estimate, noise)
%% Test proj_mat sub-function
% Stepped through with breakpoints. Looks good
mix = [1,0,0;
    0,1,0;
    0,0,1]; % 3- ortho basis vectors

estimate = [3; 4; 5]; % how does this test vector get projected?

eval_separation(mix, estimate);

%% With noise signals, artifacts

mix = [1,0,1;
    0,1,1;
    0,1,3;
    0,2,5;
    0,3,2];
estimate = [0,3,1;
    1,2,1;
    1,1,3;
    2,4,5;
    3,5,1];
noise = [3;2;1;4;5];

eval_separation(mix, estimate, noise);
% Some cases seemed not to work as expected: estimate(3) did not match
% perfectly with mix(3) at any of the samples (in any of the dimensions)

%% Test the weird case again

mix = [1;1;3;5;2];
estimate = [1;1;3;5;1];
eval_separation(mix, estimate);

% Further inspection/thought: It is correct that the other dimension values
% are altered due to projection principles. Otherwise it would be the case
% that a vector shorter than its subspace and angled off would be graded as
% exactly the same.
% I now question the efficacy of this approach, given that some samples can
% match perfectly but appear not to because other samples are inaccurate. 

%% Test time-invariant gains robustness
mix = [1;1;3;5;2];
estimate = [1;1;3;5;1];
squeeze(eval_separation(mix, estimate))

estimate = estimate * 0.5;
squeeze(eval_separation(mix, estimate))

% Identical results - All good!

%% Test time invariance and real music signal
[other, ~] = audioread('other.wav');
other = sum(other, 2)/2;

disp('Identical target and estimate')
squeeze(eval_separation(other(1:4410), other(1:4410), [1,0])) % standard case
% Good ratios

% test zero padding
disp('Estimate longer than mix')
mix = other(1:4410);
estimate = other(1:4450);
squeeze(eval_separation(mix, estimate, [1,0]))
% SDR and SAR (all due to SAR) drop significantly due to changes at end of
% signal

%% Test time delayed signal
tic
disp('Delayed estimate')
mix = other(1:4410);
estimate = vertcat(zeros(40,1), other(1:4410));
squeeze(eval_separation(mix, estimate, [1,0]))
toc
% Performs quite badly, because none of the samples are aligned

% Test time delayed with shift to match subspace
tic
disp('Delayed estimate, with allowed delay')
estimate = vertcat(zeros(40,1), other(1:4410));
squeeze(eval_separation(mix, estimate, [35, 45]))
toc
% Performs very well (as well as in the identical source/mix case), but
% slowly

%% Check with multiple sources and mixes
% Make sure correct shifts are being applied
  
[bass, ~] = audioread('bass.wav');
bass = sum(bass(1:4410), 1)/2;
bass = bass';
[drums, ~] = audioread('drums.wav');
drums = sum(drums(1:4410), 1)/2;
drums = drums';
other = other(1:4410);
[vocals, ~] = audioread('vocals.wav');
vocals = sum(vocals(1:4410), 1)/2;
vocals = vocals';

% Standard case
tic 
mix = [bass, drums, other, vocals];
estimate = [bass, drums, other, vocals];
eval_separation(mix, estimate, [1,0]);
toc
% Works: each estimate performs best against the correct mix component

% Some time shifted signals
estimate = vertcat(zeros(40, 4), estimate);
tic 
eval_separation(mix, estimate, [35, 45]);
toc
% Works as expected. Virtually the same results as for the standard case
% (again, slower, 10.6 vs 7.6 seconds)

%% What happens when reverb/noise is added?

[bass, ~] = audioread('bass.wav');
bass = sum(bass(1:4410), 1)/2;
bass = bass';
[drums, ~] = audioread('drums.wav');
drums = sum(drums(1:4410), 1)/2;
drums = drums';

echofilt = [1, 0.5, 0.25, 0.125, 0.0625];
tic 
estimate = [bass drums] + [rand(size(bass)) rand(size(drums))];
mix = [bass, drums];
eval_separation(mix, estimate, [1,0]);
toc
% Performance degrades significantly. Still, the diagonal of correct source
% to estimate is clearly better than the opposite diagonal up until > 0.5
% noise
