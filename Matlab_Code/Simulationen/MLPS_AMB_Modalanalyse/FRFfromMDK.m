clear,close all
load('MDKr_symm.mat')

% wie in Experiment:
% inposition = [67.5, 587.5]*1e-3; %ANPASSEN
% outposition =[25,67.5,110,315,545,587.5,630]*1e-3; %ANPASSEN
% InputString = {'67.5mm','587.5mm'}; % Positionen des Inputs
% OutputString = {'25mm','67.5mm','110mm','315mm','545mm','587.5mm','630mm'}; % Positionen des Outputs

% wie in SYMM Simulation
inposition = [110,590]*1e-3; %ANPASSEN
outposition =[67.5,110,152.5,350,547.5,590,632.5]*1e-3; %ANPASSEN
InputString = {'110mm','590mm'}; % Positionen des Inputs
OutputString = {'67.5mm','110mm','152.5mm','350mm','547.5mm','590mm','632.5mm'}; % Positionen des Outputs


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

f=(0:1:400)';
H = mck2frf(f,M,D,K,indof,outdof,'d');

clear M D K r

for i=1:size(H,2)
    for j=1:size(H,3)
        figure
        subplot(2,1,1)
        yyaxis left
        title(['MDK ','Input ',InputString{j},', Output ',OutputString{i}])
        DisplayName = ['Output',num2str(i)];
        semilogy(f(:),abs(H(:,i,j)),'DisplayName',DisplayName);
        grid on
        ylabel('FRF magnitude')
        hold on
        %legend('show')
        subplot(2,1,2)
        plot(f(:),angle(H(:,i,j)));
        hold on
        yticks(-2*pi:pi/2:2*pi)
        ylim([-1 1]*pi)
        grid on
        ylabel('FRF angle')
    end
end