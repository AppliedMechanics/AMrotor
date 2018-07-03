classdef FeModel < handle
    
    properties
        name
        cnfg
        geometry
        mesh
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
            self.mesh = self.create_mesh(self.cnfg.mesh_opt, self.geometry);
        end
        
      function print(obj)
         disp(obj.name);
      end
        
    end
end

