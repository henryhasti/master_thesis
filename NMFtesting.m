%% Edited NMFseparation to make super easy example

 % 2. Manufacture STFT
% spectral parameters

numBins = 16; % Frequency
numFrames = 18; % Time

bass1 = [1;0;0;0;1;0;0;0];
bass2 = [0;1;0;0;0;1;0;0];
bass3 = [0;0;1;0;0;0;1;0];
bass4 = [0;0;0;1;0;0;0;1];
bass0 = zeros(8,1);
bass = [bass1, bass0, bass1, bass0, bass0, bass0, bass1, bass1, bass0, bass0, ...
    bass1, bass0, bass2, bass0, bass3, bass0, bass1, bass0];

vox = [bass0, bass0, bass1, bass2, bass2, bass3, bass4, bass4,bass0, bass0, ...
    bass4, bass3, bass2, bass1, bass1, bass0, bass1, bass2];
A = vertcat(vox, bass);

 % get dimensions and time and freq resolutions
deltaT = 0.5;
deltaF = 5;

 % 3. apply NMF variants to STFT magnitude
% set common parameters
numComp = 2;
numIter = 1;
numTemplateFrames = 4;

 % generate initial guess for templates
paramTemplates.deltaF = deltaF;
paramTemplates.numComp = numComp;
paramTemplates.numBins = numBins;
paramTemplates.numTemplateFrames = numTemplateFrames;
initW = initTemplates(paramTemplates,'random');

 % generate initial activations
paramActivations.numComp = numComp;
paramActivations.numFrames = numFrames;
initH = initActivations(paramActivations,'random');

 % NMFD parameters
paramNMFD.numComp = numComp;
paramNMFD.numFrames = numFrames;
paramNMFD.numIter = numIter;
paramNMFD.numTemplateFrames = numTemplateFrames;
paramNMFD.initW = initW;
paramNMFD.initH = initH;

 % NMFD core method
[nmfdW, nmfdH, nmfdV, divKL] = NMFD(A, paramNMFD);

 % alpha-Wiener filtering
nmfdA = alphaWienerFilter(A,nmfdV,1);

% visualize
if false
    paramVis.deltaT = deltaT;
    paramVis.deltaF = deltaF;
    paramVis.endeSec = 10; %3.8;
    paramVis.fontSize = 14;
    visualizeComponentsNMF(A, nmfdW, nmfdH, nmfdA, paramVis);
end

%% resynthesize
if false
for k = 1:numComp
  Y = nmfdA{k} .* exp(j * P);

  % re-synthesize, omitting the Griffin Lim iterations
  y = inverseSTFT(Y, paramSTFT);

  % save result
  audiowrite([outPath,'EstimatedSource_',   num2str(k), '.wav'],y,fs);
end


%% Test section: resynthesize just estimates before Wiener filtering
for k = 1:numComp
  Y = nmfdV{k} .* exp(j * P);

  % re-synthesize, omitting the Griffin Lim iterations
  y = inverseSTFT(Y, paramSTFT);

  % save result
  audiowrite([outPath,'preWiener_',   num2str(k), '.wav'],y,fs);
end
end