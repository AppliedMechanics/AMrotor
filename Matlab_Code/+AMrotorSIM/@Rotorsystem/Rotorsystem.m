classdef Rotorsystem < handle
% ROTORSYSTEM - Grundklasse für ein Physikalisches Rotorsystem.
%  R=ROTORSYSTEM(cnfg,'System');
%
%   See also ROTOR.

   properties
      name
      systemmatrizen
      reduktionsmatrizen
      
      cnfg=struct([])
      
      rotor = AMrotorSIM.Rotor().empty
      discs = AMrotorSIM.Disc().empty
      sensors = AMrotorSIM.Sensors.Sensor().empty
      lager = AMrotorSIM.Bearings.Lager().empty
      loads = AMrotorSIM.Loads.Load().empty
      
      time_result
   end
   %%
   methods
       %Konstruktor
       function obj = Rotorsystem(a,name)
         if nargin == 0
           obj.name = 'Netter Rotorsystem Name';
         else
           obj.cnfg = a;
           obj.name = name;
         end
          %
         assemble_rotorsystem(obj);
       end
      
      function show(obj)
          disp('--------------- Rotorsystem --------------')
         disp(obj.name);
        for i=obj.rotor
            i.print();
        end
         
        for i=obj.discs
            i.print();
        end

        for i=obj.lager
            i.print();
        end
            disp('----------------------------------------------')
            disp('--------------- Sensors ------------------------')
        for i=obj.sensors
            i.print();
        end
            disp('----------------------------------------------')
            disp('--------------- Loads ------------------------')
         for i=obj.loads
             i.print();
         end
            disp('----------------------------------------------')
      end

    function compute_matrices(obj)
        [M,G,D,K]=obj.rotor.compute_matrices(); 
        
        for lager = obj.lager
            [matrices.m,matrices.g,matrices.d,matrices.k]=lager.compute_matrices();
            [Ml,Gl,Dl,Kl]=assembling_matrices(lager.cnfg.position,matrices,obj.rotor);
            M=M+Ml; G=G+Gl; D=D+Dl; K=K+Kl;
        end
        
        for disc = obj.discs
            [matrices.m,matrices.g,matrices.d,matrices.k]=disc.compute_matrices();
            [Ml,Gl,Dl,Kl]=assembling_matrices(disc.cnfg.position,matrices,obj.rotor);
            M=M+Ml; G=G+Gl; D=D+Dl; K=K+Kl;
        end
        
        obj.systemmatrizen.M=sparse(M); 
        obj.systemmatrizen.G=sparse(G);
        obj.systemmatrizen.D=sparse(D);
        obj.systemmatrizen.K=sparse(K);

        obj.reduktionsmatrizen.EVmr = sparse(eye(size(M)));
        obj.reduktionsmatrizen.EWmr=0;
      
    end
      
      function compute_loads(obj) 
          
            h.h = zeros(4*length(obj.rotor.nodes),1);   

            %centripetal-force unbalance, rotating
            h.h_ZPsin = h.h;                                      
            h.h_ZPcos = h.h;   

            %unbalance mass inertia force 
            h.h_DBsin = h.h;                                 
            h.h_DBcos = h.h;


            %Constant_fix_force   e.g wight force
            h.h_sin = h.h;                     
            h.h_cos = h.h;


            %rotating_fix_force%   e.g  bearing exitation 
            h.h_rotsin = h.h;                   
            h.h_rotcos = h.h;

          
            for i=obj.loads

            i.compute_load();
            [hi]=assembling_loads(i,obj.rotor);
            
                fields = fieldnames(h);
                for j=1:numel(fields)
                    h.(fields{j})=h.(fields{j})+hi.(fields{j});
                end
            end
            
            obj.systemmatrizen.h = h;
      end 
      
     function transform_StateSpace(obj)
         
        M=obj.systemmatrizen.M; % Masse
        D=obj.systemmatrizen.D; % Dämpfung
        G=obj.systemmatrizen.G; % Gyroskopie
        K=obj.systemmatrizen.K; % Steifigkeit
        
        n_nodes=length(obj.rotor.nodes);
        dim_ss=8*n_nodes;
        
        M_inv = M\eye(size(M));
        obj.systemmatrizen.M_inv=M_inv;
        
        obj.systemmatrizen.ss = [zeros(length(M)),eye(length(M));-M_inv*K,-M_inv*D];
        obj.systemmatrizen.ss_G = [zeros(length(M)),zeros(length(M));zeros(length(M)),-M_inv*G];
        
        %Ergänze StateSpace um Zustand zur Drehzahl integration /
        %Drehmoment
        
        dim_ss1=dim_ss+2;
        
        ss_rot = [0,1;0,0];
        
        ss_temp = zeros(dim_ss1);
        ss_temp1 = zeros(dim_ss1);
        
        ss_temp1(1:8*n_nodes,1:8*n_nodes)=obj.systemmatrizen.ss_G;
        obj.systemmatrizen.ss_G=ss_temp1;
        
        ss_temp(1:dim_ss,1:dim_ss)=obj.systemmatrizen.ss;
        ss_temp(dim_ss+1:dim_ss1,dim_ss+1:dim_ss1)=ss_rot;
        obj.systemmatrizen.ss=ss_temp;
        
        %Ergänze StateSpace um Integrationsglieder aus Regelkreisen
        
        ss = obj.systemmatrizen.ss;
        
        for i=obj.lager
            if i.cnfg.type==3
            obj.systemmatrizen.ss = i.add_controller_ss(ss,3,obj);
            end
        end
        dim_ss2=length(obj.systemmatrizen.ss);
        
        %% Lastvektor in SS transformieren
        
        obj.systemmatrizen.ss_h.h = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h;zeros(dim_ss2-dim_ss,1)]; %andere h-Terme nicht vergessen!
        obj.systemmatrizen.ss_h.h_sin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_sin;zeros(dim_ss2-dim_ss,1)];
        obj.systemmatrizen.ss_h.h_cos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_cos;zeros(dim_ss2-dim_ss,1)];
        obj.systemmatrizen.ss_h.h_ZPsin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_ZPsin;zeros(dim_ss2-dim_ss,1)];
        obj.systemmatrizen.ss_h.h_ZPcos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_ZPcos;zeros(dim_ss2-dim_ss,1)];
        obj.systemmatrizen.ss_h.h_DBsin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_DBsin;zeros(dim_ss2-dim_ss,1)];
        obj.systemmatrizen.ss_h.h_DBcos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_DBcos;zeros(dim_ss2-dim_ss,1)];
        obj.systemmatrizen.ss_h.h_rotsin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_rotsin;zeros(dim_ss2-dim_ss,1)];
        obj.systemmatrizen.ss_h.h_rotcos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_rotcos;zeros(dim_ss2-dim_ss,1)];
        
        
     end
      
     [n_x,n_dx,n_y,n_dy]=find_next_node_ss(obj, z_pos);
      
      function reduce_modal(obj,number_of_modes)
          %disp('Reduzieren auf Moden: '+ number_of_modes)
          
          M=obj.systemmatrizen.M; G=obj.systemmatrizen.G; D=obj.systemmatrizen.D; K=obj.systemmatrizen.K;
          h=obj.systemmatrizen.h;
          [M,K,G,D,h,EVmr,EWmr] = compute_modal_reduction_rotor_only(M,K,G,D,h,number_of_modes,1);
          obj.systemmatrizen.M=M; obj.systemmatrizen.G=G; obj.systemmatrizen.D=D; obj.systemmatrizen.K=K;
          obj.systemmatrizen.h = h;
          
          obj.reduktionsmatrizen.EVmr = EVmr;
          obj.reduktionsmatrizen.EWmr = EWmr;
      end
      
      function clear_time_result(obj)
        obj.time_result = [];
      end
      
      function data = generate_sensor_output(obj)
          n=0;
          for i=obj.sensors  
              n=n+1;
              data(n).name=i.name;
              data(n).unit=i.unit;
              [x_pos,beta_pos,y_pos,alpha_pos]=i.read_values(obj);
              data(n).timedata=[x_pos;beta_pos;y_pos;alpha_pos];
          end
      end
      
      function sichern(obj)
        save('Rotorsystem') 
      end

   end
   %%
   methods(Access=private)
      % Rotor
      function add_Rotor(obj,arg)
          obj.rotor = AMrotorSIM.Rotor(arg);
      end
      % Disc
      function add_Disc(obj,arg)
          obj.discs = AMrotorSIM.Disc(arg);
      end
      % Sensor
      function add_Sensor(obj,arg)
          switch arg.type
              case 1
                obj.sensors(end+1) = AMrotorSIM.Sensors.Wegsensor(arg);
              case 2
                 obj.sensors(end+1) = AMrotorSIM.Sensors.Kraftsensor(arg);
              case 3
                  obj.sensors(end+1) = AMrotorSIM.Sensors.Velocitysensor(arg);
              case 4
                  obj.sensors(end+1) = AMrotorSIM.Sensors.Accelerationsensor(arg);
              otherwise
                  error('This type of sensor is not implemented yet!')
          end 
      end
      
      % Lager
      function add_Bearing(obj,arg)
          switch arg.type
              case 1
                obj.lager(end+1) = AMrotorSIM.Bearings.SimpleLager(arg); 
              case 2
                obj.lager(end+1) = AMrotorSIM.Bearings.SimpleMagneticBearing(arg);
              case 3
                obj.lager(end+1) = AMrotorSIM.Bearings.PID_MagneticBearing(arg);
              case 4
                obj.lager(end+1) = AMrotorSIM.Bearings.TwoWayLager(arg);
              otherwise
                a = dbstack;
                errorMessage = sprintf(...
                      "Das ist keine valide Auswahl fuer ein Lager!\n" + ...
                      "Fehler tritt in der Datei %s in der Zeile %1.0f auf.\n" + ...
                      "Der fehlerhafter Aufruf kommt aus %s mit Zeile %1.0f",...
                      a(1).file,a(1).line,a(2).file,a(2).line);
                error(char(errorMessage))
          end 
      end
      % Loads
      function add_Load(obj,arg)
          obj.loads(end+1) = AMrotorSIM.Loads.Unbalance_static(arg);
      end
      function add_Force(obj,arg)
          obj.loads(end+1) = AMrotorSIM.Loads.Force_constant_fix(arg);
      end
      
      % Assemble
       function assemble_rotorsystem(obj)
           
           % Adding rotor
            for i=obj.cnfg.cnfg_rotor
            obj.add_Rotor(i);
            end
            
           % Adding discs
            for i=obj.cnfg.cnfg_disc
            obj.add_Disc(i);
            end
            
            % Adding Sensors to Rotor
            for i=obj.cnfg.cnfg_sensor
            obj.add_Sensor(i);
            end
            
            % Adding Lager to Rotor
            for i=obj.cnfg.cnfg_lager
            obj.add_Bearing(i);
            end
            
            % Adding Loads to System
            for i=obj.cnfg.cnfg_unbalance
                obj.add_Load(i);
            end
            for i=obj.cnfg.cnfg_force_const_fix
                obj.add_Force(i);
            end
       end
   end
   
end