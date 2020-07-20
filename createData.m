%% Prepare audio, room, signals
% Does entire processing chain up to separation: prepares audio, room
% impulse responses, and resulting simulated recorded signals. In other
% words, generates the (meta) data that would be recorded in a real room
% and later processed.
%% Prepare anechoic audio
% Assume src_sigs has already been created by caller script

%% Prepare room and recording setup
% Reverb characteristics
rt60 = 1; % Reverberation time (at least ~0.3 due to archpol glitch)
%maxlimMaster = [0.01, 0.2, 0.4, 0.7]; % Max time RIR is calculated for

% Room geometry/setup
room = [10, 8, 3]; % Room dimensions
rec = [ 5, 4, 1.5]; % Receiver position
rec_orders = 1; % First order ambisonics

% Source positions (azimuth, elevation, radius)
% azimMaster(1).data = deg2rad([-180, -90, 0, 90]);
% azimMaster(2).data = deg2rad([-170, -10, 0, 90]);
% azimMaster(3).data = deg2rad([-20, -10, 0, 90]);
% azimMaster(4).data = deg2rad([-30, -20, -10, 0]);


%maxlim = maxlimMaster(reverbTime);
%azim = azimMaster(azimuthAngle).data;
azim = 0.07;
elev = deg2rad([0]);
rad = 1 * ones(1, length(azim));
[srcX, srcY, srcZ] = sph2cart(azim, elev, rad);
src = [srcX' srcY' srcZ'] + rec;

realDOA = [azim; elev]; % direction of arrival

%% Calculate room impulse responses and received signals

sh_rirs = gen_RIRs(fs, maxlim, rec, rec_orders, room, rt60, src);

% Generate sound scenes
% Each source is convolved with the respective mic IR, and summed with
% the rest of the sources to create the microphone mixed signals

% This should be the signals received at each microphone
sh_sigs = apply_source_signals_sh(sh_rirs, src_sigs);
sh_sigs = sh_sigs * sqrt(4*pi); % Normalization
% sh_sigs(2:4) = sh_sigs(2:4)/sqrt(3); Only for SN3D




