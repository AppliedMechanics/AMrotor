function plot_rotor(ax, rotor)
    color = AMrotorTools.TUMColors.TUMGray2;
    
    if ~isfield(rotor.cnfg,'color')
    elseif isempty(rotor.cnfg.color)
    else
        color = rotor.cnfg.color;
    end
    
    rotor.mesh.show_3D(ax,color);
end






