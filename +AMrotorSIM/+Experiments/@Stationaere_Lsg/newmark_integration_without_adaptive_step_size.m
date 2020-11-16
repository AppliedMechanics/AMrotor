function [t,x,dotx,ddotx,localError,globalError] = newmark_integration_without_adaptive_step_size(obj,M,C,K,forceFunction,t,x0,dotx0)
% Function for newmark without adaptive stepsize
%
%    :param M: Mass
%    :type M: matrix
%    :param C: Damping without gyro
%    :type C: matrix
%    :param K: Stiffness
%    :type K: matrix
%    :param forceFunction: Force for RHS of equation
%    :type forceFunction: function
%    :param t: Time step
%    :type t: double
%    :param x0: Start state vector (Z = [x; dotx];)
%    :type x0: vector
%    :param dotx0: Start of derivative part of state vector Z = [x; dotx];
%    :type dotx0: vector
%    :return: Derivatives of state vector parts, the time vector and error values [t,x,dotx,ddotx,localError,globalError]

% See for example lecture script: Rixen, Structural Dynamics
% but here use LU-factorization instad of Cholesky, because here S is not
% symmetric (because of G)
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

%NEWMARK Newmark scheme (beta = 1/4, gamma = 1/2)
%   Mass M, damping C, stiffness K , excitation F (vector), time vector t, initial condition x0
h = t(2)-t(1);      % time step size

% integration parameters
% here: Average constant acceleration scheme -> unconditionally stable
beta = 1/4;
gamma = 1/2;

% beta ~= 1/6 for error estimation
if beta == 1/6
    warning('error estimation fails for beta=1/6')
end

S = M + h*gamma*C + h^2*beta*K;

[L,U,P]=lu(S);

x(:,1) = x0;
xtemp = x0;
dotx(:,1) = dotx0;
dotxtemp = dotx0;
tCurr = t(1);
F = forceFunction(obj,tCurr,x,dotx);
ddotxtemp = M\(-C*dotxtemp - K*xtemp + F);
ddotxtemp(6:6:end) = 0; % angular acceleration = 0 -> constant angular velocity -> STATIONARY
ddotx(:,1) = ddotxtemp;

eLoc = zeros(size(t));
odeOutputFcnController(tCurr,[x0;dotx0],'init',[],obj.rotorsystem);

for iter = 2:length(t)
    tCurr = t(iter);
    
    F = forceFunction(obj,tCurr,xtemp,dotxtemp);
    
    % prediction
    xtemp     = xtemp + h*dotxtemp + (1/2-beta)*h^2*ddotxtemp;
    dotxtemp  = dotxtemp + (1-gamma)*h*ddotxtemp;
    
    % acceleration computing
    LUtemp = L\(P*(-C*dotxtemp - K*xtemp + F));
    ddotxtemp = U\LUtemp;
    ddotxtemp(6:6:end) = 0; % angular acceleration = 0 -> constant angular velocity -> STATIONARY
    
    % correction
    dotxtemp = dotxtemp + h*gamma*ddotxtemp;
    xtemp    = xtemp + h^2*beta*ddotxtemp;
    
    x(:,iter) = xtemp;
    dotx(:,iter) = dotxtemp;
    ddotx(:,iter) = ddotxtemp;
    
    % local error
    eLocVec = h^2*(1/6-beta)*(ddotx(:,iter-1)-ddotx(:,iter));
    eGlobVec = tCurr/h * eLocVec;
    eLoc(iter) = norm(eLocVec);
    eGlob = norm(eGlobVec);
    
    odeOutputFcnController(tCurr,[x(:,iter);dotx(:,iter)],'',[],obj.rotorsystem);
end
odeOutputFcnController(tCurr,[xtemp;dotxtemp],'done',[],obj.rotorsystem);

disp(['max local error = ',num2str(max(max(eLoc)))]);
disp(['max global error = ',num2str(max(max(eGlob)))]);

localError = eLoc;
globalError = eGlob;

figError = figure; clf
hold on
plot(t,eLoc,'r.')
xlabel('t/s')
ylabel('max. local error')
drawnow

end