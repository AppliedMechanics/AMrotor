classdef Geometry < handle
% Class that includes the geometric nodes

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    properties
        name
        nodes (1,:) AMrotorSIM.Rotor.FEMRotor.GeoNode
    end
    
    methods
        function obj = Geometry(cnfg)
            % Constructor
            %
            %    :parameter arg: Cnfg_rotor substruct of cnfg-struct
            %    :type arg: struct
            %    :return: Geometry object
            
         if nargin == 0
           obj.name = 'Geometrie of rotor system';
         else
           obj.name = cnfg.name;

           for k= 1:length(cnfg.geo_nodes)
               obj.nodes(k) = AMrotorSIM.Rotor.FEMRotor.GeoNode(k,cnfg.geo_nodes{k}(1,1),cnfg.geo_nodes{k}(1,2),cnfg.geo_nodes{k}(1,3));
           end
         end
        end

   end
        
end    
