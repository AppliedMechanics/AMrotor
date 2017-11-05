%% Configuration of the MagneticBearing

%% Geometry

  cnfg.coil.n_Windungen=216;        % Anzahl der Windungen pro Spule
  cnfg.coil.area=2*0.0039*0.005;   %m^2
 
  cnfg.geometry.dTiefe=0.027;           % "Tiefe" der 2D-Simulation in m


  cnfg.geometry.rect(1).name='Kontrollraum';
  cnfg.geometry.rect(1).geo=[3,4,-0.15, 0.15, 0.15, -0.15,-0.15,-0.15,0.15,0.15];
 
 %Eisenkern
  cnfg.geometry.rect(2).name='Polvoll_1';
  cnfg.geometry.rect(2).geo=[3,4,-0.014, 0.014, 0.014,-0.014, 0,0,0.09, 0.09];
 
  cnfg.geometry.rect(3).name='Polvoll_2';
  cnfg.geometry.rect(3).geo=[3,4,-0.014, 0.014, 0.014,-0.014, 0,0,-0.09,-0.09];
  cnfg.geometry.rect(4).name='Polvoll_3';
  cnfg.geometry.rect(4).geo=[3,4, 0,0,0.09, 0.09,-0.014, 0.014, 0.014,-0.014];
 
  cnfg.geometry.rect(5).name='Polvoll_4';
  cnfg.geometry.rect(5).geo=[3,4, 0,0,-0.09, -0.09,-0.014, 0.014, 0.014,-0.014];
 
 %
 
  cnfg.geometry.rect(6).name='Polabzug_1';
  cnfg.geometry.rect(6).geo=[3,4,-0.007, 0.007,0.007,-0.007,0, 0, 0.076,0.076];

  cnfg.geometry.rect(7).name='Polabzug_2';
  cnfg.geometry.rect(7).geo=[3,4,-0.007, 0.007,0.007,-0.007,0, 0, -0.076,-0.076];

  cnfg.geometry.rect(8).name='Polabzug_3';
  cnfg.geometry.rect(8).geo=[3,4,0, 0, 0.076,0.076,-0.007, 0.007,0.007,-0.007];

  cnfg.geometry.rect(9).name='Polabzug_4';
  cnfg.geometry.rect(9).geo=[3,4,0, 0, -0.076,-0.076,-0.007, 0.007,0.007,-0.007];

 %
  cnfg.geometry.circ(1).name='KreisAbzug';
  cnfg.geometry.circ(1).geo=[1,0,0,0.025,0,0,0,0,0,0];
 
 % LÃ¶cher Abzug
  cnfg.geometry.circ(2).name='Loch1_1';
  cnfg.geometry.circ(2).geo=[1,-0.007,0.085,0.00175,0,0,0,0,0,0];
  cnfg.geometry.circ(3).name='Loch2_1';
  cnfg.geometry.circ(3).geo=[1,0.007,0.085,0.00175,0,0,0,0,0,0];
 
  cnfg.geometry.circ(4).name='Loch1_2';
  cnfg.geometry.circ(4).geo=[1,-0.007,-0.085,0.00175,0,0,0,0,0,0];
  cnfg.geometry.circ(5).name='Loch2_2';
  cnfg.geometry.circ(5).geo=[1,0.007,-0.085,0.00175,0,0,0,0,0,0];
 
  cnfg.geometry.circ(6).name='Loch1_3';
  cnfg.geometry.circ(6).geo=[1,0.085,-0.007,0.00175,0,0,0,0,0,0];
  cnfg.geometry.circ(7).name='Loch2_3';
  cnfg.geometry.circ(7).geo=[1,0.085,0.007,0.00175,0,0,0,0,0,0];
 
  cnfg.geometry.circ(8).name='Loch1_4';
  cnfg.geometry.circ(8).geo=[1,-0.085,-0.007,0.00175,0,0,0,0,0,0];
  cnfg.geometry.circ(9).name='Loch2_4';
  cnfg.geometry.circ(9).geo=[1,-0.085,0.007,0.00175,0,0,0,0,0,0];

 %Spulen
  cnfg.geometry.rect(10).name='Spule1_1';
  cnfg.geometry.rect(10).geo=[3,4,-0.02,-0.015,-0.015,-0.02,0.036,0.036,0.075,0.075]; 
  cnfg.geometry.rect(11).name='Spule2_1';
  cnfg.geometry.rect(11).geo=[3,4,-0.006,-0.001,-0.001,-0.006,0.036,0.036,0.075,0.075];
  cnfg.geometry.rect(12).name='Spule3_1';
  cnfg.geometry.rect(12).geo=[3,4,0.001,0.006,0.006,0.001,0.036,0.036,0.075,0.075];
  cnfg.geometry.rect(13).name='Spule4_1';
  cnfg.geometry.rect(13).geo=[3,4,0.015,0.02,0.02,0.015,0.036,0.036,0.075,0.075];
 
  cnfg.geometry.rect(14).name='Spule1_2';
  cnfg.geometry.rect(14).geo=[3,4,-0.02,-0.015,-0.015,-0.02,-0.036,-0.036,-0.075,-0.075]; 
  cnfg.geometry.rect(15).name='Spule2_2';
  cnfg.geometry.rect(15).geo=[3,4,-0.006,-0.001,-0.001,-0.006,-0.036,-0.036,-0.075,-0.075];
  cnfg.geometry.rect(16).name='Spule3_2';
  cnfg.geometry.rect(16).geo=[3,4,0.001,0.006,0.006,0.001,-0.036,-0.036,-0.075,-0.075];
  cnfg.geometry.rect(17).name='Spule4_2';
  cnfg.geometry.rect(17).geo=[3,4,0.015,0.02,0.02,0.015,-0.036,-0.036,-0.075,-0.075];
 
  cnfg.geometry.rect(18).name='Spule1_3';
  cnfg.geometry.rect(18).geo=[3,4,0.036,0.036,0.075,0.075,-0.02,-0.015,-0.015,-0.02]; 
  cnfg.geometry.rect(19).name='Spule2_3';
  cnfg.geometry.rect(19).geo=[3,4,0.036,0.036,0.075,0.075,-0.006,-0.001,-0.001,-0.006];
  cnfg.geometry.rect(20).name='Spule3_3';
  cnfg.geometry.rect(20).geo=[3,4,0.036,0.036,0.075,0.075,0.001,0.006,0.006,0.001];
  cnfg.geometry.rect(21).name='Spule4_3';
  cnfg.geometry.rect(21).geo=[3,4,0.036,0.036,0.075,0.075,0.015,0.02,0.02,0.015];
 
  cnfg.geometry.rect(22).name='Spule1_4';
  cnfg.geometry.rect(22).geo=[3,4,-0.036,-0.036,-0.075,-0.075,-0.02,-0.015,-0.015,-0.02]; 
  cnfg.geometry.rect(23).name='Spule2_4';
  cnfg.geometry.rect(23).geo=[3,4,-0.036,-0.036,-0.075,-0.075,-0.006,-0.001,-0.001,-0.006];
  cnfg.geometry.rect(24).name='Spule3_4';
  cnfg.geometry.rect(24).geo=[3,4,-0.036,-0.036,-0.075,-0.075,0.001,0.006,0.006,0.001];
  cnfg.geometry.rect(25).name='Spule4_4';
  cnfg.geometry.rect(25).geo=[3,4,-0.036,-0.036,-0.075,-0.075,0.015,0.02,0.02,0.015];
 
 %Rotorwelle
  cnfg.geometry.circ(10).name='Rotor';
  cnfg.geometry.circ(10).geo=[1,0,0,0.023,0,0,0,0,0,0];
 
 % Formel
 cnfg.geometry.sf=['Kontrollraum', ...
   '+Polvoll_1+Polvoll_2+Polvoll_3+Polvoll_3', ...
   '-Polabzug_1-Polabzug_2-Polabzug_3-Polabzug_4', ...
   '-Loch1_1-Loch2_1-Loch1_2-Loch2_2-Loch1_3-Loch2_3-Loch1_4-Loch2_4', ...
   '-KreisAbzug', ...
   '+Spule1_1+Spule2_1+Spule3_1+Spule4_1+Spule1_2+Spule2_2+Spule3_2+Spule4_2+Spule1_3+Spule2_3+Spule3_3+Spule4_3+Spule1_4+Spule2_4+Spule3_4+Spule4_4', ...
   '+Rotor'];

