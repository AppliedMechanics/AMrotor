clear,close all

filename = '10e_noise1kHz250Hz_MIMOx_lowDamp_10s_1kHz-v1.mat_rpm0.mat';
[t,x,y,Fx,Fy] = get_vectors_from_dataset(filename);

LineWidth=1;

fmin=1;                
fmax=250;
N = 1024*2;%
% N= 2^floor(log2(length(t)));%1024;%1024*1; %FFT-block size, power of 2 % Einstellung fuer Aufnahme ca. 30 sec

InputString = {'110mm','590mm'}; % Positionen des Inputs
OutputString = {'67.5mm','110mm','152.5mm','350mm','547.5mm','590mm','632.5mm'}; % Positionen des Outputs

fs = 1/(t(2)-t(1)); % sampling frequency
input = Fx(:,[1,2]); %ML1 % input time data
output = x; % output time data
POverlap = 67;%50; % percentage overlap in welch's method % is this applicable
% window = ones(length(t),1);%rectangle window
window = hsinew(N); % with windowing/averaging
% window = N;


%% Betrachte zunaechst die FFTs
for k = 1:size(input,2)
[f,inputfft(:,k)] = perform_fft(t,input(:,k));
end
figure
semilogy(f,inputfft)
xlabel('f/Hz')
ylabel('inputfft')
for k = 1:size(output,2)
[f,outputfft(:,k)] = perform_fft(t,output(:,k));
end
figure
semilogy(f,outputfft)
xlabel('f/Hz')
ylabel('outputfft')

% return

% n=1;
% chkbsize(input,fs,N*[0.5, 1, 2]*0.5)
% [Gxx,Gyx,Gyy,f1,NBlocks1]=time2xmtrx(input,output,fs,window,POverlap);
% [H1,C1]=xmtrx2frf(Gxx,Gyx,Gyy);
% f1idx=find(f1>fmin & f1 < fmax);

%% FRF-Berechnung
[Gxx,Gyx,Gyy,f,NBlocks1]=time2xmtrx(input,output,fs,window,POverlap);
[H,C,Cx]=xmtrx2frf(Gxx,Gyx,Gyy);

figure
plot(f(:),abs(Cx(:,1,2)))
xlabel('f/Hz')
ylabel('Coherence inputs')
title('Cx')
ylim([0 1])

% plot FRF
% figure
% Hpure = fdiff(Hpure,fpure,'lin',2); % wenn accelerance interessiert
for i=1:size(H,2)
for j=1:size(H,3)
    figure
    subplot(2,1,1)
    yyaxis left
    title(['Exp ','Input ',InputString{j},', Output ',OutputString{i}]) 
    DisplayName = ['Output',num2str(i)];
    semilogy(f(:),abs(H(:,i,j)),'LineWidth',LineWidth,'DisplayName',DisplayName);
    grid on
    ylabel('FRF magnitude')
    hold on
%     legend('show')
    yyaxis right
    plot(f(:),abs(C(:,i)))
    ylabel('coherence')
    subplot(2,1,2)
    plot(f(:),angle(H(:,i,j)),'LineWidth',LineWidth);
    hold on
    yticks(-2*pi:pi/2:2*pi)
    ylim([-1 1]*pi)
    grid on
    ylabel('FRF angle')
end
end

