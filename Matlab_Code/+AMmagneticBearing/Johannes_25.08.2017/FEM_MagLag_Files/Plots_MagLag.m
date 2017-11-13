%   Name: Plots_MagLag.m

%   Beschreibung: erstellt einige Plots innerhalb einer einzelnen Simulation. Geplottet werden koennen Geometrie, Rechengitter und Vektorpotential ...

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, FEM_MagLag.m,
%   Stoffwerte_MagLag.m, Geometrie_MagLag.m, Init_MagLag.m, Solve_MagLag.m
%   (SolveNonLin_MagLag.m)

%%%%%%%%%%
% Geometrie-Begrenzung für die Darstellung
XLim1=-0.085;
XLim2=0.085;
YLim1=-0.085;
YLim2=0.085;
AxLimits=[XLim1 XLim2 YLim1 YLim2];

if debugMode
   fprintf('Erstelle Plots ... \n \n') 
end

% Plotten der Geometrie mit Kanten- oder Flächenbeschriftung
if plotGeometry
    
   figure();
    title('Geometrie','Interpreter','latex');
    pdegplot(model,'EdgeLabels','off','FaceLabels','on');    % Plotten der Geometrie mit Flächen-Beschriftung / eines von beiden auswaehlen
%   pdegplot(model,'EdgeLabels','on','FaceLabels','off');    % Plotten der Geometrie mit Kanten-Beschriftung
    grid on;
    axis equal;
    axis (AxLimits(:));
    xlabel('x / m','Interpreter','latex');
    ylabel('y / m','Interpreter','latex');
   
end

% Plotten der Geometrie mit dem FEM-Gitter
if plotMesh
    figure
    pdemesh(model);
        axis equal;
        title('Geometrie und Netz','Interpreter','latex');
        axis (AxLimits(:) );
        xlabel('x / m','Interpreter','latex');
        ylabel('y / m','Interpreter','latex');
end

% Plotten des Vektorpotentials 
if plotVektorPot
    figure
    [xaeq,yaeq]=meshgrid(AxLimits(1):0.0005:AxLimits(2),AxLimits(3):0.0005:AxLimits(4)); 
    Aaeq=griddata(model.Mesh.Nodes(1,:),model.Mesh.Nodes(2,:),A,xaeq,yaeq); % Interpolation von A fuer bessere Darstellung
    xaeqIm=[AxLimits(1) AxLimits(2)];
    yaeqIm=[AxLimits(3) AxLimits(4)];
    hold on
    contour(xaeq,yaeq,Aaeq,35);
    pdegplot(model,'EdgeLabels','off','FaceLabels','off');    % Plotten der Geometrie mit Fasen-Beschriftung
    shading interp;
    colormap(parula);
    colorbar;
    title ('Magnetisches Vektorpotential','Interpreter','latex');
    axis (AxLimits(:) );
    xlabel('x / m','Interpreter','latex');
    ylabel('y / m','Interpreter','latex');
    hold off;    
    axis equal;
end