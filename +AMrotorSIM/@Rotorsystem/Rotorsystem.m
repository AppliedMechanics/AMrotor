classdef Rotorsystem < handle
% ROTORSYSTEM - Grundklasse für ein Physikalisches Rotorsystem.
%  R=ROTORSYSTEM(cnfg,'System');
%
%   See also ROTOR.

   properties
      name
      
      systemmatrices % wieder hinzugefuegt, damit die Zeitintegration erst einmal funktioniert. fuer speichern der systemloads
      
      cnfg=struct([])
      
      rotor@AMrotorSIM.Rotor.FEMRotor.FeModel
      discs@AMrotorSIM.Disc vector
      sensors@AMrotorSIM.Sensors.Sensor vector
      bearings@AMrotorSIM.Bearings.Bearing vector
      loads@AMrotorSIM.Loads.Load vector
      seals@AMrotorSIM.Seals.Seal vector
      sealsNonLinear@AMrotorSIM.SealsNonLinear.SealNonLinear vector

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
   
end