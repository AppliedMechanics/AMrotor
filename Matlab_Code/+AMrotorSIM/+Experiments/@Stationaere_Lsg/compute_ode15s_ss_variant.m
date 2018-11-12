     function compute_ode15s_ss_variant(obj)
        
        Timer = AMrotorTools.Timer();
         
        disp('Compute.... ode15s State Space ....')
        obj.clear_time_result()
        
        obj.result = containers.Map('KeyType','double','ValueType','any');
        
%         M_without_seal = obj.rotorsystem.systemmatrices.M;
%         D_without_seal = obj.rotorsystem.systemmatrices.D;
%         K_without_seal = obj.rotorsystem.systemmatrices.K;
        
       for rpm = obj.drehzahlen 
        disp(['... rotational speed: ',num2str(rpm),' U/min'])
        
%         % Funktion oder Methode einfuehren, um Systemmatrizen neu zu
%         % berechnen
%         M = M_without_seal;
%         D = D_without_seal;
%         K = K_without_seal;
%         %==================================================================
%         % Seal coefficients dependent on rotational speed
%         n_nodes=length(obj.rotorsystem.rotor.mesh.nodes);
%         M_seal = sparse(6*n_nodes,6*n_nodes);
%         D_seal = sparse(6*n_nodes,6*n_nodes);
%         K_seal = sparse(6*n_nodes,6*n_nodes);
%            for seal = obj.rotorsystem.seals 
%                 seal.create_ele_loc_matrix;
%                 seal.get_loc_system_matrices(rpm);
% 
%                 seal_node = obj.rotorsystem.rotor.find_node_nr(seal.position);
%                 L_ele = sparse(6,6*n_nodes);
%                 L_ele(1:6,(seal_node-1)*6+1:(seal_node-1)*6+6)=seal.localisation_matrix;
%                 %L_ele = sparse(1:6, (seal_node-1)*6+1:(seal_node-1)*6+6, ones(6,1), 6, 6*n_nodes); % added because of warning of Matlab Code Analyzer but not actually faster
% 
%                 M_seal = M_seal+L_ele'*seal.mass_matrix*L_ele;
%                 K_seal = K_seal+L_ele'*seal.stiffness_matrix*L_ele;
%                 D_seal = D_seal+L_ele'*seal.damping_matrix*L_ele;
%                 
%                 M = M + M_seal;
%                 D = D + D_seal;
%                 K = K + K_seal;
%            end
%         %==================================================================
%         
%         [M,C,G,K]= obj.rotorsystem.assemble_system_matrices(rpm);
%         M_inv = inv(M);
%         D = C;
%         G = rpm/60*2*pi * G;
% 
% 
%         obj.rotorsystem.systemmatrices.M = M; % because transform_StateSpace uses the matrices in the obj-form
%         obj.rotorsystem.systemmatrices.M_inv = M_inv;
%         obj.rotorsystem.systemmatrices.D = D;
%         obj.rotorsystem.systemmatrices.G = G;
%         obj.rotorsystem.systemmatrices.K = K;
% %         obj.rotorsystem.transform_StateSpace; 
%         obj.rotorsystem.transform_StateSpace_variant; % recalculation because of seal
%         obj.rotorsystem.transform_StateSpace_AG_variant(rpm); % recalculation of A_G
        
        n_nodes = length(obj.rotorsystem.rotor.mesh.nodes);
        
        Omega = rpm*pi/30;           
        
        [mat.A,mat.B] = obj.get_state_space_matrices_variant(Omega);
        
%         ss_A = obj.rotorsystem.systemmatrices.ss.A;
        
        %%init Vector
        
        Z0 = zeros(length(mat.A),1);     % Mit null belegen:
        Z0(end/2+6:6:end)=Omega;        % Drehzahl fuer psi_z
         
         
        % solver parameters
        options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5,'OutputFcn',@odeOutputFcn_plotBeam);
%         options = odeset('AbsTol', 1e-5, 'RelTol', 1e-5); % ohne live-plot

        Timer.restart();
        disp('... integration started...')
        %fprintf('           '),pause(0.01), %Initialisierung Anzeige t
       
        
        sol = ode15s(@integrate_function_variant,obj.time,Z0, options, Omega, obj.rotorsystem, mat);
        
        disp(['... spent time for integration: ',num2str(Timer.getWallTime()),' s'])

        [Z,Zp] = deval(sol,obj.time);
        
        res.X = Z(1:6*n_nodes,:);
        res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:);
        res.X_dd= Zp(6*n_nodes+1:2*6*n_nodes,:);
        
        obj.result(rpm)=res;
        
       end

     end