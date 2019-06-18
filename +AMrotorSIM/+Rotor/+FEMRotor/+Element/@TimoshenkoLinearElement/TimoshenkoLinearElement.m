classdef TimoshenkoLinearElement < AMrotorSIM.Rotor.FEMRotor.Element.Element
    
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