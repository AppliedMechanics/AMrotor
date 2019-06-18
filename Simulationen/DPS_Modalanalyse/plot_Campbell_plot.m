% plot_Campbell_plot3

function plot_Campbell_plot(CmpDiagram)

amp = 0;
omega = CmpDiagram.experimentCampbell.get_omega();
EW = CmpDiagram.experimentCampbell.get_eigenvalues();
EF.forward = imag(EW.forward);
EF.backward = imag(EW.backward);

Color1 = 'blue';
Color2 = 'blue';
Color3 = 'red';
Color4 = 'green';

LineWidth1=2;
LineWidth2=LineWidth1;
LineWidth3=LineWidth1;
LineWidth4=LineWidth1;

achse = gca;
hold on
plot3(achse,omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color1,'LineWidth',LineWidth1) % 1. Harmonische
plot3(achse,2*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color1,'LineWidth',LineWidth1) % 2. Harmonische
plot3(achse,3*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color1,'LineWidth',LineWidth1) % 3. Harmonische
plot3(achse,4*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color1,'LineWidth',LineWidth1) % 4. Harmonische

plot3(achse,-omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color2,'LineWidth',LineWidth2) % 1. Harmonische
plot3(achse,-2*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color2,'LineWidth',LineWidth2) % 2. Harmonische
plot3(achse,-3*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color2,'LineWidth',LineWidth2) % 3. Harmonische
plot3(achse,-4*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color2,'LineWidth',LineWidth2) % 4. Harmonische

for f=1:size(EF.forward,1)
plot3(achse,(EF.forward(f,:))/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color3,'LineWidth',LineWidth3)
end
achse = gca;
for f=1:size(EF.backward,1)
plot3(achse,-(EF.backward(f,:))/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color4,'LineWidth',LineWidth4)
end

% for f=1:size(EF.forward,1)
% plot3(achse,-(EF.forward(f,:))/2/pi,omega/2/pi,ones(size(omega))*amp)
% end
% for f=1:size(EF.backward,1)
% plot3(achse,-(EF.backward(f,:))/2/pi,omega/2/pi,ones(size(omega))*amp)
% end

end