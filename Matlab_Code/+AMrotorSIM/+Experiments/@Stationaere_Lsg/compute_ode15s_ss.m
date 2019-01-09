     function compute_ode15s_ss(obj)
    
        
        Timer = AMrotorTools.Timer();
         
        disp('Compute.... ode15s State Space ....')
        
        obj.check_for_non_integrable_components;
        
        obj.clear_time_result()
        
        obj.result = containers.Map('KeyType','double','ValueType','any');
        
       for drehzahl = obj.drehzahlen 
        disp(['... rotational speed: ',num2str(drehzahl),' U/min'])
        n_nodes = length(obj.rotorsystem.rotor.mesh.nodes);
        
        omega = drehzahl*pi/30;           
        
        ss_A = obj.rotorsystem.systemmatrices.ss_A;

        %% Mit null belegen:
         Z0 = zeros(length(ss_A),1);
%         for node = 1:n_nodes
%             dof_psi_z = obj.rotorsystem.rotor.get_gdof('psi_z',node);
%             Z0(dof_psi_z+size(ss_A,1)/2) = omega; %Alle Positionen der psidot_z Koordinaten mit omega auffüllen
%         end
        
        % solver parameters
        options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5,'OutputFcn',@odeOutputFcn_plotBeam);

        Timer.restart();
        disp('... integration started...')
        
        sol = ode15s(@integrate_function,obj.time,Z0, options, omega, obj.rotorsystem);
        
        disp(['... spent time for integration: ',num2str(Timer.getWallTime()),' s'])

        [Z,Zp] = deval(sol,obj.time);
        
        res.X = Z(1:6*n_nodes,:);
        res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:);
        res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:);
        
        obj.result(drehzahl)=res;
        
       end

     end