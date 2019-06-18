% Besipiel zur Beurteilung was die option 'smallestimg' wirklich macht...
% Gibt sie die EW mit den hoechsten Betrag der negativen imaginaerteile aus
% oder gibt sie die EW mit einen Imaginaerteil, der moeglichst nahe an der
% liegt?

A=rand(20);
[V,D]=eig(A);D=diag(D)
A=sparse(A);
[V,D]=eigs(A,10,'si');D=diag(D)
%'smallestimag' extracts the eigenvalues with the smallest absolute value of the imaginary part of the iegenvalue