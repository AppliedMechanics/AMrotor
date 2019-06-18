function [V,D] = get_mode_allocation_zeros_crossings(obj, Vin, D)
% Count the zero-crossings of the Eigenvalues and sort them accordingly

%first sort by eigenfrequency
[~,I] = sort(imag(D));
V = Vin(:,I);
D = D(I);

zci = @(v) find(v.*circshift(v, [-1 0]) <= 0);% Returns Zero-Crossing Indices Of Argument Vector

Ev_lat_x = V(1:4:end,:);

% extrapolate the eigenshape at the boundary
nodes = cell2mat({obj.rotorsystem.rotor.mesh.nodes(:).z});
Ev_left = interp1(nodes, Ev_lat_x, -nodes(end), 'spline');
Ev_right = interp1(nodes, Ev_lat_x, 2*nodes(end), 'spline');
Ev_lat_x = [Ev_left; Ev_lat_x; Ev_right];

%     for mode = 1:size(V,2)
%         for node = 1:size(V,1)/4
%             dof_u_x = 4*(node-1)+1;
%             Ev_lat_x(node,mode)=V(dof_u_x,mode);
%         end
%     end

%DEBUGGING=================================================================
% for i = 1:size(Vin,2)
%     plot([-nodes(end), nodes, 2*nodes(end)]',real(Ev_lat_x(:,i)))
%     grid on
%     hold on
%     plot([-nodes(end) 2*nodes(end)],[0 0])
%     pause(0.2)
%     hold off
% end
%ENDE=DEBUGGING============================================================

for i = 1: size(Vin,2)
    zx = zci(real(Ev_lat_x(:,i)));
    zeroCrossings(i) = length(zx);
end

% for i = 1: size(Vin,2)
% x = diff(sign(real(Ev_lat_x(:,i))));
% indx_up = find(x>0);
% indx_down = find(x<0);
% zeroCrossings(i) = length(indx_up) +length(indx_down);
% end

[~,I] = sort(zeroCrossings);
V = V(:,I);
D = D(I);
end

