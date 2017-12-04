function [mu_Luft,mu_Eisen,mu_Kupfer,mu_0, n_Windungen,dTiefe]=Stoffwerte_MagLag()
%   Name: Stoffwerte_MagLag.m

%   Beschreibung: Hier werden Stoffwerte der verschiedenen Phasen und
%   ein paar der Geometrie-Werte festgelegt

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Funktionen/Skripten: pdVA_MagLag.m, FEM_MagLag.m,
%   Geometrie_MagLag.m, Init_MagLag.m, Solve_MagLag.m
%   (SolveNonLin_MagLag.m)
%%%%%%%%%%%%%    

    n_Windungen=104;        % Anzahl der Windungen pro Spule
    dTiefe=0.032;           % "Tiefe" der 2D-Simulation in m
    
    mu_0=4*pi*10^(-7);      % Permeabilität im Vakuum
    
%       mu_rLuft=1+4E-7;       % relative Permeabilitaeten
    mu_rLuft=1;
    mu_rEisen=10000;
%       mu_rKupfer=1-6E-6;
    mu_rKupfer=1;    

    mu_Luft= mu_rLuft*mu_0; % Absolute Permeabilitaeten
    mu_Eisen=mu_rEisen*mu_0;
    mu_Kupfer=mu_rKupfer*mu_0;
end