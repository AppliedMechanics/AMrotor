function [ EV_for,EW_for,EV_back,EW_back, EV_0, EW_0, Phase_xy, Phase_xy_mean ] = get_separation_eigenvectors(obj,EV_raw,EW_raw )
%Input: Matrix of EVs (format: [x1;b1;x2;b2;...y1;a1;..., next EV]) and corresponding EWs; imag(EW) has to be positive!
%Process: calculates the phase between the entries of x and y and decides,
%if backward or forward-whirl or no whirl at all; the mean of all phases is
%built, in case of doubts plot Phase_xy (or ab) over the nodes 
%Output: EV and EW with forward, backward or no whirl

% Theory:
% o Consider an EV with two complex entries [x y]'
% o it can be written in the form:[|x|exp(i*phi_x) |y|exp(i*phi_y)]'
% o Linear combination (e.g. simple addition) of the solutions of the complex conjugated EVs and corresponding
% EWs yields [|x|*cos(wt+phi_x) |y|*cos(wt+phi_y)]
% o several information is in this:
% -> phi_x>phi_y is a forward whirl (try with phi_x=0 and phi_y=-pi/2)
% -> |phi_y-phi_x|=pi/2: the main axes of the ellipse are in x and y
% direction with amplitude |x| and |y|
% -> |phi_y-phi_x|~=pi/2: the main axes is no longer in x and y direction

PhaseAbsMin = 1e-5;

% Determine size of problem
s=size(EV_raw);
n_DOF=s(1);
n_EW=s(2)/2;

%Entferne alle negativen Eigenwerte
I_p=(imag(EW_raw)>0);
EW=EW_raw(I_p);
EV=EV_raw(:,I_p);

% Initiate variables
[Phase_x,Phase_y,Phase_a, Phase_b]=deal(NaN(n_DOF/6,n_EW));
[Phase_xy_mean, Phase_ab_mean]=deal(NaN(1,n_EW));

% Fill the phases for every EW
for k=1:n_EW % order of dof in EV-vector: EV=[x1, y1, z1, phi_x1, phi_y1, phi_z1, ...]'
    Phase_x(:,k)=angle(EV(1:6:n_DOF,k));
    Phase_y(:,k)=angle(EV(2:6:n_DOF,k));
    Phase_a(:,k)=angle(EV(4:6:n_DOF,k));
    Phase_b(:,k)=angle(EV(5:6:n_DOF,k));
end

%Calculate the relative phases between the directions
Phase_xy=Phase_x-Phase_y;
Phase_ab=Phase_b-Phase_a;

for k=1:3  % Drag the phases iteratively to the smallest value
    I=find(abs(Phase_xy-2*pi)<abs(Phase_xy));    %case phi-2*pi is better
    Phase_xy(I)=Phase_xy(I)-2*pi;
    I=find(abs(Phase_ab-2*pi)<abs(Phase_ab));
    Phase_ab(I)=Phase_ab(I)-2*pi;

    I=find(abs(Phase_xy+2*pi)<abs(Phase_xy));    %case phi+2*pi is better
    Phase_xy(I)=Phase_xy(I)+2*pi;
    I=find(abs(Phase_ab+2*pi)<abs(Phase_ab));   
    Phase_ab(I)=Phase_ab(I)+2*pi;
end

% Calculate the mean of the Phases
for k=1:n_EW
   Phase_xy_mean(k)=mean(Phase_xy(:,k)); 
   Phase_ab_mean(k)=mean(Phase_ab(:,k));
end

% identify the whirl direction
% Information of Phase_ab should be redundant to xy and is neglected
I_f=(Phase_xy_mean>PhaseAbsMin);
I_b=(Phase_xy_mean<(-PhaseAbsMin));
I_0=(Phase_xy_mean>(-PhaseAbsMin)&Phase_xy_mean<PhaseAbsMin);

% order Phase (necessary if in output)

%Seperate the EVs and EWs
EV_for=EV(:,I_f);
EW_for=EW(I_f);

EV_back=EV(:,I_b);
EW_back=EW(I_b);

EV_0=EV(:,I_0);
EW_0=EW(I_0);

end

