BCs = 1:length(M);
% x richtung
K(1,1) = K(1,1) * 1e-16;
K(4,4) = K(4,4) * 1e-16;
K(end-3,end-3) = K(end-3,end-3) * 1e-16;
K(end,end) = K(end,end) * 1e-16;
% BCs(end-3) = NaN; BCs(end) = NaN;
% y Richtung
K(2,2) = K(2,2) * 1e-16;
K(3,3) = K(3,3) * 1e-16;
K(end-2,end-2) = K(end-2,end-2) * 1e-16;
K(end-1,end-1) = K(end-1,end-1) * 1e-16;