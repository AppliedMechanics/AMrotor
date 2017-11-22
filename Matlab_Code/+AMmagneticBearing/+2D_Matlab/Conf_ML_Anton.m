function config=Conf_ML_Anton()
% Erzeugung der Konfigurationsvariable für ein Magnetlager der Klasse
% MagneticBearing
% Für Eigenschaften der cnfg-Variable siehe Hauptcode
% Simulation_JM_Diplace.m
%% Configuration of the MagneticBearing
cnfg.name='Anton';

%% Geometry
  cnfg.coil.n_Windungen=216;        % Anzahl der Windungen pro Spule
  cnfg.coil.area=2*0.0039*0.005;   %m^2
 
  cnfg.geometry.dTiefe=0.027;           % "Tiefe" der 2D-Simulation in m


  geometry.rect(1).name='Kontrollraum';
  geometry.rect(1).geo=[3,4,-0.15, 0.15, 0.15, -0.15,-0.15,-0.15,0.15,0.15];
 
 %Eisenkern
  geometry.rect(2).name='Polvoll_1';
  geometry.rect(2).geo=[3,4,-0.014, 0.014, 0.014,-0.014, 0,0,0.09, 0.09];
 
  geometry.rect(3).name='Polvoll_2';
  geometry.rect(3).geo=[3,4,-0.014, 0.014, 0.014,-0.014, 0,0,-0.09,-0.09];
  geometry.rect(4).name='Polvoll_3';
  geometry.rect(4).geo=[3,4, 0,0,0.09, 0.09,-0.014, 0.014, 0.014,-0.014];
 
  geometry.rect(5).name='Polvoll_4';
  geometry.rect(5).geo=[3,4, 0,0,-0.09, -0.09,-0.014, 0.014, 0.014,-0.014];
 
 %
 
  geometry.rect(6).name='Polabzug_1';
  geometry.rect(6).geo=[3,4,-0.007, 0.007,0.007,-0.007,0, 0, 0.076,0.076];

  geometry.rect(7).name='Polabzug_2';
  geometry.rect(7).geo=[3,4,-0.007, 0.007,0.007,-0.007,0, 0, -0.076,-0.076];

  geometry.rect(8).name='Polabzug_3';
  geometry.rect(8).geo=[3,4,0, 0, 0.076,0.076,-0.007, 0.007,0.007,-0.007];

  geometry.rect(9).name='Polabzug_4';
  geometry.rect(9).geo=[3,4,0, 0, -0.076,-0.076,-0.007, 0.007,0.007,-0.007];

 %
  geometry.circ(1).name='KreisAbzug';
  geometry.circ(1).geo=[1,0,0,0.025,0,0,0,0,0,0];
 
 % LÃ¶cher Abzug
  geometry.circ(2).name='Loch1_1';
  geometry.circ(2).geo=[1,-0.007,0.085,0.00175,0,0,0,0,0,0];
  geometry.circ(3).name='Loch2_1';
  geometry.circ(3).geo=[1,0.007,0.085,0.00175,0,0,0,0,0,0];
 
  geometry.circ(4).name='Loch1_2';
  geometry.circ(4).geo=[1,-0.007,-0.085,0.00175,0,0,0,0,0,0];
  geometry.circ(5).name='Loch2_2';
  geometry.circ(5).geo=[1,0.007,-0.085,0.00175,0,0,0,0,0,0];
 
  geometry.circ(6).name='Loch1_3';
  geometry.circ(6).geo=[1,0.085,-0.007,0.00175,0,0,0,0,0,0];
  geometry.circ(7).name='Loch2_3';
  geometry.circ(7).geo=[1,0.085,0.007,0.00175,0,0,0,0,0,0];
 
  geometry.circ(8).name='Loch1_4';
  geometry.circ(8).geo=[1,-0.085,-0.007,0.00175,0,0,0,0,0,0];
  geometry.circ(9).name='Loch2_4';
  geometry.circ(9).geo=[1,-0.085,0.007,0.00175,0,0,0,0,0,0];

 %Spulen
  geometry.rect(10).name='Spule1_1';
  geometry.rect(10).geo=[3,4,-0.02,-0.015,-0.015,-0.02,0.036,0.036,0.075,0.075]; 
  geometry.rect(11).name='Spule2_1';
  geometry.rect(11).geo=[3,4,-0.006,-0.001,-0.001,-0.006,0.036,0.036,0.075,0.075];
  geometry.rect(12).name='Spule3_1';
  geometry.rect(12).geo=[3,4,0.001,0.006,0.006,0.001,0.036,0.036,0.075,0.075];
  geometry.rect(13).name='Spule4_1';
  geometry.rect(13).geo=[3,4,0.015,0.02,0.02,0.015,0.036,0.036,0.075,0.075];
 
  geometry.rect(14).name='Spule1_2';
  geometry.rect(14).geo=[3,4,-0.02,-0.015,-0.015,-0.02,-0.036,-0.036,-0.075,-0.075]; 
  geometry.rect(15).name='Spule2_2';
  geometry.rect(15).geo=[3,4,-0.006,-0.001,-0.001,-0.006,-0.036,-0.036,-0.075,-0.075];
  geometry.rect(16).name='Spule3_2';
  geometry.rect(16).geo=[3,4,0.001,0.006,0.006,0.001,-0.036,-0.036,-0.075,-0.075];
  geometry.rect(17).name='Spule4_2';
  geometry.rect(17).geo=[3,4,0.015,0.02,0.02,0.015,-0.036,-0.036,-0.075,-0.075];
 
  geometry.rect(18).name='Spule1_3';
  geometry.rect(18).geo=[3,4,0.036,0.036,0.075,0.075,-0.02,-0.015,-0.015,-0.02]; 
  geometry.rect(19).name='Spule2_3';
  geometry.rect(19).geo=[3,4,0.036,0.036,0.075,0.075,-0.006,-0.001,-0.001,-0.006];
  geometry.rect(20).name='Spule3_3';
  geometry.rect(20).geo=[3,4,0.036,0.036,0.075,0.075,0.001,0.006,0.006,0.001];
  geometry.rect(21).name='Spule4_3';
  geometry.rect(21).geo=[3,4,0.036,0.036,0.075,0.075,0.015,0.02,0.02,0.015];
 
  geometry.rect(22).name='Spule1_4';
  geometry.rect(22).geo=[3,4,-0.036,-0.036,-0.075,-0.075,-0.02,-0.015,-0.015,-0.02]; 
  geometry.rect(23).name='Spule2_4';
  geometry.rect(23).geo=[3,4,-0.036,-0.036,-0.075,-0.075,-0.006,-0.001,-0.001,-0.006];
  geometry.rect(24).name='Spule3_4';
  geometry.rect(24).geo=[3,4,-0.036,-0.036,-0.075,-0.075,0.001,0.006,0.006,0.001];
  geometry.rect(25).name='Spule4_4';
  geometry.rect(25).geo=[3,4,-0.036,-0.036,-0.075,-0.075,0.015,0.02,0.02,0.015];
 
 %Rotorwelle
  geometry.circ(10).name='Rotor';
  geometry.circ(10).geo=[1,0,0,0.023,0,0,0,0,0,0];
