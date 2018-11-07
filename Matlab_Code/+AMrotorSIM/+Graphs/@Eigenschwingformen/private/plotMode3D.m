function plotMode3D( axFigure, x, V, D , color,numberOfTangentialPoints, numberOfNodesToPlot)
%PLOTMODE Summary of this function goes here
%   Detailed explanation goes here

n_points = numberOfTangentialPoints; % number of points in one circle

V = V/norm(V);

%reduce the size of V for less circles in the plot -> ToDo (reasonable ?)

% create sample points in radial direction
s = linspace(0,2*pi,n_points);

% create line in 3D that consists of circles
rx = zeros(1,length(s)*length(V));
ry = zeros(size(rx));
rz = zeros(size(rx));

for i = 1:length(V)
    rx(i*n_points:(i+1)*n_points-1) = x(i) * ones(1,n_points);
    ry(i*n_points:(i+1)*n_points-1) = V(i) * ones(1,n_points);
    rz(i*n_points:(i+1)*n_points-1) = V(i) * zeros(1,n_points);
    
    if any(i == 1:numberOfNodesToPlot:length(V)) % plotte nur jeden n-ten Kreis
        rx(i*n_points:(i+1)*n_points-1) = x(i) * ones(1,n_points);
        ry(i*n_points:(i+1)*n_points-1) = cos(s) * V(i);
        rz(i*n_points:(i+1)*n_points-1) = sin(s) * V(i);
    end
end


% plot the rotorsystem in the background -> ToDo

% plot Modes
plot3(axFigure,rx,ry,rz,...
            'DisplayName',sprintf('%1.2f Hz',D/(2*pi)),...
            'Color',color)
        
xlabel('z')
ylabel('x')
zlabel('y')
view(3)

end

