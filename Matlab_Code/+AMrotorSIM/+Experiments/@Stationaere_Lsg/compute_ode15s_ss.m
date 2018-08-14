     function compute_ode15s_ss(obj)
        
        Timer = AMrotorTools.Timer();
         
        disp('Compute.... ode15s State Space ....')
        obj.rotorsystem.clear_time_result()
        
        obj.result = containers.Map('KeyType','double','ValueType','any');
       for drehzahl = obj.drehzahlen 
        disp(['... rotational speed: ',num2str(drehzahl),' U/min'])
        n_nodes = length(obj.rotorsystem.rotor.mesh.nodes);
        
        omega = drehzahl*pi/30;           
        
        ss_A = obj.rotorsystem.systemmatrices.ss_A;
        ss_B = obj.rotorsystem.systemmatrices.ss_B;
        ss_G = obj.rotorsystem.systemmatrices.ss_AG;
        ss_h = obj.rotorsystem.systemmatrices.ss_h;
        
        ss_A=ss_A+ss_G*omega;
        
        %init Vector
        Z0 = zeros(length(ss_A),1);
        for node = 1:n_nodes
            dof_xi_z = obj.rotorsystem.rotor.get_gdof('xi_z',node);
            Z0(dof_xi_z+size(ss_A,1)/2) = omega; %Alle Positionen der xi_z Koordinaten mit omega auffüllen
        %Z0(8*n_nodes+2)=omega;
        end
        % solver parameters
        omega_rot_const_force = 0;     %[1/s] angular velocity of constant_rotating_force 
        options = odeset('AbsTol', 1e-6, 'RelTol', 1e-6); %'OutputFcn','odeprint' as option to display steps
%        if (exist('verbose','var'))
%            if verbose == 1
            %options = odeset('OutputFcn','odeprint', 'OutputSel',1);
            options = odeset('OutputFcn','odeplot','OutputSel',[1:length(Z0)]); 
%            end
%        end

        Timer.restart();
        disp('... integration started...')
        
        sol = ode15s(@integrate_function,obj.time,Z0,...
                     options,ss_A,ss_B,ss_h,...
                     n_nodes,omega_rot_const_force,obj.rotorsystem);
                 
        disp(['... spent time for integration: ',num2str(Timer.getWallTime()),' s'])

        [Z,Zp] = deval(sol,obj.time);
        
        res.X = Z(1:4*n_nodes,:);
        res.X_d = Z(4*n_nodes+1:2*4*n_nodes,:);
        res.X_dd= Zp(4*n_nodes+1:2*4*n_nodes,:);
        
        res.Phi = Z(8*n_nodes+1,:);
        res.Phi_d = Z(8*n_nodes+2,:);
        
        obj.result(drehzahl)=res;
        
       end
       obj.rotorsystem.time_result=obj.result;
     end