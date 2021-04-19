function plot_disc(ax,disc)
% Provides/drafts the component disc for the visualization of the rotor system
%
%    :parameter ax: Axes properties control of the figure
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter disc: Object of type components (obj.rotorsystem.components)
%    :type disc: object
%    :return: 3D model of the disc for 3D-visualization

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    zp=disc.cnfg.position;
    r=disc.cnfg.radius;

    % %Scheiben;
    theta = linspace(0,2*pi,20);
    rs = linspace(0,r,2);
    
    % Visualization parameters setting -----------------------------
    color = AMrotorTools.TUMColors.TUMBlue;
    
    if ~isfield(disc.cnfg,'color')
    elseif isempty(disc.cnfg.color)
    else
        color = disc.cnfg.color;
    end
    
    width=0;
    if ~isfield(disc.cnfg,'width')
    elseif isempty(disc.cnfg.width)
    else
        width = disc.cnfg.width;
    end
 
    % Plotting ---------------------------
    [TH,R] = meshgrid(theta,rs);
    [x,y] = pol2cart(TH,R);
%     z=(width/2).*cos(TH)-(width/2).*sin(TH);
    z=width/2.*(cos(TH).^2-sin(TH).^2); % z=(x^2)-(y^2)
    z(1,:) = 0;
    
    h=surf(ax,z+zp,y,x);
    set(h, 'edgecolor','none')
    set(h, 'facecolor',color)

    % Zylinderfl‰che auﬂenrum;
    [x,y,z] = cylinder(r);

    h = surf(ax, z*width+zp-width/2, y, x);
    set(h, 'edgecolor',[0.01 0.01 0.01])
    set(h, 'facecolor',color)

end





