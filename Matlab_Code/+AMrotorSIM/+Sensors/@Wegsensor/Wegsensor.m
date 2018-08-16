classdef Wegsensor < AMrotorSIM.Sensors.Sensor
   properties
       unit = 'm'
       Position
       measurementType = 'Distance'
   end
   methods
        function self=Wegsensor(config) 
           self = self@AMrotorSIM.Sensors.Sensor(config); 
           self.Position = config.position;
        end 
        
        function [x_val,beta_pos,y_val,alpha_pos] = read_values(self,rotorsystem)

            res = rotorsystem.time_result;
            rotorpar = rotorsystem.rotor.cnfg;
            nodes = rotorsystem.rotor.mesh.nodes;
            
            %moment of inertia
            sensor_node = rotorsystem.rotor.find_node_nr(self.Position);
            for ele = rotorsystem.rotor.mesh.elements
                if ele.node1.name == sensor_node
                    sensor_ele = ele;
                    continue
                end
            end
             G = 1/(2*(1+sensor_ele.material.poisson));
            moment_of_inertia = (12*sensor_ele.material.e_module * sensor_ele.I_y*sensor_ele.material.shear_factor)/...
                (G*sensor_ele.area*sensor_ele.length^2);
            %%%%%%%%%%%%%%%%%%%
                n_nodes = length(nodes);
                sd=rotorpar.shear_def;

                x_val = containers.Map('KeyType','double','ValueType','any');
                y_val = containers.Map('KeyType','double','ValueType','any');
                beta_pos = containers.Map('KeyType','double','ValueType','any');
                alpha_pos = containers.Map('KeyType','double','ValueType','any');

                drehzahlvektor = cell2mat(keys(res));
                for drehzahl = drehzahlvektor
                Z=res(drehzahl).X;
                  if (self.Position < 0 || self.Position > nodes(end))
                    error('Orbit ausserhalb Rotor');
                  else
                    if self.Position == nodes(end).z
                        % In diesem Fall macht un tere Prozedur keinen Sinn, Zuordnung
                        % zum letzten Element
                        n0 = n_nodes-1;
                        kappa = 1; %Kappa-Wert
                        l_Ele = nodes(end).z-nodes(end-1).z;
                        PhiS = sd*moment_of_inertia/l_Ele^2;

                    else
                        % Suche den linken Nachbarknoten
                        % Falls Angriffspunkt=Knoten, dann Angriffspunkt=linker Nachbar
                        n0=1;
                        b=1;
                        while nodes(n0+1).z <= self.Position
                            n0 = n0+1;
                        end
                        l_Ele=nodes(n0+1).z-nodes(n0).z;
                        kappa = (self.Position-nodes(n0).z) / l_Ele;

%                         while rotorpar.rotor_dimensions(b,1) <= self.Position
%                             b=b+1;
% 
%                         end
                        PhiS = sd*moment_of_inertia/l_Ele^2;
                    end
                  end


                %Formfunktionen

                bw =(1/(1+PhiS))*[1+PhiS*(1-kappa)-3*kappa^2+2*kappa^3,-l_Ele*kappa*(kappa^2-2*kappa+1+0.5*PhiS*(1-kappa)),3*kappa^2-2*kappa^3+kappa*PhiS,-l_Ele*kappa*(kappa^2-kappa-0.5*PhiS*(1-kappa))];
                bv =[bw(1), -bw(2), bw(3), -bw(4)];

                % Auswertung Biegung v
                z1 = n0*2-1;
                z2 = n0*2+2;
                z3 = 2*n_nodes+n0*2-1;
                z4 = 2*n_nodes+n0*2+2;

                x_val(drehzahl) = bv*Z(z1:z2,:);
                y_val(drehzahl) = bw*Z(z3:z4,:);


                cw=(1/(1+PhiS))*[(-PhiS-6*kappa+6*kappa^2)/l_Ele, -(3*kappa^2-4*kappa+0.5*PhiS*(1-2*kappa)+1), (6*kappa-6*kappa^2+PhiS)/l_Ele, -(3*kappa^2-2*kappa-0.5*PhiS*(1-2*kappa))];
                cv=[-cw(1), cw(2), -cw(3), cw(4)];

                alpha_pos(drehzahl) =cv*Z(z1:z2,:);
                beta_pos(drehzahl) = cw*Z(z3:z4,:);

                end
        end
   end
end