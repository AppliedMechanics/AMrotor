% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef Rotorsystem < handle
% Rotorsystem is the basis class for a rotor system. R=ROTORSYSTEM(cnfg,'System');
%
%    :parameter c: cnfg-struct from seperat Config script
%    :type c: struct
%    :param name: project name
%    :type name: string
%    :return: rotorsystem object

   properties
      name % name of the rotorsystem
      
      % systemmatrices - save the system matrices
      systemmatrices % save the system matrices
      % in ursprünglicher Form obsolet, wieder hinzugefuegt, damit die Zeitintegration erst einmal funktioniert. fuer speichern der systemloads
      
      cnfg=struct([]) % configure struct, typically created in seperate Config _ script
      
      % See also AMrotorSIM.Rotor.FEMRotor.FeModel
      %
      % rotor - includes the rotor with its fe model
      rotor (1,1) AMrotorSIM.Rotor.FEMRotor.FeModel %includes the rotor with its fe model
      
      sensors (1,:) AMrotorSIM.Sensors.Sensor % See also AMrotorSIM.Sensors
      
      loads (1,:) AMrotorSIM.Loads.Load % See also AMrotorSIM.Loads
      
      components (1,:) AMrotorSIM.Components.Component % See also AMrotorSIM.Components.Component
      
      pidControllers (1,:) AMrotorSIM.pidControllers.pidController % See also AMrotorSIM.pidControllers.pidController
     
      activeMagneticBearings (1,:) AMrotorSIM.ActiveMagneticBearing % See also AMrotorSIM.activeMagneticBearing

   end
   %%
   methods
       %Konstruktor
       function obj = Rotorsystem(c,name)
         if nargin == 0
           obj.name = 'Nice Rotorsystem name';
         else
           obj.cnfg = c;
           obj.name = name;
         end
          %
       end

   end
   
end