function plot_components(ax,components,obj)

for i=components
    switch i.type
        case {'Seal','CompLUTMCK'}
            plot_CompLUTMCK(ax,i,obj);
    
        case 'Bearings'
            plot_bearings(ax,i,obj);
            
        case 'Disc'
            plot_discs(ax,i);
    
    end

end