function [n_x,n_dx,n_y,n_dy]=find_next_node_ss(obj, z_pos)
%FIND_NEXT_NODE_SS
%   Findet die nächstgelegenen Knotenpunkte im Rotornetz in der
%   Zustandsraumdarstellung
%   n_x: Index auf die zugehörige Position im Vektor in x-Richtung
%   n_dx: Index auf die zugehörige Geschwindigkeit im Vektor in x-Richtung

nodes = obj.rotor.nodes;
n_nodes = length(nodes);

n=2;
        while z_pos > nodes(n)
          n = n+1;
        end
        
n_x = n*2-1;
n_dx = n_nodes*4+n*2-1;
n_y = n_nodes*2+n*2-1;
n_dy = n_nodes*4+n_nodes*2+n*2-1;
        
end

