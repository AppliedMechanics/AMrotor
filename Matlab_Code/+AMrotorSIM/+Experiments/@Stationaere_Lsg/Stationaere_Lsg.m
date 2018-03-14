classdef Stationaere_Lsg < handle
   properties
      name='Stationäre Lösung'
      rotorsystem
      drehzahlen
      time        % time steps [S]      
      result
   end
   methods
       %Konstruktor
       function obj = Stationaere_Lsg(a,drehzahlvektor,time)
         if nargin == 0
           disp('Keine Lösung möglich ohne Rotorsystem')
         else
           obj.rotorsystem = a;
           obj.drehzahlen = drehzahlvektor;
           obj.time = time;
         end
       end
      
      function show(obj)
         disp(obj.name);
      end
      
     function compute_ode15s_ss(obj)
        
        Timer = AMrotorTools.Timer();
         
        disp('Compute.... ode15s State Space ....')
        obj.rotorsystem.clear_time_result()
        
        obj.result = containers.Map('KeyType','double','ValueType','any');
       for drehzahl = obj.drehzahlen 
        disp(['... rotational speed: ',num2str(drehzahl),' U/min'])
        n_nodes = length(obj.rotorsystem.rotor.nodes);
        
        omega = drehzahl*pi/30;           
        
        ss = obj.rotorsystem.systemmatrizen.ss;
        ss_G = obj.rotorsystem.systemmatrizen.ss_G;
        ss_h = obj.rotorsystem.systemmatrizen.ss_h;
        
        ss=ss+[ss_G*omega,zeros(length(ss_G),length(ss)-length(ss_G));zeros(length(ss)-length(ss_G),length(ss_G)+length(ss)-length(ss_G))];
        
        %init Vector
        Z0 = zeros(length(ss),1);
        Z0(4*n_nodes+2:2:8*n_nodes) = omega;
        Z0(8*n_nodes+2)=omega;
        
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
                     options,ss,ss_h,...
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
     
   end
   methods(Access=private)
       
   end
end