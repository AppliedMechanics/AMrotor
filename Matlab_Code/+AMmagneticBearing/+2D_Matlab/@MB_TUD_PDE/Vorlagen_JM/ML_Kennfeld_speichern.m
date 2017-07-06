%% Vorlage zum Abspeichern des Kennfeldes

resultmatrix(iterationcounter,:)=[x y Ivmx Ivmy Isx Isy Fx Fy];

%Ergebnis in file schreiben
csvwrite('AnKFMagLag.csv',resultmatrix);
