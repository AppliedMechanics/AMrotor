function plot_CompLUTMCK(ax,i,obj)

    zp=i.cnfg.position;
    
    comp_pos = i.position; 
    node_at_pos = obj.find_node_nr(comp_pos);
    
    radius = obj.mesh.nodes(node_at_pos).radius_outer;
    if ~isfield(i.cnfg,'vradius')
    elseif isempty(i.cnfg.vradius)
    else
        radius = i.cnfg.vradius;
    end


    
    % Zylinderfläche;
    [x,y,z] = cylinder(radius*1.5);

    %h = surf(ax, x, y, z*0.01+zp);
    h = surf(ax,z*0.01+zp-0.005, y, x);

    set(h, 'edgecolor','none')
    set(h, 'facecolor',i.color)
    
end