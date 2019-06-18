classdef Geometry < handle
    properties
        name
        nodes@AMrotorSIM.Rotor.FEMRotor.GeoNode vector
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
