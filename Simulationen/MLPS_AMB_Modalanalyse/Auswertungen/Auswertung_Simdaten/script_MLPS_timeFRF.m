clear,close all

LineWidth = 1;

fmin=1;                
fmax=250;
N = 1024/2; %FFT-block size, power of 2

% load('data_for_abravibe_4s.mat');
% load('data_for_abravibe_1s.mat');
% load('data_for_abravibe_1s_10kHz'); % gives t,x,y,Fx,Fy
load('data_for_abravibe_dm_0-300Hz_0-4s.mat')
% load('data_0-1s_0-130Hz burst_10kHz_rpm0.mat')
InputString = InputStringx;
OutputString = OutputStringx;
% Positionen bei displacement: {'25mm','110mm','315mm','545mm','630mm'}; % Positionen des Outputs


fs = 1/(t(2)-t(1)); % sampling frequency
input = Fx+0.0001*max(max(Fx))*rand(size(Fx)); % input time data
output = x+0.0001*max(max(x))*rand(size(x)); % output time data
POverlap = 50; % percentage overlap in welch's method % is this applicable
% window = ones(length(t),1);%rectangle window
% window = length(t);%2^round(log2(length(t)/2)); % hanning window
window = hsinew(N); % with windowing/averaging

% FRF estimation, Hanning window, Welch's method
n=1;
[Gxx,Gyx,Gyy,f1,NBlocks1]=time2xmtrx(input,output,fs,window,POverlap);
[H1,C1]=xmtrx2frf(Gxx,Gyx,Gyy);
f1idx=find(f1>fmin & f1 < fmax);
Hpure{n}=H1(f1idx,:);
fpure{n}=f1(f1idx,:);
Cpure{n}=C1(f1idx,:);

% plot FRF
% figure
for i=1:size(Hpure{n},2)
    figure
    subplot(2,1,1)
    yyaxis left
    title(['Sim ','Input ',InputString{1},', Output ',OutputString{i}]) 
    DisplayName = ['Output',num2str(i)];
    semilogy(fpure{1}(:),abs(Hpure{1}(:,i)),'LineWidth',LineWidth,'DisplayName',DisplayName);
    grid on
    ylabel('FRF magnitude')
    hold on
%     legend('show')
    yyaxis right
    plot(fpure{1}(:),abs(Cpure{1}(:,i)))
    ylabel('coherence')
    subplot(2,1,2)
    plot(fpure{1}(:),angle(Hpure{1}(:,i)),'LineWidth',LineWidth);
    hold on
    yticks(-2*pi:pi/2:2*pi)
    ylim([-1 1]*pi)
    grid on
    ylabel('FRF angle')
end

%% get poles
% p.20 in Abravibe EMA manual -> must habe accelerance FRF (fdiff)
facc = f1;
Hacc = fdiff(H1,facc,'lin',2); %transform from receptance FRF to accelerance FRF

MIF=amif(Hacc); % mode indicator function
[p,L,flim]=frf2ptime(Hacc(:,:),facc,200,20,MIF,'lsce',[10, 250]);

% Compute Mode Shapes
fidx=find(facc >= flim(1) & facc <= flim(2));
V=frfp2modes(Hacc(fidx,:),facc(fidx),p,1,1);

% create MAC matrix
MAC=amac(V,V); %auto-MAC
figure
plotmac(MAC,p,p);

% Create geometry and animate using the first poles and mode shapes
GEOMETRY.node=[1:14];%[1:3,7,4:6,1:3,7,4:6];%
GEOMETRY.x=zeros(1,14);
GEOMETRY.y=[zeros(1,7),ones(1,7)]*1e-1;
GEOMETRY.z=[67.5, 110, 152.5, 350, 547.5, 590, 632.5, ...
    67.5, 110, 152.5, 350, 547.5, 590, 632.5]*1e-3;
GEOMETRY.conn=[1:7, NaN 8:14 NaN 1 8 NaN 2 9 NaN 3 10 NaN 4 11 NaN 5 12 NaN 6 13 NaN 7 14];
for n = 1:length(p)
    MODAL(n).Freq=p(n)/2/pi;
    MODAL(n).Node=[1:3,7,4:6,[1:3,7,4:6]+7]';%[1:14]';
    MODAL(n).X=[V(:,n);V(:,n)];
    MODAL(n).Y=zeros(14,1);
    MODAL(n).Z=zeros(14,1);
end

save LSCEMLPS GEOMETRY MODAL

% animate