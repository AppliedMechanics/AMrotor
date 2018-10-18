function show_2D(self)
% Plot the mesh in 2D    
    nodes = self.nodes;
    mesh_node_z = zeros(1, length(nodes));
    mesh_node_r = zeros(1, length(nodes));

    for k=1:length(self.nodes)

        mesh_node_z(k) = nodes(k).z;
        mesh_node_r(k) = nodes(k).radius_outer;
        mesh_node_ri(k) = nodes(k).radius_inner;
        o = zeros(1, length(mesh_node_z));
        plot(mesh_node_z, o(k), 'x');
        %text(mesh_node_z(k),o(k),num2str(k))
        hold on

        plot([mesh_node_z(k) mesh_node_z(k)],[mesh_node_r(k) o(k)],'b-')
        plot([mesh_node_z(k) mesh_node_z(k)],[mesh_node_ri(k) o(k)],'b-')
        axis([-1 5 -1 5]);
        %hold off

    end
end