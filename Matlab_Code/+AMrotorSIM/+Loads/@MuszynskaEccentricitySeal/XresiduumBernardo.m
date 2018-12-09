function [residual] = residuumBernardo(lambda,sys, init)
%Basierend auf der Diss von CW 
%   Kapitel 4. Gleichungen der Bulk-Flow-Formulation Passt! CW 17.11.2018
m0=-0.25;


u=sqrt((2*sys.p)/(sys.rho*(1+sys.xi_ein+(2*lambda*sys.L)/(sys.rL))));    % Glg. 4.11

R_a=(u*sys.rL)/(sys.nu);                                                 % Glg. 4.18

R=sys.R;                                                              % Wellendurchmesser

b=u/(R*init.omega0IR(1));                                               % Glg. 4.21 %richtiges Omega?

% sigma=lambda*sys.L/sys.rL;

beta=1/(1+4*b^2);

% T=sys.L/u;

B=1+4*b^2*beta*(1+m0);

% E=(1+sys.xi_ein)/(2*(1+sys.xi_ein+B*sigma));
% 
% a=sigma*(1+beta*(1+m0));
% 
% alpha=sys.alpha;

%% Koeffizienten nach CHILDS 
n0=0.066;


%%

lambda2=(n0*R_a^m0)*(1+1/(4*b^2))^((1+m0)/2);
residual=lambda2-lambda;





end

