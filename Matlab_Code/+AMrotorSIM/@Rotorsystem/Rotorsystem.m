classdef Rotorsystem < handle
% ROTORSYSTEM - Grundklasse für ein Physikalisches Rotorsystem.
%  R=ROTORSYSTEM(cnfg,'System');
%
%   See also ROTOR.

   properties
      name
      systemmatrices
      reduktionsmatrizen
      
      cnfg=struct([])
      
      rotor@AMrotorSIM.Rotor.FEMRotor.FeModel
      discs@AMrotorSIM.Disc vector
      sensors@AMrotorSIM.Sensors.Sensor vector
      bearings@AMrotorSIM.Bearings.Bearing vector
      loads@AMrotorSIM.Loads.Load vector
      seals@AMrotorSIM.Seals.Seal vector

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
         obj.sensors(end+1) = AMrotorSIM.Sensors.(arg.type)(arg);
      end
      
      % Lager
      function add_Bearing(obj,arg)
          obj.bearings(end+1) = AMrotorSIM.Bearings.(arg.type)(arg);
      end
      % Loads
      function add_Load(obj,arg)
          obj.loads(end+1) = AMrotorSIM.Loads.(arg.type)(arg);
      end
      % Dichtung
      function add_Seal(obj,arg)
          obj.seals(end+1) = AMrotorSIM.Seals.(arg.type)(arg);
      end

   end
   
end