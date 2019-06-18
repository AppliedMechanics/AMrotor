function show_2D(self,varargin)
%compare discretisation with user input geometry
if nargin == 1
    fig = figure;
elseif nargin ==2
    fig = varargin{1};
    figure(fig); % open figure
end

self.mesh.show_2D(fig); 
self.mesh.show_2D_nodes(fig);
self.geometry.show_2D(fig); 

legend('show')

end