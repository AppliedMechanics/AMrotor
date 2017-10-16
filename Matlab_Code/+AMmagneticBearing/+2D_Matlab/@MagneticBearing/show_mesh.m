function show_mesh( self )
%SHOW_MESH Summary of this function goes here
%   Detailed explanation goes here
 figure
    pdemesh(self.model);
        axis equal;
        title('Geometrie und Netz','Interpreter','latex');
        %axis (AxLimits(:) );
        xlabel('x / m','Interpreter','latex');
        ylabel('y / m','Interpreter','latex');

end

