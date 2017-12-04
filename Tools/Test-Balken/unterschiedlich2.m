BCs = 1:length(M);
% x richtung
K(1,1) = K(1,1) + 1e7;
K(4,4) = K(4,4) + 1e7;
% y Richtung
BCs(2) = NaN; BCs(3) = NaN;
K(end-1,end-1) = K(end-1,end-1) + 1e17;
K(end-2,end-2) = K(end-2,end-2) + 1e17;