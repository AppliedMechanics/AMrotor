function plot_loads(ax,loads)

for load=loads
    
    switch load.type
        case 'Unbalance_static'
            plot_unbalance(ax,load);
            
        case 'Force_constant_fix'
            plot_force(ax,load);
        case 'Force_timevariant_whirl_fwd_sweep'
            plot_force(ax,load);
    end

end