%   geometry.circ(11).name='Rotor2';
%   geometry.circ(11).geo=[1,0,0,0.0228,0,0,0,0,0,0];
 % Formel
 sf=['Kontrollraum', ...
   '+Polvoll_1+Polvoll_2+Polvoll_3+Polvoll_3', ...
   '-Polabzug_1-Polabzug_2-Polabzug_3-Polabzug_4', ...
   '-Loch1_1-Loch2_1-Loch1_2-Loch2_2-Loch1_3-Loch2_3-Loch1_4-Loch2_4', ...
   '-KreisAbzug', ...
   '+Spule1_1+Spule2_1+Spule3_1+Spule4_1+Spule1_2+Spule2_2+Spule3_2+Spule4_2+Spule1_3+Spule2_3+Spule3_3+Spule4_3+Spule1_4+Spule2_4+Spule3_4+Spule4_4'];

%% Material 
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
cnfg.faces.Welle=6;
cnfg.edges.Dirichlet=[1,2,10,11];

cnfg.geometry.r_Welle=geometry.circ(10).geo(4);
cnfg.geometry.r_Luftspalt_Aussen=geometry.circ(1).geo(4);
%% Geometrie zusammensetzen
gm=horzcat(reshape([geometry.rect(:).geo],10,[]),...
           reshape([geometry.circ(:).geo],10,[]));
ns=char(...
   horzcat(         {geometry.rect(:).name},...
                    {geometry.circ(:).name}))';
    
[cnfg.geometry.dl,bt]=decsg(gm,sf,ns);                    % Erzeugen der Geometrie 
% Ohne zweiten Kreis in Welle:
edges.delete=[8,176,93,22,114,117,178,100,180,94,125,166,89,168,18,104,170,130,98,172,103,122,174,163, ...
              144,111,126,127,9,149,10,150,90,14,128,135,160,15,129,151,97,19,24,95,96,106,20,25,91,132,112,154,155,101,156,145,138,136,102,161,157,107,121,13,21,162,137,120,26,12,92,146,119,11,118,113,105,16,133,17];
% Mit zweitem Kreis in Welle:
% edges.delete=[196 194 188 186 192 190 184 182 14 116 109 110 117 17 138 136 172 149 107 144 153 28 152 27 26 151 25 24 118 119 29 30 176 120 121 177 122 178 123 179 16 115 23 108 20 137 173 167 145 21 146 142 18 148 165 166 102 103 13 130 162 129 128 10 11 127 112 113 104 105 141 133 170 171 12 134 135 15 101 34 114 161 22 100 106 99 19 143 160 98 97 9 8 22 33 154 32 33];
    
[cnfg.geometry.dl,~]=csgdel(cnfg.geometry.dl,bt, edges.delete);    % Loesche alle Kanten aus dem Array "KantenDel"
config=cnfg;
end