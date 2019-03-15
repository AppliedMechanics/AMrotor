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

%animation fuer 5 dof
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
% save animationMLPS GEOMETRY MODAL

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