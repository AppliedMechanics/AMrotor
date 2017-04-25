%% Runup and unbalance identification
% CW - 12.04.2017
% Demo für WiBe
% Unwuchtsmatrixaufbau: - [zUnwucht, BetragUnwucht, PhaseUnwucht] 
clear all

mlib('SelectBoard');

DrehzahlSoll=400; %nicht groesser als 2000 U/min
DrehzahlSoll2=800;

Wellenlaenge = 0.59; %Abstand zwischen den beiden Auflagern in Meter
Eigenfrequenz = 63.5*2*pi;   %Eigenfrequenz des Rotors in rad/sec.

if DrehzahlSoll > 2000
    DrehzahlSoll = 0;
    disp('Chosen rotation speed to high. Speed set to 0.')
end

% Fahre Rotor hoch, mache Messung, fahre Rotor wieder herunter
Ziel_Adr=mlib('GetTrcVar','Model Root/Drehzahlsoll (U//min)/Value');
input(['Press ENTER to set rotation speed to ',num2str(DrehzahlSoll),' rpm. Cancel with CTRL+C.'],'s');
mlib('Write',Ziel_Adr,'Data',DrehzahlSoll);
pause(5)
data(1,:,:)=Messung2();
mlib('Write',Ziel_Adr,'Data',0);


if DrehzahlSoll2 > 2000
    DrehzahlSoll2 = 0;
    disp('Chosen rotation speed to high. Speed set to 0.')
end

% Fahre Rotor hoch, mache Messung, fahre Rotor wieder herunter
Ziel_Adr=mlib('GetTrcVar','Model Root/Drehzahlsoll (U//min)/Value');
input(['Press ENTER to set rotation speed to ',num2str(DrehzahlSoll2),' rpm. Cancel with CTRL+C.'],'s');
mlib('Write',Ziel_Adr,'Data',DrehzahlSoll2);
pause(5)
data(2,:,:)=Messung2();
mlib('Write',Ziel_Adr,'Data',0);

%Grundunwucht
[z1(1), Unwucht(1), phi(1)]= UnwuchtSchaetzerV01_CW_JM(data);

sprintf('Add unbalance')

% Fahre Rotor hoch, mache Messung, fahre Rotor wieder herunter
Ziel_Adr=mlib('GetTrcVar','Model Root/Drehzahlsoll (U//min)/Value');
input(['Add unbalance and press ENTER to set rotation speed to ',num2str(DrehzahlSoll),' rpm. Cancel with CTRL+C.'],'s');
mlib('Write',Ziel_Adr,'Data',DrehzahlSoll);
pause(5)
data(1,:,:)=Messung2();
mlib('Write',Ziel_Adr,'Data',0);

if DrehzahlSoll2 > 2000
    DrehzahlSoll2 = 0;
    disp('Chosen rotation speed to high. Speed set to 0.')
end

% Fahre Rotor hoch, mache Messung, fahre Rotor wieder herunter
Ziel_Adr=mlib('GetTrcVar','Model Root/Drehzahlsoll (U//min)/Value');
input(['Press ENTER to set rotation speed to ',num2str(DrehzahlSoll2),' rpm. Cancel with CTRL+C.'],'s');
mlib('Write',Ziel_Adr,'Data',DrehzahlSoll2);
pause(5)
data(2,:,:)=Messung2();
mlib('Write',Ziel_Adr,'Data',0);

%Zusatzunwucht
[z1(2), Unwucht(2), phi(2)]= UnwuchtSchaetzerV01_CW_JM(data);

%Differenz und Zusatzunwucht herausrechnen
u1=Unwucht(1)*exp(1i*phi(1));
u2=Unwucht(2)*exp(1i*phi(2));

du=u2-u1;
dUnwucht=abs(du)
dPhi=phase(du)

figure('units','normalized','outerposition',[0 0 1 1]);
compass(du);