%% Material 

     cnfg.material.nonlinMu =0;

% Permeabilität im Vakuum   
     cnfg.material.mu_0=4*pi*10^(-7);
    
% relative Permeabilitaeten
     cnfg.material.mu_rLuft=1+4E-7;
     cnfg.material.mu_rEisen=10000;
     cnfg.material.mu_rKupfer=1-6E-6;    

% Absolute Permeabilitaeten
     cnfg.material.mu_Luft =  cnfg.material.mu_rLuft* cnfg.material.mu_0; 
     cnfg.material.mu_Eisen =  cnfg.material.mu_rEisen* cnfg.material.mu_0;
     cnfg.material.mu_Kupfer =  cnfg.material.mu_rKupfer* cnfg.material.mu_0;

%% Flächenzuornungen
cnfg.faces.Luft=[3,24,27,30,28,25,26,23,29];
cnfg.faces.Eisen=[1,2,6,4,5];
cnfg.faces.SpuleA_1=[7,9];
cnfg.faces.SpuleB_1=[8,11];
cnfg.faces.SpuleA_2=[15,21];
cnfg.faces.SpuleB_2=[17,19];
cnfg.faces.SpuleA_3=[12,14];
cnfg.faces.SpuleB_3=[13,10];
cnfg.faces.SpuleA_4=[22,16];
cnfg.faces.SpuleB_4=[20,18];
cnfg.Wellenknoten=[133:148,556:563];
cnfg.edges.Dirichlet=[1,2,10,11];