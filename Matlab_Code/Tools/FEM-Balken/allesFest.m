BCs = 1:length(M);
% x richtung
BCs(1) = NaN; BCs(4) = NaN;
BCs(end-3) = NaN; BCs(end) = NaN;
% y Richtung
BCs(2) = NaN; BCs(3) = NaN;
BCs(end-2) = NaN; BCs(end-1) = NaN;