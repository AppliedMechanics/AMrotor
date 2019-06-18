clear, close all
import AMrotorSIM.*
Janitor = AMrotorTools.PlotJanitor();
Janitor.setLayout(2,3);
% kMLvec = [1,10,100,1e3,1e4,1e5,1e6,1e7];
kMLvec = 10.^(0:0.5:4.5);

for i=1:length(kMLvec)
kSchaetzung = kMLvec(i);
% kSchaetzung = 1;
dSchaetzung = 0; % ohne Daempfung
Simulation

index = find(imag(m.eigenValues.lateral)/2/pi>0); % EF > 1 Hz finden
% index = index([1,2,5,6]); % nur die erste Biegemode in x- und y-Richtung
m.eigenValues.lateral=m.eigenValues.lateral(index);
m.eigenVectors.lateral_x=m.eigenVectors.lateral_x(:,index);
m.eigenVectors.lateral_y=m.eigenVectors.lateral_y(:,index);
m.eigenVectors.complex=m.eigenVectors.complex(:,index);
m.n_ew = length(index);
EF{i} = m.eigenValues.lateral;

disp(['k=',num2str(kSchaetzung)])
esf.print_frequencies();
[x{i},EVmain{i}]=esf.plot_displacements();
close all
title(['k=',num2str(kSchaetzung)])
% pause
end

% k=1:4:4*length(kMLvec);
% k=[k, 2:4:4*length(kMLvec)];
% k=[k, 3:4:4*length(kMLvec)];
% for i=k 
%     close(figure(i))
% end
% Janitor.cleanFigures();

save animationsplot kMLvec EF EVmain x

script_animate_modes_over_stiffness