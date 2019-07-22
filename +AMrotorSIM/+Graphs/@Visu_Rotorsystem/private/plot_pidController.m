function plot_pidController(ax,pidController,rotor)

for i=pidController
    
    pos=i.position;
    r = max([rotor.mesh.nodes.radius_outer])*2; %aus rotor object HIER DURCHMESSER DES DAZUGEHÖRIGEN ROTORABSCHNITTS HERAUSFINDEN
    xp = [0,0];
    yp = [0,0];
    zp = [pos,pos];
    
    [xcyl,ycyl,zcyl] = cylinder(2*r);
    xcyl = xcyl(1,:);
    ycyl = ycyl(1,:);
    zcyl = zcyl(1,:);
    
    switch i.direction
        case 'u_x'
            xp = [0 r];
        case 'u_y'
            yp = [0 r];
        case 'u_z'
            zp = [pos,pos+r];
            
        case 'psi_x'
            xplot = xcyl;
            yplot = ycyl;
            zplot = zcyl;
        case 'psi_y'
            xplot = xcyl;
            yplot = zcyl;
            zplot = ycyl;
        case 'psi_z'
            xplot = zcyl;
            yplot = xcyl;
            zplot = ycyl;
            
            
        otherwise
            error(['Direction for controller allows only '],...
                ['''u_x'',''u_y'',''u_z'',''psi_x'',''psi_y'',''psi_z'''])
    end
    
    switch i.direction
        case {'u_x','u_y','u_z'}
            lineObj=line(ax, zp, yp, xp,'LineWidth',3);
        case {'psi_x','psi_y','psi_z'}
            zplot = zplot + pos;
            lineObj=plot3(xplot,yplot,zplot,'LineWidth',3);
    end
    
    lineObj.Color = 'green';
    
    
    
end