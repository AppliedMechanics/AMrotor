function EV_plot = plot_EV_EW(rotorpar,AevR,Aew,nodes,omega,EVomega,n_ew)

n=(EVomega-1)*n_ew+1;

disp('Eigenkreisfrequenzen')
disp(imag(Aew(1,1))/(2*pi))
disp(imag(Aew(3,1))/(2*pi))
disp(imag(Aew(5,1))/(2*pi))



EV_plot=[];

figure
plot(nodes,((imag(AevR(1:2:end/2,n))/(imag(AevR(1:2:end/2,n))))),'g');
hold on 
plot(nodes,((imag(AevR(1:2:end/2,n+1)))/(imag(AevR(1:2:end/2,n+1)))),'r');
hold on
plot(nodes,((imag(AevR(1:2:end/2,n+2))/(imag(AevR(1:2:end/2,n+2))))),'k');
hold off

figure
plot(omega,omega,'b', omega,imag(Aew(1,:)),'g', omega,imag(Aew(2,:)),'g', omega,imag(Aew(3,:)),'r', omega,imag(Aew(4,:)),'r', omega,imag(Aew(5,:)),'k', omega,imag(Aew(6,:)),'k');



%plot(omega/pi/2,omega/pi/2,'b', omega/pi/2,imag(Aew(1,:))/2/pi,'g', omega/pi/2,imag(Aew(2,:))/2/pi,'g', omega/pi/2,imag(Aew(3,:))/2/pi,'r', omega/pi/2,imag(Aew(4,:))/2/pi,'r', omega/pi/2,imag(Aew(5,:))/2/pi,'k', omega/pi/2,imag(Aew(6,:))/2/pi,'k');
