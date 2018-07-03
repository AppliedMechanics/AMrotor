classdef Geometry < handle
    properties
        name
        geometry
        material
    end
    
    methods
        function obj = Geometry(cnfg)
         if nargin == 0
           obj.geometry = [0];  
           obj.name = 'Geometrie eines Rotorsystems';
         else
           obj.name = cnfg.name;
           obj.material = cnfg.material;

           for k= 1:length(cnfg.geo_nodes)
               obj.geometry.nodes(k) = AMrotorSIM.Rotor.FEMRotor.GeoNode(k,cnfg.geo_nodes{k}(1,1),cnfg.geo_nodes{k}(1,2));
           end
         end
        end

   end
        
end    
