function plotMode3D_overlay( axFigure, x, V, D , color)
%PLOTMODE Summary of this function goes here
%   Detailed explanation goes here

n_radial = 20; % number of points in one circle

V = V/norm(V); % normalize the amplitide

%reduce the size of V for less circles in the plot -> ToDo (reasonable ?)

% create sample points in radial direction
s = linspace(0,2*pi,n_radial);

% create line in 3D that consists of circles
rx = zeros(1,length(s)*length(V));
ry = zeros(size(rx));
rz = zeros(size(rx));

for i = 1:length(V)
    rx(i*n_radial:(i+1)*n_radial-1) = x(i) * ones(1,n_radial);
    ry(i*n_radial:(i+1)*n_radial-1) = cos(s) * V(i);
    rz(i*n_radial:(i+1)*n_radial-1) = sin(s) * V(i);
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

