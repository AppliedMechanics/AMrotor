classdef Stationaere_Lsg < handle
   properties
      name='Stationäre Lösung'
      rotorsystem = Rotorsystem().empty
      drehzahl
      time = 0:1e-4:2;        % time steps [S]
      
      result
   end
   methods
       %Konstruktor
       function obj = Stationaere_Lsg(a,drehzahl)
         if nargin == 0
           disp('Keine Lösung möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
           obj.drehzahl = drehzahl;
         end
         addpath(strcat(fileparts(which(mfilename)),'\fcns'));
       end
      
      function show(obj)
         disp(obj.name);
      end
      
      function r=compute(obj)
         method = 0;             %% 0 == stationär;  1 == instationär

        domega = obj.drehzahl*pi/60;           %domega_ode  [rad/s^2]

        M = obj.rotorsystem.systemmatrizen.M;
        G = obj.rotorsystem.systemmatrizen.G;
        D = obj.rotorsystem.systemmatrizen.D;
        K = obj.rotorsystem.systemmatrizen.K;
        h = obj.rotorsystem.systemmatrizen.h;

        EVmr = obj.rotorsystem.reduktionsmatrizen.EVmr;
        
        Z0 = cumpute_Z0_rotor(M,0, 0,domega,method); %init vector
        % solver parameters
        omega_rot_const_force = 0;     %[1/s] angular velocity of constant_rotating_force 
        options = odeset('AbsTol', 1e-6, 'RelTol', 1e-6, 'OutputFcn','odeprint','OutputSel',1);
        % ODE function

        [T,Z] = ode15s(@rotor_sys_function,obj.time,Z0,options,K,M,D,G,h,omega_rot_const_force,method);
        
        [obj.result.X,obj.result.X_d,x,x_d,beta,beta_d,y,y_d,alpha,alpha_d,omega_ode,phi_ode] = modal_back_transformation(Z,M,EVmr);
        
        r= obj.result;
      end
 
   end
   methods(Access=private)
       
   end
end