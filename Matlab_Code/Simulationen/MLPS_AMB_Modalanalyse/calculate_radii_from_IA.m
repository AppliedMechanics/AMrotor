function [radiusOuter,radiusInner] = calculate_radii_from_IA(A,I)
%CALCULATE_RADII_FROM_IA 
%   Berechne den Innen- und Aussenradius eines Kreises der den
%   Flaecheninhalt A [m^2] und den Flaechentraegheitsmoment I [m^4]
%   enthaelt
%
%   Grundgleichungen sind, vgl. Formelsammlung TM (Rixen, TUM):
%       I = pi/4*(ro^4-ri^4)
%       A = pi*(ro^2-ri^2)
%
%   Fuer die Geometrievorgabe der Simulation eines konkreten Pruefstands.

radiusInner = sqrt(2*I./A - A./2/pi);
radiusOuter = sqrt( A./pi + radiusInner.^2 );

end

