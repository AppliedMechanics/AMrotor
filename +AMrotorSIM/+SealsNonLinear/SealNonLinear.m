classdef (Abstract) SealNonLinear < matlab.mixin.Heterogeneous & handle % Was heisst Abstract?, Was heisst matlab.mixin.Heterogeneous?
    % classdef Seal < handle
    % classdef (Abstract) Seal < matlab.mixin & handle
    properties
        name
        position
        type
        localisation_matrix
        mass_matrix
        stiffness_matrix
        damping_matrix
        color='black'
        %       sealModel
    end
    methods
        %Konstruktor
        function obj = SealNonLinear(arg)
            if nargin == 0
                obj.name = 'starke Dichtung!';
            else
                obj.name = arg.name;
                obj.position=arg.position;
                obj.type = arg.type;
            end
        end
        
        function [F] = get_sealsNonLinear_force(sealNonLinear,Z,Zp,rotorsystem)
            
            n_nodes = length(rotorsystem.rotor.mesh.nodes);
            
            seal_node = rotorsystem.rotor.find_node_nr(sealNonLinear.position);
            sealNonLinear.create_ele_loc_matrix;
            L_ele = sparse(6,6*n_nodes);
            L_ele(1:6,(seal_node-1)*6+1:(seal_node-1)*6+6)=sealNonLinear.localisation_matrix;
            
            dof_u_x = rotorsystem.rotor.get_gdof('u_x',seal_node);
            dof_psi_z = rotorsystem.rotor.get_gdof('psi_z',seal_node);
            node.q = Z(dof_u_x:dof_psi_z);
            node.qd = Z(n_nodes +(dof_u_x:dof_psi_z));
            node.qd = Zp(n_nodes +(dof_u_x:dof_psi_z));
            
            sealNonLinear.get_loc_system_matrices(node);
            
            M_seal = L_ele'*sealNonLinear.mass_matrix*L_ele;
            K_seal = L_ele'*sealNonLinear.stiffness_matrix*L_ele;
            D_seal = L_ele'*sealNonLinear.damping_matrix*L_ele;
            
            res.q = Z(1:6*n_nodes,:);
            res.qd = Z(6*n_nodes+1:2*6*n_nodes,:);
            res.qdd= Zp(6*n_nodes+1:2*6*n_nodes,:);
            F = M_seal*res.qdd + D_seal*res.qd + K_seal*res.q;
            
            
        end
        
    end
    
    methods(Abstract)
        
        print(self)
        
        create_ele_loc_matrix(self)
        
        [M_s,D_s,K_s] = get_loc_system_matrices(self,rpm)
        
    end
    
end