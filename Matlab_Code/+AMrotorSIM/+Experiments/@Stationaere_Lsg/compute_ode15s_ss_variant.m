     function compute_ode15s_ss_variant(obj)
        
        Timer = AMrotorTools.Timer();
         
        disp('Compute.... ode15s State Space ....')
        obj.clear_time_result()
        
        obj.result = containers.Map('KeyType','double','ValueType','any');
        
       for drehzahl = obj.drehzahlen 
        disp(['... rotational speed: ',num2str(drehzahl),' U/min'])
        
        %==================================================================
        % Dichtungskoeffizienten sind abhaengig von der Drehzahl
        n_nodes=length(obj.rotorsystem.rotor.mesh.nodes);
        M_seal = sparse(6*n_nodes,6*n_nodes);
        D_seal = sparse(6*n_nodes,6*n_nodes);
        K_seal = sparse(6*n_nodes,6*n_nodes);
           for seal = obj.rotorsystem.seals 
                seal.create_ele_loc_matrix;
                seal.get_loc_system_matrices(drehzahl);

                seal_node = obj.rotorsystem.rotor.find_node_nr(seal.position);
                L_ele = sparse(6,6*n_nodes);
                L_ele(1:6,(seal_node-1)*6+1:(seal_node-1)*6+6)=seal.localisation_matrix;

                M_seal = M_seal+L_ele'*seal.mass_matrix*L_ele;
                K_seal = K_seal+L_ele'*seal.stiffness_matrix*L_ele;
                D_seal = D_seal+L_ele'*seal.damping_matrix*L_ele;
            end
        %==================================================================

        n_nodes = length(obj.rotorsystem.rotor.mesh.nodes);
        
        omega = drehzahl*pi/30;           
        
        ss_A = obj.rotorsystem.systemmatrices.ss.A;
        
        %%init Vector
        
        Z0 = zeros(length(ss_A),1);     % Mit null belegen:
        Z0(end/2+6:6:end)=omega;        % Drehzahl für psi_z
         
         
        % solver parameters
        options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5,'OutputFcn',@odeOutputFcn_plotBeam);
%         options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5); % ohne live-plot

        Timer.restart();
        disp('... integration started...')
        fprintf('           '),pause(0.01), %Initialisierung Anzeige t
       
        sol = ode15s(@integrate_function_variant,obj.time,Z0, options, omega, obj.rotorsystem);
        
        disp(['... spent time for integration: ',num2str(Timer.getWallTime()),' s'])

        [Z,Zp] = deval(sol,obj.time);
        
        res.X = Z(1:6*n_nodes,:);
        res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:);
        res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:);
        
        obj.result(drehzahl)=res;
        
       end

     end