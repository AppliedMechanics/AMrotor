load('bearing1.mat')
K_bearing = squeeze(num2cell(K_bearing,3));
for i = 1:size(K_bearing,1)
    for j=1:size(K_bearing,2)
        K_bearing{i,j} = squeeze(K_bearing{i,j});
    end
end
C_bearing = squeeze(num2cell(C_bearing,3));
for i = 1:size(C_bearing,1)
    for j=1:size(C_bearing,2)
        C_bearing{i,j} = squeeze(C_bearing{i,j});
    end
end