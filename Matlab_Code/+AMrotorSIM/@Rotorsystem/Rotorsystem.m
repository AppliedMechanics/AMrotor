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
      
      rotor = AMrotorSIM.Rotor.Rotor().empty
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
      


   end
   %%
   methods(Access=private)
      % Rotor
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