function compute_newmark(obj)
% See for example lecture script: Rixen, Structural Dynamics
obj.rotorsystem.check_for_non_integrable_components;
tic
figure
obj.clear_time_result()
obj.result = containers.Map('KeyType','double','ValueType','any');

for drehzahl = obj.drehzahlen
    omega = drehzahl /60 *2*pi;
    [M,C,G,K] = obj.rotorsystem.assemble_system_matrices(drehzahl);
    D = C + omega*G;
    
    x0 = zeros(length(M),1);
    dotx0=zeros(length(M),1);
    t=obj.time;
    
    %NEWMARK Newmark scheme (beta = 1/4, gamma = 1/2)
    %   Mass M, damping C, stiffness K , excitation F (vector), time vector t, initial condition x0
    h = t(2)-t(1);      % time step size
    
    % integration parameters
    % here: Average constant acceleration scheme -> unconditionally stable
    beta = 1/4;
    gamma = 1/2;
    
    S = M + h*gamma*D + h^2*beta*K;
    
    R = chol(S);
    
    x(:,1) = x0;
    xtemp = x0;
    xd(:,1) = dotx0;
    dotxtemp = dotx0;
    Z = [x; dotxtemp];
    F = obj.rotorsystem.assemble_system_loads(t(1),Z);
    ddotxtemp = M\(-D*dotxtemp - K*xtemp + F);
    xdd(:,1) = ddotxtemp;
    
    for iter = 2:length(t)
        Z = [xtemp; dotxtemp];
        
        % controller-specific, set the new controller force
        for cntr = obj.rotorsystem.pidControllers
            [displacementCntrNode, ~] = obj.rotorsystem.find_state_vector(cntr.position, Z);
            cntr.get_controller_force(t(iter),displacementCntrNode);
        end
        
        F_loads = obj.rotorsystem.assemble_system_loads(t(iter),Z);
        F_controllers = obj.rotorsystem.assemble_system_controller_forces();
        F = F_loads + F_controllers;
        
        % prediction
        xtemp     = xtemp + h*dotxtemp + (1/2-beta)*h^2*ddotxtemp;
        dotxtemp  = dotxtemp + (1-gamma)*h*ddotxtemp;
        
        % acceleration computing
        ddotxtemp = R\(R'\(-D*dotxtemp - K*xtemp + F));
        
        % correction
        dotxtemp = dotxtemp + h*gamma*ddotxtemp;
        xtemp    = xtemp + h^2*beta*ddotxtemp;
        
        x(:,iter) = xtemp;
        xd(:,iter) = dotxtemp;
        xdd(:,iter) = ddotxtemp;
        
        plot(x(1:6:end,iter))
        drawnow
        
        disp(['t_current = ',num2str(t(iter))])

    end
    res.X = x(1:end,:);
    res.X_d = xd(1:end,:);
    res.X_dd = xdd(1:end,:);
    res.F = obj.calculate_force_load_post_sensor(res.X,res.X_d);
    res.Fcontroller = obj.calculate_controller_force(res.X,res.X_d);
    
    obj.result(drehzahl)=res;
    
    toc
end

end