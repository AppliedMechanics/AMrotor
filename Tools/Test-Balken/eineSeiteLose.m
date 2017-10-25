BCs = 1:length(M);
% x richtung
BCs(end-3) = NaN; BCs(end) = NaN;
% y Richtung
BCs(2) = NaN; BCs(3) = NaN;