function [f,frf,C,Cx] = get_frf(obj)
% just read all the values, because all the calculated frfs will be
% displayed
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