function [ Verschiebung ] = BerechneVerschiebung_MagLag( Position )
%   Name: BerechneVerschiebung_MagLag.m

%   Beschreibung: In Abhaengigkeit der aktuellen Wellenposition wird der
%   Verschiebeweg bestimmt

%   Bearbeiter: Paul Schuler

%   Benoetigte Toolbox: PDE
%   Benoetigte Skripten/Funktionen: FEM_MagLag, Geometrie_MagLag,
%   Init_MagLag, Solve_MagLag, Plots_MagLag


Verschiebeweg=0.005*1e-3;  % Verschiebeweg in X- und Y-Richtung

VZ1=1;                      % "standardmaessig" wird in positive X- und Y-Richtung verschoben
VZ2=1;

if (Position(1)>0)
    VZ1=-1;                % Wenn Welle rechts der Y-Achse liegt, wird sie nach links verschoben
end

if (Position(2)>0)         % Wenn Welle oberhalb der X-Achse liegt, wird sie nach unten verschoben
    VZ2=-1;
end

Verschiebung=[VZ1 VZ2]*Verschiebeweg;
    
end

