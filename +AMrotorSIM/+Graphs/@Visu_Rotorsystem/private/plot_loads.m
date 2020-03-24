function plot_loads(ax,loads)

for load=loads
    
    switch load
        case isa(load,'AMrotorSIM.Loads.Unbalance_static')
            plot_unbalance(ax,load);
            
        case  isa(load,'AMrotorSIM.Loads.Force_constant_fix')
            plot_force_fix(ax,load);
    end

end