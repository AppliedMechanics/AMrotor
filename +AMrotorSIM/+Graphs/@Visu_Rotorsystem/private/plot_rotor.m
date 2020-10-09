% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot_rotor(ax, rotor)
% Provides/drafts the rotor for the visualization of the rotor system
%
%    :parameter ax: Axes properties control of the figure (check matlab function: axes)
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter rotor: Object of type rotor (obj.rotorsystem.rotor)
%    :type rotor: object
%    :return: 3D model of the rotor for 3D-visualization

    color = AMrotorTools.TUMColors.TUMGray2;
    
    if ~isfield(rotor.cnfg,'color')
    elseif isempty(rotor.cnfg.color)
    else
        color = rotor.cnfg.color;
    end
    
    rotor.mesh.show_3D(ax,color);
end






