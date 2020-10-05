% Licensed under GPL-3.0-or-later, check attached LICENSE file

function show_2D_nodes(self,varargin)
% Plots the mesh nodes in 2D
%
%    :parameter varargin: Variable input argument (check function)
%    :type varargin: 
%    :return: Figure with the nodes

if nargin == 1
    figure
elseif nargin ==2
    fig = varargin{1};
    figure(fig); % open figure
end
    nodes = self.nodes;
    mesh_node_z = zeros(1, length(nodes));
    mesh_node_r = zeros(1, length(nodes));
    mesh_node_ri = zeros(1, length(nodes));

    for k=1:length(nodes)
        mesh_node_z(k) = nodes(k).z;
        mesh_node_r(k) = nodes(k).radius_outer;
        mesh_node_ri(k) = nodes(k).radius_inner;
    end
    hold on
    plot(mesh_node_z,mesh_node_r,'bx','DisplayName','mesh outer')
    plot(mesh_node_z,mesh_node_ri,'rx','DisplayName','mesh inner')
    hold off
    legend('show')
end