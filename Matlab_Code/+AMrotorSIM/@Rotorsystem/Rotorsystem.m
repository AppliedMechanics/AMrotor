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
        for i=obj.lager
            [matrices.m,matrices.g,matrices.d,matrices.k]=i.compute_matrices();
            [Ml,Gl,Dl,Kl]=assembling_matrices(i.cnfg.position,matrices,obj.rotor);
            M=M+Ml; G=G+Gl; D=D+Dl; K=K+Kl;
        end
        for i=obj.discs
            [matrices.m,matrices.g,matrices.d,matrices.k]=i.compute_matrices();
            [Ml,Gl,Dl,Kl]=assembling_matrices(i.cnfg.position,matrices,obj.rotor);
            M=M+Ml; G=G+Gl; D=D+Dl; K=K+Kl;
        end
        
      obj.systemmatrizen.M=M; obj.systemmatrizen.G=G; obj.systemmatrizen.D=D; obj.systemmatrizen.K=K;
      
      obj.reduktionsmatrizen.EVmr = eye(size(M));
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
          end 
      end
      
      % Lager
      function add_Bearing(obj,arg)
          switch arg.type
              case 1
                obj.lager(end+1) = AMrotorSIM.Bearings.SimpleLager(arg); 
              case 2
                obj.lager(end+1) = AMrotorSIM.Bearings.SimpleMagneticBearing(arg);
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