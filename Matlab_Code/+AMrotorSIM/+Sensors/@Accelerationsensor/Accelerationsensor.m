classdef Accelerationsensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = 'm/s^2'
       Position
       measurementType = 'Acceleration'  
   end
   methods
        function self=Accelerationsensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config);
           self.Position = config.position;
        end 
        
%         function [x_val,y_val] = read_acceleration_values(self,experiment)
%                         
%             res = experiment.result;
%             rotorpar = experiment.rotorsystem.rotor.cnfg;
%             moment_of_inertia = experiment.rotorsystem.rotor.moment_of_inertia;
%             nodes = experiment.rotorsystem.rotor.nodes;
% 
%             n_nodes = length(nodes);
%             sd=rotorpar.shear_def;
%             
%             x_val = containers.Map('KeyType','double','ValueType','any');
%             y_val = containers.Map('KeyType','double','ValueType','any');
%             
%         for drehzahl = experiment.drehzahlen
%             Z=res(drehzahl).X_dd;
%             
%               if (self.Position < 0 || self.Position > nodes(end))
%                 error('Orbit ausserhalb Rotor');
%               else
%                 if self.Position == nodes(end)
%                     % In diesem Fall macht untere Prozedur keinen Sinn, Zuordnung
%                     % zum letzten Element
%                     n0 = n_nodes-1;
%                     kappa = 1; %Kappa-Wert
%                     l_Ele = nodes(end)-nodes(end-1);
%                     PhiS = sd*moment_of_inertia(end-1,5)/l_Ele^2;
% 
%                 else
%                     % Suche den linken Nachbarknoten
%                     % Falls Angriffspunkt=Knoten, dann Angriffspunkt=linker Nachbar
%                     n0=1;
%                     b=1;
%                     while nodes(n0+1) <= self.Position
%                         n0 = n0+1;
%                     end
%                     l_Ele=nodes(n0+1)-nodes(n0);
%                     kappa = (self.Position-nodes(n0)) / l_Ele;
% 
%                     while rotorpar.rotor_dimensions(b,1) <= self.Position
%                         b=b+1;
% 
%                     end
%                     PhiS = sd*moment_of_inertia(b,5)/l_Ele^2;
%                 end
%               end
% 
% 
%             %Formfunktionen
% 
%             bw =(1/(1+PhiS))*[1+PhiS*(1-kappa)-3*kappa^2+2*kappa^3,-l_Ele*kappa*(kappa^2-2*kappa+1+0.5*PhiS*(1-kappa)),3*kappa^2-2*kappa^3+kappa*PhiS,-l_Ele*kappa*(kappa^2-kappa-0.5*PhiS*(1-kappa))];
%             bv =[bw(1), -bw(2), bw(3), -bw(4)];
% 
%             % Auswertung Biegung v
%             z1 = n0*2-1;
%             z2 = n0*2+2;
%             z3 = 2*n_nodes+n0*2-1;
%             z4 = 2*n_nodes+n0*2+2;
%             
%             x_val(drehzahl) = bv*Z(z1:z2,:);
%             y_val(drehzahl) = bw*Z(z3:z4,:);
%         end
%         end
   end
end
