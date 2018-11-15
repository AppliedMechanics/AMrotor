function [V,D] = get_mode_allocation(obj, Vref, Vin, D)
% Compare the current eigensolution Vin, D with a reference eigensolution
% Vref and sort accordingly
%  [V,D] = get_mode_allocation(obj, Vref, Vin, D)

% Vref = Vref/norm(Vref);
% Vin = Vin/norm(Vin);
% 
% sortIndex = zeros(size(Vref,2),1);
% largestMac = zeros(size(Vref,2),1);
% 
% for i = 1:size(Vref,2)
%     for j = 1:size(Vin,2)
%         mac = obj.get_modal_assurance_criterion( Vref(:,i), Vin(:,j) );
%         if mac > largestMac(i) %&& ~any(sortIndex==j)
%         % find largest mac, prevent that 2 current eigensolutions get get
%         % allocated to only 1 reference eigensolution
%             largestMac(i) = mac;
%             jLargestMac = j;
%         end
%     end
%     sortIndex(i) = jLargestMac;
% end
% 
% 
% D = D(sortIndex);
% V = Vin(:,sortIndex);


Vref = Vref/norm(Vref);
Vin = Vin/norm(Vin);

sortIndex = zeros(size(Vref,2),1);
mac = zeros(size(Vref,2),size(Vin,2));

for i = 1:size(Vref,2)
    for j = 1:size(Vin,2)
        mac(i,j) = obj.get_modal_assurance_criterion(Vref(:,i), Vin(:,j));
    end
end

for i = 1:size(Vref,2)
    sortIndex(i) = find(max(mac(:,i))==mac(:,i));
end

% % Check if allocation is not unique
% for i = 1:size(Vref,2)
%     jDuplicate = find(i == sortIndex);
%     n = length(jDuplicate);
%     if n > 1
%         tmp = find(~(max(mac(i,jDuplicate))==mac(i,jDuplicate)));
%         jDuplicateSmaller = jDuplicate(tmp);
%         jDuplicate = setdiff(jDuplicate,jDuplicateSmaller);
%         for j = jDuplicateSmaller'
%             sortIndex(j) = i + find(max(mac(i+1:size(Vref,2),j))==mac(i+1:size(Vref,2),j)); % finde den naechstgroesseren Wert der noch nicht verwendet wurde
%         end
%     end
% end

D = D(sortIndex);
V = Vin(:,sortIndex);

end

