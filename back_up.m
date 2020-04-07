%% Pick peaks to determine where sounds come from
% in terms of phi and theta


[pks,locs] = findpeaks(phi(2,:));

DOA = zeros(1,2);

DOA(1) = phi(1, locs(pks == max(pks, 1)));
% DOA(1).angle = phi(1, locs(pks>2*mean(pks)));

[pks,locs] = findpeaks(theta(2,:));

DOA(2) = theta(1, locs(pks == max(pks, 1)));
% DOA(2).angle = theta(1, locs(pks>2*mean(pks)));