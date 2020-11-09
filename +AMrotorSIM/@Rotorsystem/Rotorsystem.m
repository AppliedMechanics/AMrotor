classdef Rotorsystem < handle
% Rotorsystem is the basis class for a rotor system. 

% R=ROTORSYSTEM(cnfg,'System');
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

   properties      
      name 
      systemmatrices
      cnfg=struct([])
      rotor (1,1) AMrotorSIM.Rotor.FEMRotor.FeModel 
      sensors (1,:) AMrotorSIM.Sensors.Sensor 
      loads (1,:) AMrotorSIM.Loads.Load
      components (1,:) AMrotorSIM.Components.Component 
      pidControllers (1,:) AMrotorSIM.pidControllers.pidController 
      activeMagneticBearings (1,:) AMrotorSIM.ActiveMagneticBearing 

   end
   %%
   methods
       function obj = Rotorsystem(c,name)
           % Constructor
%
%    :parameter c: Cnfg-struct from separat Config-script
%    :type c: struct
%    :param name: Project name
%    :type name: string
%    :return: Rotorsystem object

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