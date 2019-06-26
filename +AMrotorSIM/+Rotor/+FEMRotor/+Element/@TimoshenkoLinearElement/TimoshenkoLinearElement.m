classdef TimoshenkoLinearElement < AMrotorSIM.Rotor.FEMRotor.Element.Element
% TimoshenkoLinearElement Class with the element formulation for Timoshenko
% elements
%   Timoshenko elements describe beam elements
%   they consist of 2 nodes with 6 degrees of freedom each, so that 1
%   element has 12 degrees of freedom
    properties
    end
    
    methods
        function self = TimoshenkoLinearElement(name,node1,node2,material)
          if nargin == 0
            name = 'No Proper Element';
            node1 = MeshNode();
            node2 = MeshNode();
            material = Material()';
          end
          
          self = self@AMrotorSIM.Rotor.FEMRotor.Element.Element(name,node1,node2,material);
          
        end   
    end
    
end