     function compute_sys_ss_variant(obj)
        obj.rotorsystem.check_for_non_integrable_components;
        Timer = AMrotorTools.Timer();
         
        disp('Compute.... ode15s State Space ....')
        obj.clear_time_result()
        
        obj.result = containers.Map('KeyType','double','ValueType','any');
        
       for drehzahl = obj.drehzahlen 
        disp(['... rotational speed: ',num2str(drehzahl),' U/min'])
        n_nodes = length(obj.rotorsystem.rotor.mesh.nodes);
        
        omega = drehzahl*pi/30;           
        
        A = obj.rotorsystem.systemmatrices.ss.A;
        AG = obj.rotorsystem.systemmatrices.ss.AG;
        B = obj.rotorsystem.systemmatrices.ss.B;
        C = obj.rotorsystem.systemmatrices.ss.C;
        D = obj.rotorsystem.systemmatrices.ss.D;
        
        
        Timer.restart();
        disp('... integration started...')
        
        u=sparse(zeros(length(obj.time),2040));
        u(10:length(obj.time),1021)=10;
        
        sys=ss(A,B,C,D);
        Z = lsim(sys,u,obj.time);
        
        res.X = Z(:,1:6*n_nodes)';
        res.X_d = Z(:,6*n_nodes+1:2*6*n_nodes)';
        
        obj.result(drehzahl)=res;
        
       end

     end