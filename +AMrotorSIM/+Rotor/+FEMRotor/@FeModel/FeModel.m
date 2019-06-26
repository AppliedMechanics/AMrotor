classdef FeModel < handle
% FeModel Class which included the finite element model
    properties
        name
        cnfg
        geometry@AMrotorSIM.Rotor.FEMRotor.Geometry
        material@AMrotorSIM.Rotor.FEMRotor.Material
        mesh@AMrotorSIM.Rotor.FEMRotor.Mesh
        matrices
    end
    
    methods
        function self = FeModel(a)
            if nargin == 0
                self.name = 'Non existent FE-Model';
                disp('FeModel has no properties');
                return
            else
            self.cnfg = a;
            self.name = self.cnfg.name;
            end
            
            self.geometry = AMrotorSIM.Rotor.FEMRotor.Geometry(self.cnfg);
            self.material = AMrotorSIM.Rotor.FEMRotor.Material(self.cnfg.material);
            self.mesh = self.create_mesh(self.cnfg.mesh_opt, self.geometry, self.material);
        end
        
    end
end

