function [Koeff] = MuszynskaFunction(x,rpm)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

TestRigNeu1


init.omega0IR = [rpm*pi/30;0;0];        % Einheit rad/s
sys.gamma0 = 0.4;%0.4; %ratio of fluid circumferential average velocity: gamma0 < 0.5
sys.alpha=0;

sys.ecc = sqrt(x(1)^2+x(2)^2)/sys.rL; %eccentricity factor: 0 < ecc < 1
%[ Koeff ] = MuszynskaModelNew( sys,init );
[ Koeff ] = MuszynskaModelNewLaminar( sys,init );
Koeff.Ms=[Koeff.M_xx Koeff.m_xy;Koeff.m_yx Koeff.M_xx];
Koeff.Cs= [Koeff.C_xx Koeff.c_xy; Koeff.c_yx Koeff.C_yy];
Koeff.Ks= [Koeff.K_xx Koeff.k_xy; Koeff.k_yx Koeff.K_yy];
end

