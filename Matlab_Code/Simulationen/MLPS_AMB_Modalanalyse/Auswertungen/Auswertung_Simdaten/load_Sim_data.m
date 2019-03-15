function load_Sim_data(filenameInput,filenameOutput)

%% Datei laden
% load('data_0-1s_10kHz_rpm0.mat')
load(filenameInput)
rpm = data.rpm;
t = data.time';
dataFieldnames = fieldnames(data);
kForcex = [];
kForcey = [];
kDisplx = [];
kDisply = [];
Fx = [];
Fy = [];
x = [];
y = [];

for k = 1:length(dataFieldnames)
    if ~isempty(strfind(dataFieldnames{k},'Weg')) && ~isempty(strfind(dataFieldnames{k},'x'))
        kDisplx =[kDisplx, k];
    elseif ~isempty(strfind(dataFieldnames{k},'Weg')) && ~isempty(strfind(dataFieldnames{k},'y'))
        kDisply =[kDisply, k];
    elseif ~isempty(strfind(dataFieldnames{k},'Kraft')) && ~isempty(strfind(dataFieldnames{k},'x'))
        kForcex =[kForcex, k];
    elseif ~isempty(strfind(dataFieldnames{k},'Kraft')) && ~isempty(strfind(dataFieldnames{k},'y'))
        kForcey =[kForcey, k];
    end
end
kForcex = [4]; % per Hand ausgewaehlt
kForcey = [14]; % per Hand ausgewaehlt
for k = kForcex
    Fx = [Fx, data.(dataFieldnames{k})'];
end
for k = kForcey
    Fy = [Fy, data.(dataFieldnames{k})'];
end

for k = kDisplx
    x = [x, data.(dataFieldnames{k})'];
end
for k = kDisply
    y = [y, data.(dataFieldnames{k})'];
end

% aus Config abgeschrieben:
InputStringx = {'590mm'}; % Positionen des Inputs 
OutputStringx = {'67.5mm','110mm','152.5mm','547.5mm','590mm','632.5mm','350mm'};
InputStringy = {'590mm'}; % Positionen des Inputs 
OutputStringy = {'67.5mm','110mm','152.5mm','547.5mm','590mm','632.5mm','350mm'};

t = t(2:end,:);
x = x(2:end,:);
y = y(2:end,:);
Fx = Fx(2:end,:);
Fy = Fy(2:end,:);

save(filenameOutput,'t','x','y','Fx','Fy','InputStringx','InputStringy','OutputStringx','OutputStringy')

%% FFT
figure,
[f,Fxfft] = perform_fft(t,Fx);
semilogy(f,Fxfft)
hold on
[f,Fyfft] = perform_fft(t,Fy);
semilogy(f,Fyfft)
xlabel('f/Hz')
ylabel('Ffft')
legend('Fxfft','Fyfft')

figure,hold on
for k=1:size(x,2)
[f,xfft(:,k)] = perform_fft(t,x(:,k));
plot(f,xfft(:,k))
end
xlabel('f/Hz')
ylabel('xfft')
legend;

figure,hold on
for k=1:size(y,2)
[f,yfft(:,k)] = perform_fft(t,y(:,k));
plot(f,xfft(:,k))
end
xlabel('f/Hz')
ylabel('yfft')
legend;


% %% Auswertung
% 
% %% FRF-Berechnung
% force = Fx;
% displacement = x;
% fmax = 250; % plot und fit bis 250 Hz
% nWindows = 1;
% SensorType = 'acc';
% [frf,f,coh,fn,dr,modeshapes] = get_modalfrf(t,displacement,force,nWindows,fmax,SensorType);
% fn,dr

end