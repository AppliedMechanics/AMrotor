function [V,D] = get_mode_allocation_zeros_crossings(obj, Vin, D)
% Count the zero-crossings of the Eigenvalues and sort them accordingly

%first sort by eigenfrequency
[~,I] = sort(imag(D));
V = Vin(:,I);
D = D(I);

zci = @(v) find(v.*circshift(v, [-1 0]) <= 0);% Returns Zero-Crossing Indices Of Argument Vector

Ev_lat_x = V(1:4:end,:);
%     for mode = 1:size(V,2)
%         for node = 1:size(V,1)/4
%             dof_u_x = 4*(node-1)+1;
%             Ev_lat_x(node,mode)=V(dof_u_x,mode);
%         end
%     end

%DEBUGGING=================================================================
% for i = 1:size(Vin,2)
%     plot(real(Ev_lat_x(:,i)))
%     grid on
%     hold on
%     plot([0 80],[0 0])
%     pause(0.2)
%     hold off
% end
%ENDE=DEBUGGING============================================================

for i = 1: size(Vin,2)
    zx = zci(real(Ev_lat_x(:,i)));
    zeroCrossings(i) = length(zx);
end

[~,I] = sort(zeroCrossings);
V = V(:,I);
D = D(I);
end

