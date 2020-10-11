% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef FeModel < handle
% Class that includes the finite element model

%   cnfg... Config-struct
% See also AMrotorSIM.Rotor AMrotorSIM.Rotor.FEMRotor.Element
    properties
        name
        cnfg
        geometry (1,1) AMrotorSIM.Rotor.FEMRotor.Geometry
        material (1,1) AMrotorSIM.Rotor.FEMRotor.Material
        mesh (1,1) AMrotorSIM.Rotor.FEMRotor.Mesh
        
        mass_matrix         
        damping_matrix      
        gyroscopic_matrix   
        stiffness_matrix   
    end
    
    methods
        function self = FeModel(cnfg) 
            % Constructor
            %
            %    :parameter cnfg: Cnfg_rotor substruct of cnfg-struct
            %    :type cnfg: struct
            %    :return: FeModel object
            
            if nargin == 0
                self.name = 'Non existent FE-Model';
                disp('FeModel has no properties');
                return
            else
            self.cnfg = cnfg;
            self.name = self.cnfg.name;
            end
            
            self.geometry = AMrotorSIM.Rotor.FEMRotor.Geometry(self.cnfg);
            self.material = AMrotorSIM.Rotor.FEMRotor.Material(self.cnfg.material);
            self.mesh = self.create_mesh(self.cnfg.mesh_opt, self.geometry, self.material);
        end
        
    end
end

