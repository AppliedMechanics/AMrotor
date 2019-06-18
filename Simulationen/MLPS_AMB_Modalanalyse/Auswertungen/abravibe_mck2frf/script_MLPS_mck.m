clear,close all
load('MLPS_abravibe_simdata_rpm0.mat')

f=(0:1:250)';
indof = indof.u_x; % fuer x-Richtung
outdof = outdof.u_x;

tic,H = mck2frf(f,M,D,K,indof,outdof,'d');toc

p = 1;
fig =figure(1);
% figPhase =figure(2);
for i = 1:size(H,2)
    for j=1:size(H,3)
        figure(fig)
        subplot(size(H,2),size(H,3),p)
        yyaxis left
        %plot(f,abs(H(:,i,j)))
        semilogy(f,abs(H(:,i,j)))
        %loglog(f,abs(H(:,i,j)))
        ylabel(sprintf('I%dO%d,abs',i,j))
        %         figure(figPhase)
        %         subplot(size(H,2),size(H,3),p)
        %         legend(sprintf('I%dO%d',i,j))
        yyaxis right
        plot(f,angle(H(:,i,j)))
        %         yticks(-2*pi:pi/2:2*pi)
        ylabel(sprintf('I%dO%d,angle',i,j))
        p = p+1;
    end
end

for i = 1:length(sens.in)
    disp(['Input ',num2str(i),':',sens.in{i}.name])
end
disp(' ')
for i = 1:length(sens.out)
    disp(['Output ',num2str(i),':',sens.out{i}.name])
end

% LIEFERT UNERWARTETE ERGEBNISSE -> sehr viele Null-Einträge
M=full(M);D=full(D);K=full(K);
% Compute poles and mode shapes:
[p,V]=mck2modal(M,D,K);
% Rescale to unity modal mass, as mck2modal uses unity modal A
V=uma2umm(V,p);

index_p_not_null = find(imag(p)>2*pi);
p = p(index_p_not_null);
V = V(:,index_p_not_null);

figure
nEV = 10;
if size(V,2)<nEV
    nEV = size(V,2);
end
for i = 1:nEV
    plot(z,real(V(1:6:end,i)),'DisplayName',sprintf('%1.2f Hz',imag(p(i))/(2*pi)))
    grid on
    hold on
    pause(0.5)
end
legend('show')