%% get poles and Modes from FRF (C:\Users\Michael\Documents\GitLabProjekte\AMrotor\Matlab_Code\Simulationen\MLPS_AMB_Modalanalyse\pVformFRF.m
facc = f;
Hacc = fdiff(H,facc,'lin',2);

[p,L,flim]=frf2ptime(Hacc,facc,200,30,'mvmif','ptd',[5, 190]);
listpoles(p)

% Compute Mode Shapes
fidx=find(facc >= flim(1) & facc <= flim(2));
Fdof = [2,6];% Fdof sind dof der Eingangskraft bezogen auf die response-nodes (Ich brauche wohl einen driving point, damit der dof der Kraftanregung auch in den response-nodes auftaucht)
Ref = 1:2; % Ref sind die Spalten(3.Dimension) in H, die fuer poles benutzt werden
[V,L,Res]=frfp2modes(Hacc(fidx,:,:),facc(fidx),p,L,1,Fdof);

% create MAC matrix
MAC=amac(V); %auto-MAC
figure
plotmac(MAC,p);

% animation fuer 7 dof
GEOMETRY.node=[1:14];
GEOMETRY.x=[25, 67.5, 110, 315, 545, 587.5, 630, ...
    25, 67.5, 110, 315, 545, 587.5, 630]*1e-3;
GEOMETRY.y=[zeros(1,7),ones(1,7)]*1e-1;
GEOMETRY.z=zeros(1,14);
GEOMETRY.conn=[1:7 14:-1:8 NaN 1 8 NaN 2 9 NaN 3 10 NaN 4 11 NaN 5 12 NaN 6 13 NaN 7 14];
for n = 1:length(p)
    MODAL(n).Freq=p(n)/2/pi;
    MODAL(n).Node=[1:14]';
    MODAL(n).X=zeros(14,1);
    MODAL(n).Y=zeros(14,1);
    MODAL(n).Z=[V(:,n);V(:,n)];
end
save animationMLPS GEOMETRY MODAL

% animate


% return
% %% get poles
% % p.20 in Abravibe EMA manual -> must have accelerance FRF (fdiff)
% facc = f1;
% Hacc = fdiff(H1(:,[1,3,4,5,7]),facc,'lin',2);%nur echt gemessene Werte %fdiff(H1,facc,'lin',2); %transform from receptance FRF to accelerance FRF
% 
% Hacc_prony = Hacc(:,2);
% MIF=amif(Hacc_prony); % mode indicator function
% % [p,L,flim]=frf2ptime(Hacc(:,:),facc,100,22,MIF,'ptd',[5, 190]);%[p,L,flim]=frf2ptime(Hacc_prony,facc,120,30,MIF,'prony',[2, 250]);%[p,L,flim]=frf2ptime(Hacc(:,:),facc,200,30,MIF,'lsce',[10, 250]);
% [p,L,flim]=frf2ptime(Hacc(:,:),facc,200,30,MIF,'ptd',[5, 190]);
% 
% % Compute Mode Shapes
% fidx=find(facc >= flim(1) & facc <= flim(2));
% V=frfp2modes(Hacc(fidx,:),facc(fidx),p,1,1);
% 
% % create MAC matrix
% MAC=amac(V); %auto-MAC
% figure
% plotmac(MAC,p);
% 
% 
% % Create geometry and animate using the first poles and mode shapes
% % GEOMETRY.node=[1:14];
% % GEOMETRY.x=[25, 67.5, 110, 315, 545, 587.5, 630, ...
% %     25, 67.5, 110, 315, 545, 587.5, 630]*1e-3;
% % GEOMETRY.y=[zeros(1,7),ones(1,7)]*1e-1;
% % GEOMETRY.z=zeros(1,14);
% % GEOMETRY.conn=[1:7 14:-1:8 NaN 1 8 NaN 2 9 NaN 3 10 NaN 4 11 NaN 5 12 NaN 6 13 NaN 7 14];
% % for n = 1:length(p)
% %     MODAL(n).Freq=p(n)/2/pi;
% %     MODAL(n).Node=[1:14]';
% %     MODAL(n).X=zeros(14,1);
% %     MODAL(n).Y=zeros(14,1);
% %     MODAL(n).Z=[V(:,n);V(:,n)];
% % end
% 
% % wenn nur die echt gemessenen Knoten verwendet werden:
% GEOMETRY.node=[1:10];
% GEOMETRY.x=[25, 110, 315, 545,  630, ...
%     25, 110, 315, 545,  630]*1e-3;
% GEOMETRY.y=[zeros(1,5),ones(1,5)]*1e-1;
% GEOMETRY.z=zeros(1,10);
% GEOMETRY.conn=[1:5 10:-1:6 NaN 1 6 NaN 2 7 NaN 3 8 NaN 4 9 NaN 5 10];
% for n = 1:length(p)
%     MODAL(n).Freq=p(n)/2/pi;
%     MODAL(n).Node=[1:10]';
%     MODAL(n).X=zeros(10,1);
%     MODAL(n).Y=zeros(10,1);
%     MODAL(n).Z=[V(:,n);V(:,n)];
% end
% 
% save animationMLPS GEOMETRY MODAL
% 
% % animate
% 
