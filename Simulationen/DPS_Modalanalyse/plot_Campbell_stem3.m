% plot_Campbell_stem3

function plot_Campbell_stem3(CmpDiagram,amp)

omega = CmpDiagram.experimentCampbell.get_omega();
EW = CmpDiagram.experimentCampbell.get_eigenvalues();
EF.forward = imag(EW.forward);
EF.backward = imag(EW.backward);

Color1 = 'blue';
Color2 = 'blue';
Color3 = 'red';
Color4 = 'green';

achse = gca;
hold on
stem3(achse,omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color1) % 1. Harmonische
stem3(achse,2*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color1) % 2. Harmonische
stem3(achse,3*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color1) % 3. Harmonische
stem3(achse,4*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color1) % 4. Harmonische

stem3(achse,-omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color2) % 1. Harmonische
stem3(achse,-2*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color2) % 2. Harmonische
stem3(achse,-3*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color2) % 3. Harmonische
stem3(achse,-4*omega/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color2) % 4. Harmonische

for f=1:size(EF.forward,1)
stem3(achse,(EF.forward(f,:))/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color3)
end
achse = gca
for f=1:size(EF.backward,1)
stem3(achse,-(EF.backward(f,:))/2/pi,omega/2/pi,ones(size(omega))*amp,'Color',Color3)
end

% for f=1:size(EF.forward,1)
% stem3(achse,-(EF.forward(f,:))/2/pi,omega/2/pi,ones(size(omega))*amp)
% end
% for f=1:size(EF.backward,1)
% stem3(achse,-(EF.backward(f,:))/2/pi,omega/2/pi,ones(size(omega))*amp)
% end

end