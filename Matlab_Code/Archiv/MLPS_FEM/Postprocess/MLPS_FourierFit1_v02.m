function [x] = MLPS_FourierFit1_v02(time,signal,Drehzahl)

fo = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0.8*Drehzahl*pi/30], ...
    'upper',[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  1.2*Drehzahl*pi/30],...
    'Startpoint',[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,Drehzahl*pi/30]);

ft = fittype('a0+a1*cos(w*x)+b1*sin(w*x)+a2*cos(2*w*x)+b2*sin(2*w*x)+a3*cos(3*w*x)+b3*sin(3*w*x)+a4*cos(4*w*x)+b4*sin(4*w*x)+a5*cos(5*w*x)+b5*sin(5*w*x)+a6*cos(6*w*x)+b6*sin(6*w*x)+a7*cos(7*w*x)+b7*sin(7*w*x)+a8*cos(8*w*x)+b8*sin(8*w*x)'...
    ,'independent','x');


FX8 = fit(time',signal',ft,fo);
t=time;
x   = FX8.a0+FX8.a1*cos(FX8.w*t)+FX8.b1*sin(FX8.w*t);

end