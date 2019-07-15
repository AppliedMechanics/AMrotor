classdef Rotorsystem < handle
% Rotorsystem Basis class for a rotor system.
%   R=ROTORSYSTEM(cnfg,'System');
%
%   See also AMrotorSIM.Experiments, AMrotorSIM.Graphs, AMrotorSIM.Dataoutput, AMrotorTools.

   properties
      name % name of the rotorsystem
      
      % systemmatrices - save the system matrices
      systemmatrices % in ursprünglicher Form obsolet, wieder hinzugefuegt, damit die Zeitintegration erst einmal funktioniert. fuer speichern der systemloads
      
      cnfg=struct([]) % configure struct, typically created in seperate Config_ script
      
      % See also AMrotorSIM.Rotor.FEMRotor.FeModel
      %
      % rotor - includes the rotor with its fe model
      rotor@AMrotorSIM.Rotor.FEMRotor.FeModel 
      
      % See also AMrotorSIM.Sensors
      sensors@AMrotorSIM.Sensors.Sensor vector
      % See also AMrotorSIM.Loads
      loads@AMrotorSIM.Loads.Load vector
      % See also AMrotorSIM.Components.Component
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