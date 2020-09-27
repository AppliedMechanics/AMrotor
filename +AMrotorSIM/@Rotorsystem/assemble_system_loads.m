% Licensed under GPL-3.0-or-later, check attached LICENSE file

function h = assemble_system_loads(self,time,Z)
% Assembles the system loads
%
%    :param time: Time step
%    :type time: double
%    :param Z: State vector
%    :type Z: vector
%    :return: System load vector h

n_nodes=length(self.rotor.mesh.nodes);
h = sparse(6*n_nodes,1);

for load = self.loads
    
    load_node = self.rotor.find_node_nr(load.position);
    [node.q, node.qd] = self.find_state_vector(load.position,Z);
    node.omega = node.qd(6);
    
    load.create_ele_loc_matrix;
    load.get_loc_load_vec(time,node);
    
    L_ele = sparse(6,6*n_nodes);
    L_ele(1:6,(load_node-1)*6+1:(load_node-1)*6+6)=load.localisation_matrix;
    
    h = h + L_ele'*load.h;
    
end



end