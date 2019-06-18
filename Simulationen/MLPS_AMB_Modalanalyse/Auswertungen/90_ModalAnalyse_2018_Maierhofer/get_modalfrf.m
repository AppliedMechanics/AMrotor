function [frf,f,coh,fn,dr,modeshapes] = get_modalfrf(t,displacement,force,nWindows,fmax,SensorType)
Ts = t(2)-t(1);
fs = 1/Ts;
windowLength =round(length(t)/nWindows);
numberOverlap = round(windowLength/2);

%% modalfrf
[frf,f,coh] = modalfrf(force,displacement,fs,windowLength,numberOverlap,'Sensor',SensorType);

%% modalfrf plot
figFRF = figure;
modalfrf(force,displacement,fs,windowLength,numberOverlap,'Sensor','dis');
axH = findall(figFRF,'type','axes');
set(axH,'xlim',[0 1]*fmax)

%% modalfit
[fn,dr,modeshapes,ofrf] = modalfit(frf,f,fs,1,'FitMethod','PP','FreqRange',[0 fmax]);

%% plot modalfit
figFRFSemilogy = figure;
figFRFlinear = figure;
figFRFSemilogy.Name = 'FRF logy';
figFRFlinear.Name = 'FRF linear';
for k = 1:size(displacement,2)
    figure(figFRFSemilogy);
    subplot(size(displacement,2),1,k)
    semilogy(f,abs(frf(:,k)),f,abs(ofrf(:,k)))
    ylabel(sprintf('I1, O%d',k))
    legend('frf','ofrf')
    xlim([0 fmax])
    figure(figFRFlinear);
    subplot(size(displacement,2),1,k)
    plot(f,abs(frf(:,k)),f,abs(ofrf(:,k)))
    ylabel(sprintf('I1, O%d',k))
    legend('frf','ofrf')
    xlim([0 fmax])
end
end