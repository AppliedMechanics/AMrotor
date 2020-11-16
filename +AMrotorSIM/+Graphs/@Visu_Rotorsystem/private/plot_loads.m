function plot_loads(ax,loads)
% Assigns the loads (unbalance and force) to the 3D visualization
%
%    :parameter ax: Axes properties control of the figure
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter load: Object of type loads (obj.rotorsystem.loads)
%    :type load: object
%    :return: Assigned components to the 3d visualization

% Licensed under GPL-3.0-or-later, check attached LICENSE file

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