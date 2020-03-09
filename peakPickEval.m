%% Test out DOA calculation

% Run with random levels of RT60/maxlim, diffuseness thresholds, source
% positions

for PPEidx = 1:1
    
    rt60 = rand(1)*1.5 + 0.01;
    maxlim = rt60;
    thresh = rand(1)*0.9 + 0.1;
    % Each source coordinate can be anywhere except with 0.5 meters of rec
    % position or wall
    src = zeros(1,3);
    src(1) = rand(1)*4 + (randi(2)-1) * 5;
    src(2) = rand(1)*4 + (randi(2)-1) * 5;
    src(3) = rand(1)*4 + (randi(2)-1) * 5;
    
    master(PPEidx).rt60 = rt60;
    master(PPEidx).thresh = thresh;
    master(PPEidx).src = src;
    
    dirAC_calc_printout;
    diffuseMasking;
    
    DOA = zeros(1,2);
    
    DOA(1) = peakPick(phi, 0.7, 0.5, 1/hop);
    DOA(2) = peakPick(theta, 0.7, 0.5, 1/hop);
    
    master(PPEidx).DOA = DOA;
    
    master(PPEidx).DOAerr = abs(DOA - master(PPEidx).realDOA);
    
end