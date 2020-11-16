function plot_components(ax,components,obj)
% Assigns the components (bearing, disk, CompLUTMCK) to the 3D visualization
%
%    :parameter ax: Axes properties control of the figure
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter components: Object of type components (obj.rotorsystem.components)
%    :type components: object
%    :parameter obj: Object of type rotor (obj.rotorsystem.rotor)
%    :type obj: object
%    :return: Assigned components to the 3d visualization

% Licensed under GPL-3.0-or-later, check attached LICENSE file

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