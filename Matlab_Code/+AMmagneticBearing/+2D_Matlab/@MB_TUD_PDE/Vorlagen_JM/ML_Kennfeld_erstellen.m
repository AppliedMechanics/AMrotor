%% Vorlage zum Erstellen des Kennfeldes

%Parameter der Datenpunkte
itx=0;                  %Stromschritte x-Richtung
ity=-0.7:0.1:0.7;       %Stromschritte y-Richtung
itIvmx=0;               %Vormagnetisierungsstrom x-Richtung
itIvmy=5;               %Vormagnetisierungsstrom y-Richtung
itIsx=0;                %Spalt x-Richtung
itIsy=-5:0.25:5;        %Spaltschritte y-Richtung

%Iteration ueber Datenpkt
iterationcounter=0;
for Isy=itIsy
    for y=ity
        %Ergebnis in Matrix schreiben
        iterationcounter=iterationcounter+1;
        resultmatrix(iterationcounter,:)=[x y Ivmx Ivmy Isx Isy Fx Fy];
    end
end
