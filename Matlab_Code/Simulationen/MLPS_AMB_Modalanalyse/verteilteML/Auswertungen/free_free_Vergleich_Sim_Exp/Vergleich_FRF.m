clear, close all

%% Vergleiche FRF aus Run 3 (W:\Rotordynamik\MLPS-Magnetlagerpruefstand\90_ModalAnalyse_2019_Impact_Kreutz)
% Anregung bei 46cm in X-
% Antwort an Sensor M4 in X (Pos: z=414mm)
% exportiere FRF aus LMS TestLab
load('M4+X_A2-X.mat')
disp(FRF.Header.Title)
disp(Coh.Header.Title)
disp(' ')
fExp=FRF.Header.xStart:FRF.Header.xIncrement:(FRF.Header.NoValues-1)*FRF.Header.xIncrement;
HExp = FRF.Data*9.80665; % Umrechnung in m/s^2/N
CohExp = Coh.Data;

figure
subplot(2,1,1)
yyaxis left
title(['Impact ',FRF.Header.Title])
yyaxis left
semilogy(fExp,abs(HExp));
grid on
ylabel('FRF magnitude')
hold on

plot(fExp,CohExp)
ylabel('Coherence')
subplot(2,1,2)
plot(fExp,angle(HExp));
hold on
yticks(-2*pi:pi/2:2*pi)
% ylim([0 1]*pi)
grid on
ylabel('FRF angle')


%% Berechne FRF aus Simulation vgl. FRFfromMDK.m
load('Simulation_Matrices.mat')

inposition = 460e-3; 
outposition = 414e-3;
InputString = {'460mm'}; % Positionen des Inputs
OutputString = {'414mm'}; % Positionen des Outputs
disp(convertStringsToChars(strcat('Sim, Input ',InputString)))
disp(convertStringsToChars(strcat('Sim, Output ',OutputString)))

indof = zeros(size(inposition));
outdof = zeros(size(outposition));
for k = 1:length(inposition)
    position = inposition(k);
    node_nr = r.rotor.find_node_nr(position);
    indof(k) = (node_nr-1)*6+1;
end
for k = 1:length(outposition)
    position = outposition(k);
    node_nr = r.rotor.find_node_nr(position);
    outdof(k) = (node_nr-1)*6+1;
end


fFEM=(0:0.2:400)';
HFEM = conj(mck2frf(fFEM,M,D,K,indof,outdof,'a')); % ACCELERATION mck2frf liefert konjugiert komplexen Wert der FRF

i=1;
j=1;
figure
subplot(2,1,1)
yyaxis left
title(['MDK ','Input ',InputString{j},', Output ',OutputString{i}])
DisplayName = ['Output',num2str(i)];
semilogy(fFEM(:),abs(HFEM(:,i,j)),'DisplayName',DisplayName);
grid on
ylabel('FRF magnitude')
hold on
%legend('show')
subplot(2,1,2)
plot(fFEM(:),angle(HFEM(:,i,j)));
hold on
yticks(-2*pi:pi/2:2*pi)
% ylim([0 1]*pi)
grid on
ylabel('FRF angle')


%% kombinierter plot
figure
subplot(2,1,1)
title(['Vergleich, ',FRF.Header.Title]);%['Impact ',FRF.Header.Title])
semilogy(fExp,abs(HExp),'DisplayName','Impact');%plot(fExp,abs(HExp),'DisplayName','Impact');
grid on
ylabel('FRF magnitude')
hold on
semilogy(fFEM,abs(HFEM),'DisplayName','FEM');%plot(fFEM,abs(HFEM),'DisplayName','FEM');
legend('show')
xlim([0 1]*400)
subplot(2,1,2)
plot(fExp,angle(HExp)/pi*180);
hold on
plot(fFEM,angle(HFEM)/2/pi*360);
% yticks(-2*pi:pi/2:2*pi)
yticks(-180:90:180)
% yticklabels('-360'
% ylim([0 1]*pi)
grid on
ylabel('FRF angle')
xlim([0 1]*400)

% Nyquist plot:
iExp = find(fExp<=250); % nur unterhalb von 250 Hz plotten
iFEM = find(fFEM<=250);
figure
plot3(real(HExp(iExp)),imag(HExp(iExp)),fExp(iExp),'DisplayName','Impact');
hold on
plot3(real(HFEM(iFEM)),imag(HFEM(iFEM)),fFEM(iFEM),'DisplayName','FEM');
title(['Vergleich, ',FRF.Header.Title]);%['Impact ',FRF.Header.Title])
xlabel('real')
ylabel('imag')
zlabel('f/Hz')
legend('show')
view(2)