% CHECKMKZ2FRF
% 
% This scripts checks MKZ2FRF, verifies that it gives the same result as
% MCK2FRF for a proportionally damped system.
%
% NOTE: MCK2FRF is checked by CHECKMCK2FRF and CHECKMODAL.
%
% The principle of the test is:

% Copyright 2009, Anders Brandt
% Email: abra@iti.sdu.dk

fprintf(fid,'Starting checkmkz2frf...\n');

%========================================================================
% 2DOF system with proportional damping
% This system has natural frequencies of approx. 1.6 and 3.2 Hz (10 and 20
% rad/s)
M=eye(2);
k1=100;
k2=150;
k3=100;
K=[k1+k2 -k2;-k2 k2+k3];
a=2/15;
b=1/1500;
C=a*M+b*K;
% Syntesize FRFs with 'd', 'v', and 'a' options
f=(0:0.01:5)';              % Suitable frequency axis for all analysis
Hmckd=mck2frf(f,M,C,K,1:2,1:2,'d');
Hmckv=mck2frf(f,M,C,K,1:2,1:2,'v');
Hmcka=mck2frf(f,M,C,K,1:2,1:2,'a');
% Compute poles and modes of system
[p,V]=mck2modal(M,C,K);
% Calculate relative damping 
[fn,zn]=poles2fz(p);
% Now synthesize FRFs using mkz2frf
Hmkzd=mkz2frf(f,M,K,zn,1:2,1:2,'d');
Hmkzv=mkz2frf(f,M,K,zn,1:2,1:2,'v');
Hmkza=mkz2frf(f,M,K,zn,1:2,1:2,'a');
%=======================================================================
% Start checking...
for n=1:2           % Response dof
    for m=1:2       % Reference dof
        if norm(Hmckd(2:end,n,m)-Hmkzd(2:end,n,m)) > 1e-4
            fprintf(fid,'Error in CHECKMKZ2FRF: Hmckd ~= Hmkzd, n=%i, m=%i\n',n,m)
        end
        if norm(Hmckv(2:end,n,m)-Hmkzv(2:end,n,m)) > 1e-3       % Numerical precision deteriorates with differentiation
            fprintf(fid,'Error in CHECKMKZ2FRF: Hmckv ~= Hmkzv, n=%i, m=%i\n',n,m)
        end
        if norm(Hmcka(2:end,n,m)-Hmkza(2:end,n,m)) > 5e-3       % Numerical precision deteriorates with differentiation
            fprintf(fid,'Error in CHECKMKZ2FRF: Hmcka ~= Hmkza, n=%i, m=%i\n',n,m)
        end
    end
end

fprintf(fid,'Verification completed. If no outputs where printed, then MKZ2FRF, works as it should\n')

