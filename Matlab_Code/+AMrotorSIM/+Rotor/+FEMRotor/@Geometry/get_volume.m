function volume=get_volume(obj)

    dimR=size(obj.nodes);
    n_nodes = length(obj.nodes);
    r=zeros(n_nodes,1);
    geo_node_z=zeros(1,n_nodes);
    geo_node_x=zeros(1,n_nodes);


    for k=1:n_nodes
        geo_node_z(k) = obj.nodes(k).z;
        geo_node_x(k) = obj.nodes(k).x;
    end

    n=1;
    while n <n_nodes
        r(n,1)=geo_node_x(n);
        n=n+1;
    end

    a=1;
    if a < dimR(1)
        a=a+1;
    end

    for n=2:size(r)

    %Berechnen der Zylinderelemente   
        volume_zyl(n) = r(n)^2*pi*(geo_node_z(n)-geo_node_z(n-1));

    end
    
    volume=sum(volume_zyl);

end