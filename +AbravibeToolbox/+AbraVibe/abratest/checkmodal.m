% CHECKMODAL
% 
% This scripts checks MCK2FRF, MCK2MODAL, and MODAL2FRF and verifies that
% the three simulation commands produce corresponding results for d, v, and
% a type outputs. Both proportional and nonproportional damping models are
% tested to assure both real and complex modes are computed and synthesized
% correctly.
%
% NOTE: MCK2FRF is also checked on SDOF systems in the script CHECKMCK2FRF
%
% The principle of the test is:
% For one 2DOF model with proportional damping and one model with
% nonproportional damping:
% 1. Create a full (N-by-2-by-2) FRF matrix for the 2DOF system with
% MCK2FRF, for each option of output type: 'd', 'v', and 'a'
% 2. Create the modes and poles by MCK2MODAL
% 3. Synthesize a full FRF matrix for each of the output types with
% MODAL2FRF
% 4. Verify that each FRF from MCK2FRF is identical to the corresponding
% FRF from MODAL2FRF
% In addition to these tests, MCK2MODAL is also checked in the following
% way:
% A. The undamped system is solved and checked to have same undamped
% natural freq. and mode shapes as the proportionally damped case, and the
% Prop output variable is checked for the three cases (undamped, prop
% damping, and nonprop damping)

% Copyright 2009, Anders Brandt
% Email: abra@iti.sdu.dk

fprintf(fid,'Starting checkmodal...\n');

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
[p,Vp,Prop]=mck2modal(M,C,K);
if Prop ~= 1
    fprintf(fid,'Error in CHECKMODAL! Wrong Prop output for prop. damping\n');
end
% And go back from modal model to FRFs
Hpvd=modal2frf(f,p,Vp,1:2,1:2,'d');
Hpvv=modal2frf(f,p,Vp,1:2,1:2,'v');
Hpva=modal2frf(f,p,Vp,1:2,1:2,'a');
%=======================================================================
% Start checking...
for n=1:2           % Response dof
    for m=1:2       % Reference dof
        if norm(Hmckd(:,n,m)-Hpvd(:,n,m)) > 1e-6
            fprintf(fid,'Error in CHECKMODAL, prop. damping: Hmckd ~= Hpvd, n=%i, m=%i\n',n,m)
        end
        if norm(Hmckv(:,n,m)-Hpvv(:,n,m)) > 1e-6
            fprintf(fid,'Error in CHECKMODAL, prop. damping: Hmckv ~= Hpvv, n=%i, m=%i\n',n,m)
        end
        if norm(Hmcka(:,n,m)-Hpva(:,n,m)) > 1e-6
            fprintf(fid,'Error in CHECKMODAL, prop. damping: Hmcka ~= Hpva, n=%i, m=%i\n',n,m)
        end
    end
end
%========================================================================
% Undamped case: Check same wn and mode shapes as for prop damping
[pu,Vu,Prop]=mck2modal(M,K);
if ~isempty(Prop)
    fprintf(fid,'Error in CHECKMODAL! Wrong Prop output for undamped case\n');
end
wn=2*pi*poles2fz(p);    % wn from prop damping
if norm(wn-imag(pu)) > 1e-9
     fprintf(fid,'Error in CHECKMODAL! Wrong poles for undamped case \n');
end
if norm(diag(amac(Vu,Vp))-1) > 1e-10      
         fprintf(fid,'Error in CHECKMODAL! Wrong mode shapes for undamped case \n');
end
%========================================================================
% 2DOF system with nonproportional damping
% This system has natural frequencies of approx. 1.6 and 3.2 Hz (10 and 20
% rad/s)
C(1,1)=C(1,1)+0.5;
% Syntesize FRFs with 'd', 'v', and 'a' options
f=(0:0.01:5)';              % Suitable frequency axis for all analysis
Hmckd=mck2frf(f,M,C,K,1:2,1:2,'d');
Hmckv=mck2frf(f,M,C,K,1:2,1:2,'v');
Hmcka=mck2frf(f,M,C,K,1:2,1:2,'a');
% Compute poles and modes of system
[p,V]=mck2modal(M,C,K);
if Prop ~= 0
    fprintf(fid,'Error in CHECKMODAL! Wrong Prop output for nonprop. damping\n');
end
% And go back from modal model to FRFs
Hpvd=modal2frf(f,p,V,1:2,1:2,'d');
Hpvv=modal2frf(f,p,V,1:2,1:2,'v');
Hpva=modal2frf(f,p,V,1:2,1:2,'a');
%=======================================================================
% Start checking...
for n=1:2           % Response dof
    for m=1:2       % Reference dof
        if norm(Hmckd(:,n,m)-Hpvd(:,n,m)) > 1e-9
            fprintf(fid,'Error in CHECKMODAL: Hmckd ~= Hpvd, n=%i, m=%i\n',n,m)
        end
        if norm(Hmckv(:,n,m)-Hpvv(:,n,m)) > 1e-9
            fprintf(fid,'Error in CHECKMODAL: Hmckv ~= Hpvv, n=%i, m=%i\n',n,m)
        end
        if norm(Hmcka(:,n,m)-Hpva(:,n,m)) > 1e-9
            fprintf(fid,'Error in CHECKMODAL: Hmcka ~= Hpva, n=%i, m=%i\n',n,m)
        end
    end
end

fprintf(fid,'Verification completed. If no outputs where printed, the MODAL2FRF, \n')
fprintf(fid,'MCK2FRF, and MCK2MODAL commands work as they should\n')
