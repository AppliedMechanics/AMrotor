%   Name: Plots_MagLag.m

%   Beschreibung: erstellt einige Plots innerhalb des MagLag-Moduls ...

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE


%%%%%%%%% Plotten der Geometrie
if debugMode
   fprintf('Erstelle Plots ... \n \n') 
end
if plotGeometry
    
   figure();
    title('Geometrie','Interpreter','latex');
    pdegplot(model,'EdgeLabels','off','FaceLabels','on');    % Plotten der Geometrie mit Fasen-Beschriftung
%   pdegplot(model,'EdgeLabels','on','FaceLabels','off');    % Plotten der Geometrie mit Kanten-Beschriftung
    hold on;
    grid on;
    axis equal;
    axis (AxLimits(:));
    xlabel('x / m','Interpreter','latex');
    ylabel('y / m','Interpreter','latex');
    
%%%%%     HIER koennen einzelne Punkte der Geometrieerzeugung in den Plot einkommentiert werden 
%     scatter(xP6,yP6,'red','filled');
%     scatter(xP8,yP8,'blue','filled');
%     scatter(xS103,yS103,'black','filled');
%     scatter(xS102,yS102,'yellow','filled');
%     scatter(xS161,yS161,'red');
%     scatter(xS101,yS101,'blue');
%     scatter(xS100,yS100,'black');
%     scatter(xP19,yP19,'yellow');
% %%%    
    hold off;    
end

if plotMesh

    figure
    pdemesh(model);
        axis equal;
        title('Geometrie und Netz','Interpreter','latex');
        axis (AxLimits(:) );
        xlabel('x / m','Interpreter','latex');
        ylabel('y / m','Interpreter','latex');
end

if plotVektorPot
    
    figure
    [xaeq,yaeq]=meshgrid(AxLimits(1):0.0005:AxLimits(2),AxLimits(3):0.0005:AxLimits(4)); 
    Aaeq=griddata(model.Mesh.Nodes(1,:),model.Mesh.Nodes(2,:),A,xaeq,yaeq); % Interpolation von A fuer bessere Darstellung
    xaeqIm=[AxLimits(1) AxLimits(2)];
    yaeqIm=[AxLimits(3) AxLimits(4)];
%     imagesc(xaeqIm,yaeqIm,Aaeq);                                  % farbige Darstellung von A
    hold on
    contour(xaeq,yaeq,Aaeq,35);
    pdegplot(model,'EdgeLabels','off','FaceLabels','off');    % Plotten der Geometrie mit Fasen-Beschriftung
    shading interp;
    colormap(parula);
    colorbar;
    title ('Mangetisches Vektorpotential','Interpreter','latex');
    axis (AxLimits(:) );
    xlabel('x / m','Interpreter','latex');
    ylabel('y / m','Interpreter','latex');
    hold off;
    
end