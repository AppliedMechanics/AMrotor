function plot_components(ax,components,obj)

for component=components
    switch component.type
        case {'Seals','CompLUTMCK'}
            plot_CompLUTMCK(ax,component,obj);
    
        case 'Bearings'
            plot_bearing(ax,component,obj);
            
        case 'Disc'
            plot_disc(ax,component);
    end

end