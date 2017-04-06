function EV_plot = plot_EV_EW(rotorpar,AevR,Aew,nodes,omega,EVomega,n_ew)

n=(EVomega-1)*n_ew+1;

disp('Eigenkreisfrequenzen')
disp(imag(Aew(1,1))/(2*pi))
disp(imag(Aew(3,1))/(2*pi))
disp(imag(Aew(5,1))/(2*pi))



EV_plot=[];
Lagerpos = [rotorpar.bearing_pos1,rotorpar.bearing_pos2,rotorpar.bearing_pos3,rotorpar.bearing_pos4];
figure
plot(nodes,(AevR(1:2:end,n)/norm(AevR(:,n))),'g', Lagerpos,interp1(nodes,(AevR(1:2:end,n)/norm(AevR(:,n))),Lagerpos,'spline'),'ob');
hold on 
plot(nodes,(AevR(1:2:end,n+1)/norm(AevR(:,n+1))),'r', Lagerpos,interp1(nodes,(AevR(1:2:end,n+1)/norm(AevR(:,n+1))),Lagerpos,'spline'),'ob');
hold on
plot(nodes,(AevR(1:2:end,n+2)/norm(AevR(:,n+2))),'k', Lagerpos,interp1(nodes,(AevR(1:2:end,n+2)/norm(AevR(:,n+2))),Lagerpos,'spline'),'ob');
hold off

figure
plot(omega,omega,'b', omega,imag(Aew(1,:)),'g', omega,imag(Aew(2,:)),'g', omega,imag(Aew(3,:)),'r', omega,imag(Aew(4,:)),'r', omega,imag(Aew(5,:)),'k', omega,imag(Aew(6,:)),'k');




