classdef Stationaere_Lsg < handle
   properties
      name='Stationäre Lösung'
      rotorsystem
      drehzahl
      time        % time steps [S]      
      result
   end
   methods
       %Konstruktor
       function obj = Stationaere_Lsg(a,drehzahl,time)
         if nargin == 0
           disp('Keine Lösung möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
           obj.drehzahl = drehzahl;
           obj.time = time;
         end
       end
      
      function show(obj)
         disp(obj.name);
      end
      
      function compute(obj)
          disp('Compute.... ode15 ....')
        obj.rotorsystem.clear_time_result()  
      for drehzahl = obj.drehzahl  
        method = 0;             %% 0 == stationär;  1 == instationär
        omega = drehzahl*pi/60;           
        domega = 0;                         %domega_ode  [rad/s^2]
        
        M = obj.rotorsystem.systemmatrizen.M;
        G = obj.rotorsystem.systemmatrizen.G;
        D = obj.rotorsystem.systemmatrizen.D;
        K = obj.rotorsystem.systemmatrizen.K;
        h = obj.rotorsystem.systemmatrizen.h;

        EVmr = obj.rotorsystem.reduktionsmatrizen.EVmr;
        
        Z0 = cumpute_Z0_rotor(M,0, omega,domega,method); %init vector
        % solver parameters
        omega_rot_const_force = 0;     %[1/s] angular velocity of constant_rotating_force 
        options = odeset('AbsTol', 1e-6, 'RelTol', 1e-6); %'OutputFcn','odeprint' as option to display steps
        if (exist('verbose','var'))
            if verbose == 1
            options = odeset('OutputFcn','odeprint', 'OutputSel',1);
            end
        end

        [obj.result.T,Z] = ode15s(@rotor_sys_function,obj.time,Z0,options,K,M,D,G,h,omega_rot_const_force,method);
        
        [obj.result.X,obj.result.X_d,x,x_d,beta,beta_d,y,y_d,alpha,alpha_d,omega_ode,phi_ode] = modal_back_transformation(Z,M,EVmr);
        
        obj.rotorsystem.time_result = obj.result;
      end
      end
      
      function compute_newmark(obj)
        disp('Compute.... newmark ....')
        obj.rotorsystem.clear_time_result() 
        for drehzahl = obj.drehzahl
            M = obj.rotorsystem.systemmatrizen.M;
            D = obj.rotorsystem.systemmatrizen.G+obj.rotorsystem.systemmatrizen.D;
            K = obj.rotorsystem.systemmatrizen.K;
        
         h = obj.rotorsystem.systemmatrizen.h;
            % Berechnung von Lastvektor für jeden Zeitschritt:
        
            omega = obj.drehzahl*pi/60;           
            domega = 0;                         %domega_ode  [rad/s^2]
            omega_rot_const_force=0;
            t=obj.time;
        
            phi=omega*t;
        
            h_ges = (h.h +(h.h_ZPsin.*(omega^2) + h.h_DBsin.*domega +h.h_sin).*(-1)*sin(phi) ...
              +(h.h_ZPcos.*(omega^2) + h.h_DBcos.*domega +h.h_cos).*(-1)*cos(phi)) ...
              + h.h_rotsin.*sin(phi*omega_rot_const_force) + h.h_rotcos.*cos(phi*omega_rot_const_force); %+Dichtung+Lager

            %f=zeros(length(M),length(t));
            f=h_ges;
        
            q_0=zeros(length(M),1);
            qd_0=zeros(length(M),1);
            qdd_0=zeros(length(M),1);
        
            beta=0.25;
            gamma=0.5;
        
            constant = 1;
        
            nwmrk = AMrotorSIM.Solvers.Newmark();
        
            [q,qd,qdd] = nwmrk.newmark_integration( beta , gamma, M, D, K,f,t,q_0,qd_0,qdd_0,constant);

            obj.rotorsystem.time_result.T= obj.time';
        
            EVmr = obj.rotorsystem.reduktionsmatrizen.EVmr;
            Z=[q;qd]';
        
          [obj.rotorsystem.time_result.X,obj.rotorsystem.time_result.X_d,x,x_d,beta,beta_d,y,y_d,alpha,alpha_d,omega_ode,phi_ode] = modal_back_transformation(Z,M,EVmr);
        end
      end
     function compute_ode15s_ss(obj)
        disp('Compute.... ode15s State Space ....')
        obj.rotorsystem.clear_time_result()
        values = {};
        j = 1;
       for drehzahl = obj.drehzahl 
        disp(['... rotational speed: ',num2str(drehzahl),' U/min'])
        n_nodes = length(obj.rotorsystem.rotor.nodes);
        
        omega = drehzahl*pi/60;           
        
        ss = obj.rotorsystem.systemmatrizen.ss;
        ss_G = obj.rotorsystem.systemmatrizen.ss_G;
        ss_h = obj.rotorsystem.systemmatrizen.ss_h;
        
        ss=ss+[ss_G*omega,zeros(length(ss_G),length(ss)-length(ss_G));zeros(length(ss)-length(ss_G),length(ss_G)+length(ss)-length(ss_G))];
        
        %init Vector
        Z0 = zeros(length(ss),1);
        Z0(8*n_nodes+2)=omega;
        
        % solver parameters
        omega_rot_const_force = 0;     %[1/s] angular velocity of constant_rotating_force 
        options = odeset('AbsTol', 1e-6, 'RelTol', 1e-6); %'OutputFcn','odeprint' as option to display steps
        if (exist('verbose','var'))
            if verbose == 1
            options = odeset('OutputFcn','odeprint', 'OutputSel',1);
            end
        end

%        [obj.rotorsystem.time_result.T,Z] = ode15s(@integrate_function,obj.time,Z0,options,ss,ss_h,n_nodes,omega_rot_const_force,obj.rotorsystem);
        sol = ode15s(@integrate_function,obj.time,Z0,options,ss,ss_h,n_nodes,omega_rot_const_force,obj.rotorsystem);

        [Z,Zp] = deval(sol,obj.time);
        
        obj.rotorsystem.time_result.X = Z(1:4*n_nodes,:);
        obj.rotorsystem.time_result.X_d = Z(4*n_nodes+1:2*4*n_nodes,:);
        obj.rotorsystem.time_result.X_dd= Zp(4*n_nodes+1:2*4*n_nodes,:);
        
        obj.rotorsystem.time_result.Phi = Z(8*n_nodes+1,:);
        obj.rotorsystem.time_result.Phi_d = Z(8*n_nodes+2,:);
        
        val = { obj.rotorsystem.time_result.X, obj.rotorsystem.time_result.X_d, obj.rotorsystem.time_result.X_dd, obj.rotorsystem.time_result.Phi, obj.rotorsystem.time_result.Phi_d};
        values{j,1} = val;
        j = j+1;
       end
       obj.result = containers.Map(obj.drehzahl,values); 
       % ähnlich zu Dictionary in Python. Jeder Drehzahl wird ein X, X_d
       % und ein X_dd Array zugewiesen.
     end
     
   end
   methods(Access=private)
       
   end
end