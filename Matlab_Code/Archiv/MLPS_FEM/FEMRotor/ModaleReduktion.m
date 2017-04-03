function [mK,mM] = ModaleReduktion(K,M,Moden)
%MODALEREDUKTION
[EV,EW] = eigs(K,M,Moden,'sm');
EW= diag(EW);



end

