function show_2D(self,varargin)
% Plots the meshed rotor in 2D
%
%    :parameter varargin: Variable input argument (check function)
%    :type varargin: 
%    :return: Figure with the mesh of the rotor

% Licensed under GPL-3.0-or-later, check attached LICENSE file

if nargin == 1
    figure
elseif nargin ==2
    fig = varargin{1};
    figure(fig); % open figure
end

hold on
nEle = length(self.elements);
x = [];
y = [];

for k=1:nEle
    ele = self.elements(k);
    z1 = ele.node1.z;
    z2 = ele.node2.z;
    ro = ele.radius_outer;
    ri = ele.radius_inner;
    x = [x, z1, z1, z2, z2, z1, z2];
    y = [y, ri, ro, ro, ri, ri, ri];
end
plot(x,y,'k','DisplayName','Elements')
legend('show')
end