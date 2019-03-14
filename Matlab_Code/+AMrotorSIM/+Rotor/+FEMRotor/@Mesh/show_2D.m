function show_2D(self,varargin)
% plot the distribution of elements in 2D
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
plot(x,y,'k')
legend('Elements')
end