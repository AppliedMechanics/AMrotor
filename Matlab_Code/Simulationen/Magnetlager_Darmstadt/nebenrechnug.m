load Ergebnis_nonlin.mat
figure(8)
% Rekonstruktion Matrixstruktur
y_range=sort(unique(Ergebnis_nonlin(:,2)))
Iy_range=sort(unique(Ergebnis_nonlin(:,6)))
Z=zeros(length(y_range),length(Iy_range))

for i=1:length(y_range)
    for j=1:length(Iy_range)
        Z(i,j)=Ergebnis_nonlin( (Ergebnis_nonlin(:,2)==y_range(i))&(Ergebnis_nonlin(:,6)==Iy_range(j))  ,8);
    end
end
surf(y_range,Iy_range,Z')
title('Kennfeld y-Richtung linear','Interpreter','latex');
ylabel('Differenzstrom in y-Richtung / A', 'Interpreter', 'latex');
xlabel('Wellenposition in y-Richtung / m', 'Interpreter', 'latex');
zlabel('Kraft in y-Richtung / N','Interpreter','latex');