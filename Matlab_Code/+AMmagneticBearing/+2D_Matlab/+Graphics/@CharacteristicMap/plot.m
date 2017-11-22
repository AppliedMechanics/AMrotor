function plot(self)
% Darstellung der Kennfelder eines Magnetlagers
% Ergebnisse sind in einem Objekt der Klasse CharacteristicMap gespeichert

%% Extraktion der Zahlenwerte
map_xIxFx=self.map('xIxFx');
map_xIxFy=self.map('xIxFy');
x_vec=self.map('x');
Ix_vec=self.map('Ix');

map_yIyFy=self.map('yIyFy');
map_yIyFx=self.map('yIyFx');
y_vec=self.map('y');
Iy_vec=self.map('Iy');

%% Plot
figure('Name',self.name)
try
p1=subplot(2,2,1);
surf(Ix_vec(1,:),x_vec(:,1)',map_xIxFx);
title('Kennfeld x-Richtung','Interpreter','latex');
xlabel('Differenzstrom in x-Richtung / A', 'Interpreter', 'latex');
ylabel('Wellenposition in x-Richtung / m', 'Interpreter', 'latex');
zlabel('Kraft in x-Richtung / N','Interpreter','latex');
catch
fprintf('Achtung:Keine Daten für Fx(x,Ix) errechnet.\n')    
delete(p1)
end

try
p2=subplot(2,2,2);
surf(Ix_vec(1,:),x_vec(:,1)',map_xIxFy);
title('Kennfeld x-Richtung','Interpreter','latex');
xlabel('Differenzstrom in x-Richtung / A', 'Interpreter', 'latex');
ylabel('Wellenposition in x-Richtung / m', 'Interpreter', 'latex');
zlabel('Kraft in y-Richtung / N','Interpreter','latex');
catch
fprintf('Achtung:Keine Daten für Fy(x,Ix) errechnet.\n')    
delete(p2)
end

try
p3=subplot(2,2,3);
surf(Iy_vec(1,:),y_vec(:,1)',map_yIyFy);
title('Kennfeld y-Richtung','Interpreter','latex');
xlabel('Differenzstrom in y-Richtung / A', 'Interpreter', 'latex');
ylabel('Wellenposition in y-Richtung / m', 'Interpreter', 'latex');
zlabel('Kraft in y-Richtung / N','Interpreter','latex');
catch
fprintf('Achtung:Keine Daten für Fy(y,Iy) errechnet.\n')    
delete(p3)
end

try
p4=subplot(2,2,4);
surf(Iy_vec(1,:),y_vec(:,1)',map_yIyFx);
title('Kennfeld y-Richtung','Interpreter','latex');
xlabel('Differenzstrom in y-Richtung / A', 'Interpreter', 'latex');
ylabel('Wellenposition in y-Richtung / m', 'Interpreter', 'latex');
zlabel('Kraft in x-Richtung / N','Interpreter','latex');
catch
fprintf('Achtung:Keine Daten für Fx(y,Iy) errechnet.\n')  
delete(p4)
end
end

