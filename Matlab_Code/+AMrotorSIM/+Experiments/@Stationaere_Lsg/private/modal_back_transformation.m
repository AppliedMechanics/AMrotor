function [X,X_d,x,x_d,beta,beta_d,y,y_d,alpha,alpha_d,omega_ode,phi_ode] = modal_back_transformation(Z,M,V_red)
% 
%% %Ruecktransformation
EVmr=V_red;

dim_M = size(M);
mX = Z(:,1:dim_M(1));

mXd = Z(:,(dim_M(1)+1): 2*dim_M(1));

X = EVmr*mX';

X_d = EVmr*mXd';

%% Extraktion der Verschiebungen und Beschleunigungen

x         = X(1:2:end/2,:);           %Verschiebung in x-Richtung 
beta      = X(2:2:end/2,:);           %Verdrehung um y 

y         = X(end/2+1:2:end,:);       %Verschiebung in y-Richtung
alpha     = X(end/2+2:2:end,:);       %Verdrehung um x 

x_d       = X_d(1:2:end/2,:);          %Geschwindigkeit in x-Richtung 
beta_d    = X_d(2:2:end/2,:);          %Winkelgeschwindigkeit um y 

y_d       = X_d(end/2+1:2:end,:);      %Geschwindigkeit in y-Richtung  
alpha_d   = X_d(end/2+2:2:end,:);      %Winkelgeschwindigkeit um x 

omega_ode = Z(:,end);
phi_ode   = Z(:,end-1);

end