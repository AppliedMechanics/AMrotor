% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [f,frf,C,Cx] = get_frf(obj)
% Extracts properties from Frequenzgangfunktion object
%
%    :return: Properties of type f, H, C and Cx

f=obj.f;
frf=obj.H;

% Abfrage, ob Coherence und Cx existiert und dann opional auslesen
if isprop(obj,'C')
    C = obj.C;
end

if isprop(obj,'Cx')
    Cx = obj.Cx;
end

end