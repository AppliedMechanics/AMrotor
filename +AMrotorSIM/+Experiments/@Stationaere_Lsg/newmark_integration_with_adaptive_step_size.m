function [t,x,dotx,ddotx] = newmark_integration_with_adaptive_step_size(obj,M,C,K,forceFunction,tspan,x0,dotx0,options)
% See for example lecture script: Rixen, Structural Dynamics
% See Schweitzerhof 2004 For adaptive time stepping:
%   problem: factorization depends on time step size -> do not change time
%   step size too often

if ~isempty(obj.rotorsystem.pidControllers)
    warning('nemawrk with adaptive step size does not consider controller forces (yet)')
    prompt = 'Do you want to continue the time integration anyway? [y/n]   ';
    selection = input(prompt,'s');
    if ~strcmp(selection,'y')
        error('Aborted time integration, because adaptive step size controll for newmark does not consider controller forces.');
    end
end
globTol = options.globTol;
locTolUpper = options.locTolUpper;
locTolLower = options.locTolLower;

% figError = figure(30);
% clf
% figSol = figure(31);
% clf
figh = figure;
clf
figOutput = figure;
clf

%NEWMARK Newmark scheme (beta = 1/4, gamma = 1/2)
%   Mass M, damping C, stiffness K , excitation F (vector), time vector t, initial condition x0
if length(tspan)<2
    h = tspan(2)-tspan(1);
else 
    h = 1e-4;      % time step size, random start value, must be small enough, so that S is positive definite
end

% integration parameters
% here: Average constant acceleration scheme -> unconditionally stable
beta = 1/4;
gamma = 1/2;

s = 3; % errorLoc is proportinal to h^s, 3 for standard newmark scheme
tol = 1e-10;

% beta ~= 1/6 for error estimation
if beta == 1/6
    error('error estimation fails for beta=1/6')
end

S = M + h*gamma*C + h^2*beta*K;

R = chol(S);

t(1) = tspan(1);
x(:,1) = x0;
dotx(:,1) = dotx0;
t0 = tspan(1);
F = forceFunction(obj,t0,x,dotx);
ddotx0 = M\(-C*dotx0 - K*x0 + F);
ddotx(:,1) = ddotx0;


while t0 < tspan(end) % check integration interval
    
    t1 = t0 + h;
    
    F = forceFunction(obj,t1,x,dotx);
    
    % prediction
    x1     = x0 + h*dotx0 + (1/2-beta)*h^2*ddotx0;
    dotx1  = dotx0 + (1-gamma)*h*ddotx0;
    
    % acceleration computing
    ddotx1 = R\(R'\(-C*dotx1 - K*x1 + F));
    
    % correction
    dotx1 = dotx1 + h*gamma*ddotx1;
    x1    = x1 + h^2*beta*ddotx1;
    
    % error estimation, see Schweitzerhof 2004
    eLocVec = h^2*(1/6-beta)*(ddotx1-ddotx0);
    eGlobVec = (t0+h)/h * eLocVec;
    eLoc = norm(eLocVec);
    eGlob = norm(eGlobVec);
    
    flagNextStep = true;
    
    % check local error
    if eLoc > locTolUpper * (1+tol)
        % local error too high
        h = h * (locTolUpper/eLoc)^(1/s);
        flagNextStep = false;
        % new factorization
        S = M + h*gamma*C + h^2*beta*K;
        R = chol(S);
    end
    if eLoc < locTolLower * (1-tol)
        % local error too low
        h = h * (locTolLower/eLoc)^(1/s);
        flagNextStep = false;
        % new factorization
        S = M + h*gamma*C + h^2*beta*K;
        R = chol(S);
    end
    
    %check global error
    if eGlob > globTol
        % global error too high
        flagNextStep = false;
        factor = (globTol/eGlob)^(s/(s-1));
        locTolUpper = locTolUpper * factor;
        locTolLower = locTolLower * factor;
        warning('global error too high')
        locTolUpper
        locTolLower
        eGlob
        % restart the integration, dismiss all the old values and start new
        t0 = t(1);
        t = t(1);
        x = x(:,1);
        x0 = x;
        dotx = dotx(:,1);
        dotx0 = dotx;
        ddotx = ddotx(:,1);
        ddotx0 = ddotx;
    end
    
    set(0, 'CurrentFigure',figh)
    hold on
    plot(t1,h,'g.')
    
    if flagNextStep
        % check whether or not to call the output function, only at tspan
        set(0, 'CurrentFigure',figOutput)
        odeOutputFcnController(t1,[x1;dotx1],'',[],obj.rotorsystem);
        
        
        % save the results and continue to the next step
        t = [t, t1];
        x = [x,x1];
        dotx = [dotx,dotx1];
        ddotx = [ddotx,ddotx1];
        t0 = t1;
        x0 = x1;
        dotx0 = dotx1;
        ddotx0 = ddotx1;
    end
    
end

set(0, 'CurrentFigure',figh)
xlabel('t/s')
ylabel('time step size h/s')


end