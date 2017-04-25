%Generierung der Plots der analytischen Berechnung und der Simulationsdaten
%des standardisierten hufeisenmagneten 2
%Michael Mirza 02.04.2017
KFAn=csvread('AnalytKFSHM2.csv')
KFSim=csvread('SimKFSHM2.csv')
KFSim(:,3)=KFSim(:,3)/(-50.0)   %reale tiefe 2cm=(1/50)m,Richtungsumkehr
pos1=1
for k1=1:1:15
    
    
    spaltbreite=KFSim(pos1:(pos1+24),2)
    kraft=KFSim(pos1:(pos1+24),3)
    plot(spaltbreite,kraft,'kx-')
    hold on
    spaltbreite=KFAn(pos1:(pos1+24),2)
    kraft=KFAn(pos1:(pos1+24),3)
    plot(spaltbreite,kraft,'k+--')
    legend('Simulation','analytische Rechnung')
    xlabel('Luftspaltbreite [10^-^2m]')
    ylabel('Kraft [N]')
    tp1=string(k1)
    t=strcat(tp1,'A')
    title(t)
    switch k1
        case 1
            print('I1A', '-dpdf')
        case 2
            print('I2A', '-dpdf')
        case 3
            print('I3A', '-dpdf')
        case 4
            print('I4A', '-dpdf')
        case 5
            print('I5A', '-dpdf')
        case 6
            print('I6A', '-dpdf')
        case 7
            print('I7A', '-dpdf')
        case 8
            print('I8A', '-dpdf')
        case 9
            print('I9A', '-dpdf')
        case 10
            print('I10A', '-dpdf')
        case 11
            print('I11A', '-dpdf')
        case 12
            print('I12A', '-dpdf')
        case 13
            print('I13A', '-dpdf')
        case 14
            print('I14A', '-dpdf')
        case 15
            print('I15A', '-dpdf')
    end
    pos1=pos1+25
    
    hold off
end    