

clear


%% Datei laden
% load('rpm5000Test_fwd_bwd_whirl_sweep_RecAll_DPS.mat')
load('0rpm_0-200Hz_rpm0.mat')

fPass = 10;
xLimit = 300; % max. Frequenz = xLimit [Hz]


%% Parameter fuer FRF setzen
time = data.time;
T = (time(end)-time(1)) / length(time);
fs = 1/T;

%% Einlesen der Werte und filtern
% force(:,1) = Current_Mag1_x;
% force(:,2) = Current_Mag1_y;
% force(:,3) = Current_Mag2_x;
% force(:,4) = Current_Mag2_y;
force(:,1) = data.x_dir_KraftLager2_;

force(isnan(force)) = 0;

for k = size(force,2)
%     force(:,k) = highpass(force(:,k),fPass,fs);
    force(:,k) = force(:,k) - mean(force(:,k)); %Mittelung, da Offset der Messung
end

% force = force(1:end/2,:);

% displacement(:,1) = Orbit_VHo;
% displacement(:,2) = Orbit_VVe;
% displacement(:,3) = Orbit_HHo;
% displacement(:,4) = Orbit_HVe;

displacement(:,1) = data.x_dir_WegLager2_;

displacement(isnan(displacement)) = 0;

for k = 1:size(displacement,2)
%     displacement(:,k) = highpass(displacement(:,k),fPass,fs);
    displacement(:,k) = displacement(:,k) - mean(displacement(:,k)); %Mittelung, da Offset der Messung
end

% displacement = displacement(1:end/2,:);


%% FFT durchführen
T = (time(end)-time(1)) / length(time);
L = length(time);
t=time;
Fs = 1/T;
for k = 1:size(displacement,2)
    [freq,Y(:,k)]=DPS_FFT_C(displacement(:,k),time);
    PY2(:,k) = abs(Y(:,k)/L);
    PY1(:,k) = PY2(1:L/2+1,k);
    PY1(2:end-1,k) = 2*PY1(2:end-1,k);
end
for k = 1:size(force,2)
    [freq,f(:,k)]=DPS_FFT_C(force(:,k),time);
    Pf2(:,k) = abs(f(:,k)/L);
    Pf1(:,k) = Pf2(1:L/2+1,k);
    Pf1(2:end-1,k) = 2*Pf1(2:end-1,k);
end
% plot(freq,PY1)
% plot(freq,Pf1)

%% FRF manuell ausrechnen
% G_ik = y_i/f_k

% driving point FRF, d.h. G_kk, also Anregung und Antwort an Stelle k
for k = 1:size(displacement,2)
    G(:,k) = Y(:,k)./f(:,k);
    PG2(:,k) = abs(G(:,k)/L);
    G_Amp(:,k) = PG2(1:L/2+1,k);
    G_Amp(2:end-1,k) = 2*G_Amp(2:end-1,k);
end

% plotte die Ergebnisse fuer die driving point frf
figure
for k = 1:size(displacement,2)
    subplot(1:size(displacement,2),1,k)
    plot(freq,angle(G(:,k)))
    xlabel('f [Hz]')
    ylabel('angle(G)')
    title(['G_{',num2str(k),num2str(k),'}'])
    xlim([0 1]*0.5e3);
end

figure
for k = 1:size(displacement,2)
    subplot(1:size(displacement,2),1,k)
    semilogy(freq,G_Amp(:,k))
    title(['G_{',num2str(k),num2str(k),'}'])
    xlim([0 1]*0.5e3);
end


%% single sided amplitude spectrum aus FFT.m
for k = 1:size(displacement,2)
    y=displacement(:,k);
    AnzahlMessungen = length(y);
    Endzeit = time(AnzahlMessungen);
    Abtastfrequenz = AnzahlMessungen/Endzeit;
    
    Fs = Abtastfrequenz;                    % Sampling frequency
    T = Endzeit;                     % Sample time
    L = AnzahlMessungen;                     % Length of signal
    t = time;                % Time vector
    
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(y,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);
    
    % Plot single-sided amplitude spectrum.
    figure
    plot(f,2*abs(Y(1:NFFT/2+1)))
    title(sprintf('Single-Sided Amplitude Spectrum of displacement %d',k))
    xlabel('Frequency (Hz)')
    ylabel('Amplitude')
    hold on;
    
end

for k = 1:size(force,2)
    y=force(:,k);
    AnzahlMessungen = length(y);
    Endzeit = time(AnzahlMessungen);
    Abtastfrequenz = AnzahlMessungen/Endzeit;
    
    Fs = Abtastfrequenz;                    % Sampling frequency
    T = Endzeit;                     % Sample time
    L = AnzahlMessungen;                     % Length of signal
    t = time;                % Time vector
    
    NFFT = 2^nextpow2(L); % Next power of 2 from length of y
    Y = fft(y,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);
    
    % Plot single-sided amplitude spectrum.
    figure
    plot(f,2*abs(Y(1:NFFT/2+1)))
    xlim([0 1]*xLimit);
    title(sprintf('Single-Sided Amplitude Spectrum of force %d',k))
    xlabel('Frequency (Hz)')
    ylabel('Amplitude')
    hold on;
    
end