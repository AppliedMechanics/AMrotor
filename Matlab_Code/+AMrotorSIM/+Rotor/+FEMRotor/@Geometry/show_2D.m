function show_2D(obj,varargin)

if nargin == 1
    f1 = figure;
elseif nargin ==2
    f1 = varargin{1};
    figure(f1); % open figure
end

    n_nodes = length(obj.nodes);
    geo_node_z=zeros(1,n_nodes);
    geo_node_x=zeros(1,n_nodes);
    geo_node_xi=zeros(1,n_nodes);

    for k=1:n_nodes
        geo_node_z(k) = obj.nodes(k).z;
        geo_node_x(k) = obj.nodes(k).x;
        geo_node_xi(k) = obj.nodes(k).xi;
    end
    hold on
    plot(geo_node_z, geo_node_x, 'b-o');
    plot(geo_node_z, geo_node_xi, 'r-o');
    hold off
   axis([min(geo_node_z)*0.9 max(geo_node_z)*1.1 min(geo_node_x)*0.9 max(geo_node_x)*1.1])
end