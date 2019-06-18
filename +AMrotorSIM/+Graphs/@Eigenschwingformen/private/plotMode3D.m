function plotMode3D( axFigure, x, V_x, V_y, D , color, param)
%PLOTMODE3D Summary of this function goes here
%   Detailed explanation goes here

n_points = param.numberOfTangentialPoints; % number of points in one circle

V_x = V_x * param.scaleEigenvector;
V_y = V_y * param.scaleEigenvector;

% create sample points in radial direction
s = linspace(0,2*pi,n_points);

% create line in 3D that consists of circles
rx = zeros(1,length(s)*length(V_x));
ry = zeros(size(rx));
rz = zeros(size(rx));

for i = 1:length(V_x)
    rx(i*n_points:(i+1)*n_points-1) = x(i) * ones(1,n_points);
    ry(i*n_points:(i+1)*n_points-1) = V_x(i);%V(i) * ones(1,n_points);
    rz(i*n_points:(i+1)*n_points-1) = V_y(i);%V(i) * zeros(1,n_points);
    
    if any(i == 1:param.moduloOfNodesToPlot:length(V_x)) % plotte nur jeden n-ten Kreis
        rx(i*n_points:(i+1)*n_points-1) = x(i) * ones(1,n_points);
        ry(i*n_points:(i+1)*n_points-1) = V_x(i)*cos(s) - V_y(i)*sin(s);%cos(s) * V(i);
        rz(i*n_points:(i+1)*n_points-1) = V_x(i)*sin(s) + V_y(i)*cos(s);%sin(s) * V(i);
    end
end

% plot Modes
plot3(axFigure,rx,ry,rz,...
            'DisplayName',sprintf('%1.2f Hz',D/(2*pi)),...
            'Color',color)
hold on
plot3(axFigure,x,V_x,V_y,'Color',color,'LineWidth',4)
        
xlabel('z')
ylabel('x')
zlabel('y')
view(3)

end

