clear
A = [0, 103.04e6; 6e3, 0];
B = [-0.01, 0; 0, -0.26e6];
cT = [68.45, 209.28e3];
d = -0.02;
f=@(i,x) [i;x].'*A*([i;x].^2) + [i;x].'*B*[i;x] + cT*[i;x] + d
iTable = -1:0.1:1; % change the step size
uTable = (-0.1:0.01:0.1)*1e-3; % change the step size
for i = 1:length(iTable)
    for j = 1:length(uTable)
        forceTable(i,j) = f(iTable(i),uTable(j));
    end
end
displacement = uTable;
current = iTable;
force = forceTable;
description = 'Polynommodell 2. Ordnung aus Bachelorarbeit Dietz 2018 S.58 als Look Up Table zum Überprüfen der Funktionsfähigkeit'
save pidTestLUT displacement current force description