%% Trying to work out the signs used in roomsim and what coordinate system
% they are based on

clear
clc
close all
%% Define parameters
room = [10, 10, 10]; % Room dimensions
rt60 = [1]; % Reverberation time
rec = [ 5,5,5]; % Receiver positions
fs = 44100;

for jdx = 1:3
    % source positions (one at +1 meters from source in all 3 dimensions)
    src = [5,5,5];
    src(jdx) = src(jdx) + 1;
    rec_orders = 1; % First order ambisonics
    
    %% Generate RIRs
    % This creates sh_rirs
    TEST_SCRIPT_SH;
    for idx = 1:4
        lenRIR = length(sh_rirs(:,1));
        
        figure
        plot((1:lenRIR)/fs, sh_rirs(:, idx))
        title(['RIR for channel ' num2str(idx) ' with source on axis ' num2str(jdx)])
        %ylim([-0.4, 0.4])
    end
end