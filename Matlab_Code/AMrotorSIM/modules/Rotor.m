classdef Rotor < handle
   properties
      name
      sensors=Sensor().empty
      lager=Lager().empty
   end
   methods
       %Konstruktor
       function obj = Rotor(a)
         if nargin == 0
           obj.name = "Default Rotor";
         else
           obj.name = a;
         end
       end
      
      function show_Rotor(obj)
         disp(obj.name);
      end

      %% Sensor
      function add_Sensor(obj,arg)
          switch arg.type
              case 1
                obj.sensors(end+1) = Wegsensor(arg);
              case 2
                 obj.sensors(end+1) = Kraftsensor(arg);
          end 
      end
      
      %% Lager
      function add_Lager(obj,arg)
          switch arg.type
              case 1
                obj.lager(end+1) = SimpleLager(arg);
              case 2
                 obj.lager(end+1) = MagnetLager(arg);
          end 
      end
   end
end