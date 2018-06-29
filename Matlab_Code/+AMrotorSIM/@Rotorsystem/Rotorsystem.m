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
      
      rotor = AMrotorSIM.Rotor.FEMRotor.FeModel().empty
      discs = AMrotorSIM.Disc().empty
      sensors = AMrotorSIM.Sensors.Sensor().empty
      lager = AMrotorSIM.Bearings.Lager().empty
      loads = AMrotorSIM.Loads.Load().empty
      
      time_result
   end
   %%
   methods
       %Konstruktor
       function obj = Rotorsystem(c,name)
         if nargin == 0
           obj.name = 'Netter Rotorsystem Name';
         else
           obj.cnfg = c;
           obj.name = name;
         end
          %
       end

   end
   %%
   methods(Access=private)
      % Rotor
      function add_FEMRotor(obj,arg)
         obj.rotor = AMrotorSIM.Rotor.FEMRotor.FeModel(arg); 
      end
      
      function add_Rotor(obj,arg)
          obj.rotor = AMrotorSIM.Rotor.Rotor(arg);
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

   end
   
end