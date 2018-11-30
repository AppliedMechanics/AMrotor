function compute_newmark(obj)
tic

        obj.clear_time_result()
        obj.result = containers.Map('KeyType','double','ValueType','any');

for drehzahl = obj.drehzahlen 
%         M=obj.rotorsystem.systemmatrices.M;
%         C=obj.rotorsystem.systemmatrices.D;
%         K=obj.rotorsystem.systemmatrices.K;
        omega = drehzahl /60 *2*pi;
        [M,C,G,K] = obj.rotorsystem.assemble_system_matrices(drehzahl);
        D = C + omega*G;
        
        x0 = zeros(length(M),1);
        dotx0=zeros(length(M),1);
        t=obj.time;
        
%         h_ges=sparse(length(M),1);
%         h_ges(1)=10;
        
        
%         F=h_ges;
        
%NEWMARK Newmark scheme (beta = 1/4, gamma = 1/2)
%   Mass M, damping C, stiffness K , excitation F (vector), time vector t, initial condition x0
h = t(2)-t(1);      % time step size

beta = 1/4;         % integration parameters
gamma = 1/2;    

S = M + h*gamma*D + h^2*beta*K;

R = chol(S);

x(:,1) = x0;
xtemp = x0;
dotxtemp = dotx0;
Z = [x; dotxtemp]; F = obj.rotorsystem.assemble_system_loads(t(1),Z,omega); 
ddotxtemp = M\(-D*dotxtemp - K*xtemp + F);

for iter = 2:length(t)
    Z = [xtemp; dotxtemp];
    F = obj.rotorsystem.assemble_system_loads(t(iter),Z,omega); 
    
    % prediction
    xtemp     = xtemp + h*dotxtemp + (1/2-beta)*h^2*ddotxtemp;
    dotxtemp  = dotxtemp + (1-gamma)*h*ddotxtemp;
    
    % acceleration computing
    ddotxtemp = R\(R'\(-D*dotxtemp - K*xtemp + F));
    
    % correction
    dotxtemp = dotxtemp + h*gamma*ddotxtemp;
    xtemp    = xtemp + h^2*beta*ddotxtemp;
    
    x(:,iter) = xtemp;

    plot(x(1:6:end/2,iter))
    drawnow
    
    res.X = x(1:end,:);
    disp(['t_current = ',num2str(t(iter))])

    obj.result(drehzahl)=res;
end

toc
end

