classdef Rotorsystem < handle
% Rotorsystem is the basis class for a rotor system.
%  R=ROTORSYSTEM(cnfg,'System');
%   :param c: cnfg-struct from seperat Config script
%   :type c: matlab struct
%   :param name: project name
%   :type name: string
%   :return: rotorsystem object

   properties
      name % name of the rotorsystem
      
      % systemmatrices - save the system matrices
      systemmatrices % in ursprünglicher Form obsolet, wieder hinzugefuegt, damit die Zeitintegration erst einmal funktioniert. fuer speichern der systemloads
      
      cnfg=struct([]) % configure struct, typically created in seperate Config _ script
      
      % See also AMrotorSIM.Rotor.FEMRotor.FeModel
      %
      % rotor - includes the rotor with its fe model
      rotor (1,1) AMrotorSIM.Rotor.FEMRotor.FeModel 
      
      % See also AMrotorSIM.Sensors
      sensors (1,:) AMrotorSIM.Sensors.Sensor
      % See also AMrotorSIM.Loads
      loads (1,:) AMrotorSIM.Loads.Load
      % See also AMrotorSIM.Components.Component
      components (1,:) AMrotorSIM.Components.Component
      % See also AMrotorSIM.pidControllers.pidController
      pidControllers (1,:) AMrotorSIM.pidControllers.pidController
      % See also AMrotorSIM.activeMagneticBearing
      activeMagneticBearings (1,:) AMrotorSIM.ActiveMagneticBearing

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