%%
%Fehlerdifferenz er, er1, er2
w_1 = [0,0]; %Sollgröße der Verschiebung = null
w_2 = [0,0];
dw_1 = [0,0];
dw_2 = [0,0];


err_1 = w_1-s_1; %Fehler = Sollgröße - Istgröße
err_2 = w_2-s_2;

i_err_1 = [dZ(2*4*par.nKnoten+2+1),dZ(2*4*par.nKnoten+2+1+1)];
i_err_2 = [dZ(2*4*par.nKnoten+2+1+2),dZ(2*4*par.nKnoten+2+1+3)];

d_err_1 = dw_1 - ds_1;
d_err_2 = dw_2 - ds_2;

%Regler
I_1 = [mag.Kp*err_1(1) + mag.Ki*i_err_1(1) + mag.Kd*d_err_1(1), mag.Kp*err_1(2) + mag.Ki*i_err_1(2) + mag.Kd*d_err_1(2)];
I_2 = [mag.Kp*err_2(1) + mag.Ki*i_err_2(1) + mag.Kd*d_err_2(1), mag.Kp*err_2(2) + mag.Ki*i_err_2(2) + mag.Kd*d_err_2(2)];

F_1=[mag.k_i*I_1(1) + mag.k_s*s_1(1),mag.k_i*I_1(2) + mag.k_s*s_1(2)];
F_2=[mag.k_i*I_2(1) + mag.k_s*s_2(1),mag.k_i*I_2(2) + mag.k_s*s_2(2)];

%%

Kraft1 = [F_1(1),F_1(2),0.1]; % [Fx, Fy, Position]
 [h] = Ergaenze_Inertialfeste_KraftCW(h,par,Kraft1);
Kraft2 = [F_2(1),F_2(2),0.6]; % [Fx, Fy, Position]
 [h] = Ergaenze_Inertialfeste_KraftCW(h,par,Kraft2);