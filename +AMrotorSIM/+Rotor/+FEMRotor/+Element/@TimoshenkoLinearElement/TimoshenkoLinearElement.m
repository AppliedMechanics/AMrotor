classdef TimoshenkoLinearElement < AMrotorSIM.Rotor.FEMRotor.Element.Element
% Class with the element formulation for Timoshenko elements

%   Timoshenko elements describe beam elements
%   they consist of 2 nodes with 6 degrees of freedom each, so that 1
%   element has 12 degrees of freedom
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

    properties
    end
    
    methods
        function self = TimoshenkoLinearElement(name,node1,node2,material)
                        % Constructor
            %
            %    :parameter name: name
            %    :type name: char
            %    :parameter node1: Axial position on the rotor
            %    :type node1: double
            %    :parameter node2: Outer radius
            %    :type node2: double
            %    :parameter material: Inner radius
            %    :type material: double
            %    :return: Element object
            
          if nargin == 0
            name = 'No Proper Element';
            node1 = MeshNode();
            node2 = MeshNode();
            material = Material()';
          end
          
          self = self@AMrotorSIM.Rotor.FEMRotor.Element.Element(name,node1,node2,material);
          
        end   
        
        function num = set_dof_number(obj,direction)
            % Assigns numbers to formulated (char) directions
            %
            %    :parameter direction: Directions ('u_x','u_y','u_z','psi_x','psi_y','psi_z')
            %    :type direction: char
            %    :return: Corresponding number (num('u_y')=2, or num('psi_x')=4)
            num = set_dof_number@AMrotorSIM.Rotor.FEMRotor.Element.Element(obj,direction);
        end
    end
    
end