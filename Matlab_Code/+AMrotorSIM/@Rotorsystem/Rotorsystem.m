classdef Rotorsystem < handle
   properties
      name
      systemmatrizen
      reduktionsmatrizen
      rotor = Rotor().empty
      discs = Disc().empty
      sensors = Sensor().empty
      lager = Lager().empty
      loads = Load().empty
      
      time_result
   end
   %%
   methods
       %Konstruktor
       function obj = Rotorsystem(a)
         if nargin == 0
           obj.name = "Netter Rotorsystem Name";
         else
           obj.name = a;
         end
          %
         assemble_rotorsystem(obj)
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
            %UNBALANCE% centripetal-force and mass inertia force
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
          obj.rotor = Rotor(arg);
      end
      % Disc
      function add_Disc(obj,arg)
          obj.discs = Disc(arg);
      end
      % Sensor
      function add_Sensor(obj,arg)
          switch arg.type
              case 1
                obj.sensors(end+1) = Wegsensor(arg);
              case 2
                 obj.sensors(end+1) = Kraftsensor(arg);
          end 
      end
      
      % Lager
      function add_Lager(obj,arg)
          switch arg.type
              case 1
                obj.lager(end+1) = SimpleLager(arg); 
              case 2
                obj.lager(end+1) = MagnetLager(arg);
          end 
      end
      % Loads
      function add_Unbalance(obj,arg)
          obj.loads = Unbalance_static(arg);
      end
      
      % Assemble
       function assemble_rotorsystem(obj)
           % Read configfile
           Config
           
           % Adding rotor
            for i=cnfg_rotor
            obj.add_Rotor(i);
            end
            
           % Adding discs
            for i=cnfg_disc
            obj.add_Disc(i);
            end
            
            % Adding Sensors to Rotor
            for i=cnfg_sensor
            obj.add_Sensor(i);
            end
            
            % Adding Lager to Rotor
            for i=cnfg_lager
            obj.add_Lager(i);
            end
            
            % Adding Loads to System
            for i=cnfg_unbalance
                obj.add_Unbalance(i);
            end
       end
   end
end