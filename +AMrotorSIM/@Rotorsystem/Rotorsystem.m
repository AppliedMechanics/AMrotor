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
      sensors@AMrotorSIM.Sensors.Sensor vector
      loads@AMrotorSIM.Loads.Load vector
      components@AMrotorSIM.Components.Component vector

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