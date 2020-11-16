function show_2D(self,varargin)
% Plots the geometry over the nodes to compare discretisation with user input geometry
%
%    :parameter varargin: Variable input argument (check function)
%    :type varargin: 
%    :return: Figure with geometry and nodes

% Licensed under GPL-3.0-or-later, check attached LICENSE file

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