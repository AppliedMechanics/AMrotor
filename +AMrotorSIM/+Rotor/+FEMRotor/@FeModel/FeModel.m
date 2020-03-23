classdef FeModel < handle
% FeModel Class which included the finite element model
%
% See also AMrotorSIM.Rotor AMrotorSIM.Rotor.FEMRotor.Element
    properties
        name
        cnfg % Config-struct
        % See also AMrotorSIM.Rotor.FEMRotor.Geometry
        geometry (1,1) AMrotorSIM.Rotor.FEMRotor.Geometry
        % See also AMrotorSIM.Rotor.FEMRotor.Material
        material (1,1) AMrotorSIM.Rotor.FEMRotor.Material
        % See also AMrotorSIM.Rotor.FEMRotor.Mesh
        mesh (1,1) AMrotorSIM.Rotor.FEMRotor.Mesh
        
        mass_matrix         % mass
        damping_matrix      % damping
        gyroscopic_matrix   % gyroscopic, must be weighted with the rotational speed Omega, M*xdd+(C+Omega*G)*xd+K*x=f
        stiffness_matrix    % stiffness
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

