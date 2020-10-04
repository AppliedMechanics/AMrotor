% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [x] = FourierFit(time,signal,Drehzahl, Ordnung)
% Carries out the Fourier fitting 
%
%    :param time: Time vector
%    :type time: vector
%    :param signal: Sensor signal (data)
%    :type signal: vector
%    :param Drehzahl: Rotation speed (rpm)
%    :type Drehzahl: vector
%    :param Ordnung: Order of the Fourier fit from 1 to 8
%    :type Ordnung: double
%    :return: Vector of fitted values x

fo = fitoptions('Method','NonlinearLeastSquares',...
    'Lower',[-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0.8*Drehzahl*pi/30], ...
    'upper',[ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,  1.2*Drehzahl*pi/30],...
    'Startpoint',[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,Drehzahl*pi/30]);

ft = fittype('a0+a1*cos(w*x)+b1*sin(w*x)+a2*cos(2*w*x)+b2*sin(2*w*x)+a3*cos(3*w*x)+b3*sin(3*w*x)+a4*cos(4*w*x)+b4*sin(4*w*x)+a5*cos(5*w*x)+b5*sin(5*w*x)+a6*cos(6*w*x)+b6*sin(6*w*x)+a7*cos(7*w*x)+b7*sin(7*w*x)+a8*cos(8*w*x)+b8*sin(8*w*x)'...
    ,'independent','x');


FX8 = fit(time',signal',ft,fo);
t = time;
    switch Ordnung
        case 1
            x   = FX8.a0+FX8.a1*cos(FX8.w*t)+FX8.b1*sin(FX8.w*t);
        case 2
            x   = FX8.a0+FX8.a1*cos(FX8.w*t)+FX8.b1*sin(FX8.w*t)+FX8.a2*cos(2*FX8.w*t)+FX8.b2*sin(2*FX8.w*t);
        case 3
            x   = FX8.a0+FX8.a1*cos(FX8.w*t)+FX8.b1*sin(FX8.w*t)+FX8.a2*cos(2*FX8.w*t)+FX8.b2*sin(2*FX8.w*t)+FX8.a3*cos(3*FX8.w*t)+FX8.b3*sin(3*FX8.w*t);
        case 4
            x   = FX8.a0+FX8.a1*cos(FX8.w*t)+FX8.b1*sin(FX8.w*t)+FX8.a2*cos(2*FX8.w*t)+FX8.b2*sin(2*FX8.w*t)+FX8.a3*cos(3*FX8.w*t)+FX8.b3*sin(3*FX8.w*t)+FX8.a4*cos(4*FX8.w*t)+FX8.b4*sin(4*FX8.w*t);
        case 5
            x   = FX8.a0+FX8.a1*cos(FX8.w*t)+FX8.b1*sin(FX8.w*t)+FX8.a2*cos(2*FX8.w*t)+FX8.b2*sin(2*FX8.w*t)+FX8.a3*cos(3*FX8.w*t)+FX8.b3*sin(3*FX8.w*t)+FX8.a4*cos(4*FX8.w*t)+FX8.b4*sin(4*FX8.w*t)...
                  +FX8.a5*cos(5*FX8.w*t)+FX8.b5*sin(5*FX8.w*t);
        case 6
            x   = FX8.a0+FX8.a1*cos(FX8.w*t)+FX8.b1*sin(FX8.w*t)+FX8.a2*cos(2*FX8.w*t)+FX8.b2*sin(2*FX8.w*t)+FX8.a3*cos(3*FX8.w*t)+FX8.b3*sin(3*FX8.w*t)+FX8.a4*cos(4*FX8.w*t)+FX8.b4*sin(4*FX8.w*t)...
                  +FX8.a5*cos(5*FX8.w*t)+FX8.b5*sin(5*FX8.w*t)+FX8.a6*cos(6*FX8.w*t)+FX8.b6*sin(6*FX8.w*t)+FX8.a7*cos(7*FX8.w*t)+FX8.b7*sin(7*FX8.w*t)+FX8.a8*cos(8*FX8.w*t)+FX8.b8*sin(8*FX8.w*t);
        case 7
            x   = FX8.a0+FX8.a1*cos(FX8.w*t)+FX8.b1*sin(FX8.w*t)+FX8.a2*cos(2*FX8.w*t)+FX8.b2*sin(2*FX8.w*t)+FX8.a3*cos(3*FX8.w*t)+FX8.b3*sin(3*FX8.w*t)+FX8.a4*cos(4*FX8.w*t)+FX8.b4*sin(4*FX8.w*t)...
                  +FX8.a5*cos(5*FX8.w*t)+FX8.b5*sin(5*FX8.w*t)+FX8.a6*cos(6*FX8.w*t)+FX8.b6*sin(6*FX8.w*t)+FX8.a7*cos(7*FX8.w*t)+FX8.b7*sin(7*FX8.w*t);
        case 8
            x   = FX8.a0+FX8.a1*cos(FX8.w*t)+FX8.b1*sin(FX8.w*t)+FX8.a2*cos(2*FX8.w*t)+FX8.b2*sin(2*FX8.w*t)+FX8.a3*cos(3*FX8.w*t)+FX8.b3*sin(3*FX8.w*t)+FX8.a4*cos(4*FX8.w*t)+FX8.b4*sin(4*FX8.w*t)...
                  +FX8.a5*cos(5*FX8.w*t)+FX8.b5*sin(5*FX8.w*t)+FX8.a6*cos(6*FX8.w*t)+FX8.b6*sin(6*FX8.w*t)+FX8.a7*cos(7*FX8.w*t)+FX8.b7*sin(7*FX8.w*t)+FX8.a8*cos(8*FX8.w*t)+FX8.b8*sin(8*FX8.w*t);
    end
end



