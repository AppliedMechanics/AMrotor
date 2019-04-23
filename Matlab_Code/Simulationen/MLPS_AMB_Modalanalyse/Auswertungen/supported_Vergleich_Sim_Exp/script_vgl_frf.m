disp([Pstr,' ',FRF.Input,'->',FRF.Output])
fExp=FRF.f;
HExp = FRF.H; % Umrechnung in m/s^2/N
CohExp = FRF.C;

figure
subplot(2,1,1)
yyaxis left
title([Pstr,' ',FRF.Input,'->',FRF.Output])
yyaxis left
semilogy(FRF.f,abs(FRF.H));
grid on
ylabel('FRF magnitude')
hold on
%legend('show')
yyaxis right
plot(FRF.f,FRF.C)
ylabel('Coherence')
subplot(2,1,2)
plot(FRF.f,angle(FRF.H));
hold on
yticks(-2*pi:pi/2:2*pi)
% ylim([0 1]*pi)
grid on
ylabel('FRF angle')


%% Berechne FRF aus Simulation vgl. FRFfromMDK.m
InputString = FRF.Input; % Positionen des Inputs
OutputString = FRF.Output; % Positionen des Outputs
disp(['Sim, Input ',InputString])
disp(['Sim, Output ',OutputString])

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


fFEM=(0:0.2:250)';
HFEM = conj(mck2frf(fFEM,M,D,K,indof,outdof,'d'));

i=1;
j=1;
figure
subplot(2,1,1)
yyaxis left
title(['MDK ','Input ',InputString,', Output ',OutputString])
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
yyaxis left
semilogy(fExp,abs(HExp),'DisplayName','Exp');
title([Pstr,' Vergleich, ',FRF.Input,'->',FRF.Output]);
grid on
ylabel('FRF magnitude')
hold on
yyaxis right
plot(FRF.f,FRF.C)
ylabel('Coherence')
yyaxis left
semilogy(fFEM,abs(HFEM),'DisplayName','FEM');
legend('show')
xlim([0 1]*250)
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
xlim([0 1]*250)

disp(' ')