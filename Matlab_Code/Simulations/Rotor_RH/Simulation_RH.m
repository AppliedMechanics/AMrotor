%% Simulation zur Überprüfung des Monitorings
% Bachelorarbeit Robert Höfer

%% Header

% Johannes Maierhofer
% 23.08.2017, 29.08.2017, 04.09.2017

%% Import

import AMrotorSIM.*

%% Clean up
close all
clear all
clc

diary log.txt
diary on

%% Compute Rotor

Config_Sim_RH
%Config_Sim_RH_a

% Unwucht -----------------------------------------------------------------
 cnfg.cnfg_unbalance(1).name = 'Geplante Unwucht';
 cnfg.cnfg_unbalance(1).position = 507.5e-3;    %[m]
 cnfg.cnfg_unbalance(1).betrag = 1e-4;          %[kgm]
 cnfg.cnfg_unbalance(1).winkellage = 0;         %[rad]
%--------------------------------------------------------------------------

r=Rotorsystem(cnfg,'RotorSystem');
r.show;

r.rotor.mesh();

g=Graphs.Visu_Rotorsystem(r);
g.show();

r.compute_matrices();
r.compute_loads();

r.transform_StateSpace();


%% Running system analyses

m=Experiments.Modalanalyse(r);
% 
m.calculate_rotor_only(6,200);

Aev= m.eigenmatrizen.Aev_x;
eigenvektor= Aev(:,4);
eigenwert = m.eigenmatrizen.Aew;

plot(real(eigenvektor));
eigenvektor_real = real(eigenvektor);

save 'Eigenvektor_25.09.2017_modex.mat' eigenvektor_real

% esf2= Graphs.Eigenschwingformen(m);
% esf2.plot_displacements();

%% Running Time Simulation

St_Lsg = Experiments.Stationaere_Lsg(r,[100:50:500],[0:0.001:1]);
St_Lsg.show()
St_Lsg.compute_ode15s_ss

%------------- Erzeuge Ausgabeformat der Lösung ---------------

d = Dataoutput.TimeDataOutput(St_Lsg);
dataset_monitoring = d.compose_data;
save 'dataset_monitoring_Unwucht1e-4_0.mat' dataset_monitoring

temp=dataset_monitoring(300);
sx_r=temp('F_x (Kraftsensor rechts)');
sx_l=temp('F_x (Kraftsensor links)');
figure();
plot(sx_l)
hold on
plot(sx_r)


%------------- Erzeuge Grafiken aus Lösung -------------------

% t = Graphs.TimeSignal(r, St_Lsg);
% o= Graphs.Orbitdarstellung(r, St_Lsg);
% f = Graphs.Fourierdarstellung(r, St_Lsg);
% fo = Graphs.Fourierorbitdarstellung(r, St_Lsg);
% w = Graphs.Waterfalldiagramm(r, St_Lsg);

for sensor = r.sensors
%         t.plot(sensor);
%         o.plot(sensor);
%          f.plot(sensor);
%          fo.plot(sensor,1);
%          w.plot(sensor);
end
   
diary off