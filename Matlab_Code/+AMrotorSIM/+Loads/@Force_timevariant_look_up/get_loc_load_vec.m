function h = get_loc_load_vec(obj,time,varargin)

    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    h = sparse(6,1);
    Table = obj.Table;
    for k = 1:6
        h(k) = interp1(Table.time, Table.force{k}, time, 'spline');
    end
    
    
    obj.h = h;
end