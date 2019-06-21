function plot_components(ax,component,obj)

for i=component
    switch i.type
        case {'Seal','CompLUTMCK'}
            plot_CompLUTMCK(ax,i,obj);
    
        case 'Bearings'
            plot_bearings(ax,i,obj);
            
        case 'Discs'
            plot_discs(ax,i);
    
    end

end