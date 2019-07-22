clear
load('pidSimulink.mat')
figure
plot(out.time,out.Data(:,2))
xlabel('t/$s$','Interpreter','latex')
ylabel('displacement/$m$','Interpreter','latex')
title('From Simulink')