function show_2D(obj)

    n_nodes = length(obj.nodes);
    f1 = figure;
    geo_node_z=zeros(1,n_nodes);
    geo_node_x=zeros(1,n_nodes);

    for k=1:n_nodes
        geo_node_z(k) = obj.nodes(k).z;
        geo_node_x(k) = obj.nodes(k).x;
        plot(geo_node_z, geo_node_x, 'k-o');
    end
   axis([min(geo_node_z)-1 max(geo_node_z)+1 min(geo_node_x)-1 max(geo_node_x)+1])
end