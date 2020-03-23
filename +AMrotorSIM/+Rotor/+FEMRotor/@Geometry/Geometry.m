classdef Geometry < handle
% Geometry Class that includes the geometric nodes
    properties
        name
        
        % See also AMrotorSIM.Rotor.FEMRotor.GeoNode
        % 
        % Objects containing the nodes, type: AMrotorSIM.Rotor.FEMRotor.GeoNode
        nodes (1,:) AMrotorSIM.Rotor.FEMRotor.GeoNode
    end
    
    methods
        function obj = Geometry(cnfg)
         if nargin == 0
           obj.name = 'Geometrie eines Rotorsystems';
         else
           obj.name = cnfg.name;

           for k= 1:length(cnfg.geo_nodes)
               obj.nodes(k) = AMrotorSIM.Rotor.FEMRotor.GeoNode(k,cnfg.geo_nodes{k}(1,1),cnfg.geo_nodes{k}(1,2),cnfg.geo_nodes{k}(1,3));
           end
         end
        end

   end
        
end    
