     function compute_ode15s_ss_variant(obj)
        
        Timer = AMrotorTools.Timer();
         
        disp('Compute.... ode15s State Space ....')
        obj.rotorsystem.check_for_non_integrable_components;
        obj.clear_time_result()
        
        obj.result = containers.Map('KeyType','double','ValueType','any');

        
       for rpm = obj.drehzahlen 
        disp(['... rotational speed: ',num2str(rpm),' U/min'])
        
        n_nodes = length(obj.rotorsystem.rotor.mesh.nodes);
        
        Omega = rpm*pi/30;           
        
        [mat.A,mat.B] = obj.get_state_space_matrices_variant(Omega);        
        
        %%init Vector
        ndof = length(mat.A)/2;
        Z0 = zeros(2*ndof,1);     % Mit null belegen:
        Z0(1*ndof+6:6:2*ndof)=Omega;        % Drehzahl fuer psi_z
        
        
        % solver parameters
        options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5,'OutputFcn',@odeOutputFcn_plotBeam,'MaxStep',obj.time(2)-obj.time(1));
        %options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5); % ohne live-plot

        Timer.restart();
        disp('... integration started...')
       
        if isempty(obj.rotorsystem.pidControllers)
            sol = ode15s(@integrate_function_variant,obj.time,Z0, options, Omega, obj.rotorsystem, mat);
            [Z,Zp] = deval(sol,obj.time);
            
        else
            % check controller frequency
            controllerFrequency = [obj.rotorsystem.pidControllers.controllerFrequency];
            if ~all((controllerFrequency-controllerFrequency(1))==0)
                error('all controllers must have the same frequency')
            end
            controllerFrequency = controllerFrequency(1); % all controller have the same freq
            
            tVecController = obj.time(1):1/controllerFrequency:obj.time(end);
            
            Z = zeros(length(obj.rotorsystem.rotor.mass_matrix)*2, length(obj.time)); % initialize
            Zp = Z;
            for iTStep = 1:(length(tVecController)-1)
                
                tspanCurr = [tVecController(iTStep), tVecController(iTStep+1)];
                %sol(iTStep) = ode45(@integrate_function_variant,tspanCurr,Z0,options, Omega, obj.rotorsystem, mat);
                sol(iTStep) = ode15s(@integrate_function_variant,tspanCurr,Z0,options, Omega, obj.rotorsystem, mat);
                
                Z0 = sol(iTStep).y(:,end); % last value of the current integration is start value for next integration
                
                for cntr = obj.rotorsystem.pidControllers
                    [displacementCntrNode, ~] = obj.rotorsystem.find_state_vector(cntr.position, Z0);
                    cntr.get_controller_force(sol(iTStep).x(end),displacementCntrNode); % set the new controller force
                end
            end
            
            for iTStep = 1:(length(tVecController)-1)
                % deval the solution after every controller-step
                tspanCurr = [tVecController(iTStep), tVecController(iTStep+1)];
                indexTime = find( (obj.time>=tspanCurr(1)) .* (obj.time<tspanCurr(end)) );
                timeTmp = obj.time(indexTime);
                [ZTmp,ZpTmp] = deval(sol(iTStep),timeTmp);
                Z(:,indexTime) = ZTmp;
                Zp(:,indexTime) = ZpTmp;
            end
            %letzter Schritt
            [ZTmp,ZpTmp] = deval(sol(end),obj.time(end));
            Z(:,end) = ZTmp;
            Zp(:,end) = ZpTmp;
            
        end
        
        
        disp(['... spent time for integration: ',num2str(Timer.getWallTime()),' s'])

        
        res.X = Z(1:6*n_nodes,:);
        res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:);
        res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:);
        
        % Kraftberechnung
        h_ges = zeros(2*size(res.X,1),size(res.X,2));
        if any(strcmp({obj.rotorsystem.sensors.type},'ForceLoadPostSensor'))
            for k = 1:length(obj.time)
                h_ges(:,k) = obj.rotorsystem.compute_system_load_variant(obj.time(k), [res.X(:,k); res.X_d(:,k)]);
            end
            res.F = h_ges(end/2+1:end,:);
        end
        
        obj.result(rpm)=res;
        
       end

     end