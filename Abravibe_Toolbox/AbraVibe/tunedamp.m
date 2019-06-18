function [H,f] = tunedamp(fr,zr,m_ratio,z_ratio)
% TUNEDAMP  Compute FRF of tuned damper with SDOF system
%
%       tunedamp(fr,zr,m_ratio,z_ratio), or
%       [H,f] = tunedamp(fr,zr,m_ratio,z_ratio)
%
%       H           Matrix with two columns, the first with the FRF
%                   including the tuned damper, the second with the original SDOF FRF.
%       f           Frequency axis for H
%
%       fr          SDOF resonance frequency
%       zr          SDOF modal (=relative) damping in percent
%       m_ratio     ma/M, where ma is absorber mass, M is SDOF mass
%       z_ratio     za/zr, where za is absorber (modal) damping, zr SDOF
%                   damping
%
% This function simulates the effect of adding a tuned damper to an SDOF
% system.
% With no output arguments, the resulting FRF is plotted overlayed with the
% original (SDOF) FRF.
% Note! The z_ratio should be selected so that it 'makes sense' in
% combination with zr (does not become too high).

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Set parameters: If you want to, you can change the output FRF type below
m=1;
k=(2*pi*fr)^2*m;
c=2*sqrt(m*k)*zr;
type='d';               % default uses flexibility
% type='v';             % Uncomment to use mobility output instead
% type='a';             % uncomment to use accelerance instead

f=(0:fr/1000:3*fr)';
Hs=mck2frf(f,m,c,k,1,1,'d');

% Tuned absorber, at fr
ma=m*m_ratio;
ka=(2*pi*fr)*(2*pi*fr)*ma;
za=z_ratio*zr;
ca=za*2*sqrt(ma*ka);
% Build matrices for 2DOF system
M=[m 0;0 ma];
K=[k+ka -ka;-ka ka];
C=[c+ca -ca;-ca ca];
H2=mck2frf(f,M,C,K,1,1,'d');

if nargout == 0
% Plot results
semilogy(f,abs(Hs),f,abs(H2),'r');
grid
xlabel('Frequency [Hz]')
if strcmp(type,'d')
    ylabel('Dynamic Flexibility, [m/N]')
elseif strcmp(type,'v')
    ylabel('Mobility, [(m/s)/N]')
elseif strcmp(type,'a')
    ylabel('Accelerance, [(m/s^2)/N]')
end
else
    H=[H2 Hs];
end


