classdef Eigenschwingformen < handle
   properties
      name='Rotor Eigenschwingformen'
      modalsystem
   end
   methods
       %Konstruktor
       function obj = Eigenschwingformen(a)
         if nargin == 0
           disp('Kein Visualierung möglich ohne Modalsystem')
         else
           obj.modalsystem = a;
         end
       end
      
      function plot(obj)
          rotorpar=obj.rotorsystem.rotor.cnfg;
          
          plot_EV_EW(rotorpar,AevR,Aew,nodes,omega,EVomega,obj.n_ew)
      end
 
   end
   methods(Access=private)
       
   end
end