%% Vorlage zum Plot des Kennfeldes

data=csvread('simforceoutput.csv');
%Skalierung auf Lagerbreite

xscale=csvread('mgdat1.csv');
yscale=csvread('mgdat2.csv');
[xpkt, ypkt]=meshgrid(xscale,yscale);

%meshgrid fuer plot
%xscale=itIsy;
%yscale=ity
%[xpkt ypkt]=meshgrid(itIsy,ity);

%% Plot erstellen
pos=1;
for n1=1:length(xscale)
    plotdata(:,n1)=resultmatrix(pos:pos+length(yscale)-1,8);
    pos=pos+length(yscale);
end
mesh(xpkt,ypkt,plotdata)
axis tight;
title('Kennfeld des Magnetlagers, analytisch berechnet, Vormagnetisierungsstrom 5A');
xlabel('Steuerstrom in y-Richtung in A');
ylabel('y-Position in mm');
zlabel('Kraft in y-Richtung in N');