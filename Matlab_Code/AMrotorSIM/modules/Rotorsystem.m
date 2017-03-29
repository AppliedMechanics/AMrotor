classdef Rotorsystem < handle
   properties
      name
      systemmatrizen
      rotor = Rotor().empty
      sensors = Sensor().empty
      lager = Lager().empty
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
         
         assemble_rotorsystem(obj)
       end
      
      function show(obj)
         disp(obj.name);
      end

      function compute_matrices(obj)
            [obj.systemmatrizen.M,obj.systemmatrizen.G,obj.systemmatrizen.D,obj.systemmatrizen.K]=obj.rotor.compute_matrices(); 
        for i=obj.lager
            [matrices.m,matrices.g,matrices.d,matrices.k]=i.compute_matrices();
            [M,G,D,K]=assembling_matrices(i.cnfg.position,matrices,obj.rotor);
        end
      end
      
      function reduce_modal(obj)
          disp('Reduzieren auf x Moden')
      end
      

   end
   %%
   methods(Access=private)
      % Rotor
      function add_Rotor(obj,arg)
          obj.rotor = Rotor(arg);
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
      
      % Assemble
       function assemble_rotorsystem(obj)
           % Read configfile
           Config
           
           % Adding rotor
            for i=cnfg_rotor
            obj.add_Rotor(i);
            end
            
            % Adding Sensors to Rotor
            for i=cnfg_sensor
            obj.add_Sensor(i);
            end
            
            % Adding Lager to Rotor
            for i=cnfg_lager
            obj.add_Lager(i);
            end
       end
   end
end