function [p,V,Prop] = mck2modal(varargin)
% MCK2MODAL     Compute modal model (poles and mode shapes) from M,(C),K
%
%       p       Column vector with poles, (or eigenfrequencies if undamped) in rad/s
%       V       Matrix with mode shapes in columns
%       Prop    Logical, 1 if C is proportional damping, otherwise 0
%       
%       M       Mass matrix
%       C       (Optional) viscous damping matrix
%       K       Stiffness matrix
%
% [p,V] = mck2modal(M,K) solves for the undamped system and returns
% eigenfrequencies as purely imaginary poles (in rad/s), and mode shapes (normal modes).
%
% [p,V] = mck2modal(M,C,K) solves for the poles and mode shapes. If the
% damping matrix C=aM+bK for konstants a and b, i.e. the system exhibits
% proportional damping, then the undamped system is solved for mode shapes,
% and the poles are calculated from the uncoupled equations in modal
% coordinates. If the damping is not proportional, a general state space
% formulation is used to find the (complex) mode shapes and poles.
%
% NOTE: The list of poles is limited to the poles with positive imaginary
% part, as the other half of the poles can easily be calculated as the
% complex conjugates of the first ones.
%
% Mode shape scaling:
% Undamped mode shapes (normal modes) are scaled to unity modal mass
% Mode shapes calculated with damping are scaled to unity modal A. 
% This means that the modal scaling constant, Qr = 1, that is, that all 
% residues are Apqr=psi_p*psi_q
% This also means that the mode shapes are complex even for 
% proportionally damped case, but it is the most convenient scaling.
%
% See also UMA2UMM

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Note: The way we solve the various systems in this file are not 
% at all necessary, but is done for pedagogical reasons.
% In principal the state space formulation could be used in all cases, 
% and would yield correct results.

if nargin == 2      % Undamped case
    % Solve the undamped case for eigenfrequencies and mode shapes
    M=varargin{1};
    K=varargin{2};
    [V,D]=eig(M\K);
    [D,I]=sort(diag(D));    % Sort eigenvalues/frequencies, lowest first
    V=V(:,I);
    p=sqrt(-D);             % Poles (with positive imaginary part)
    Prop=[];                % Undefined for undamped case!
    Mn=diag(V'*M*V);        % Modal Mass 
    wd=imag(p);
    for n = 1:length(Mn)
%        V(:,n)=V(:,n)/sqrt((j*2*wd(n))*Mn(n));    % Which is equivalent to Mr=1/(j2wd)
        V(:,n)=V(:,n)/sqrt((Mn(n)));    % Which is equivalent to Mr=1/(j2wd)
    end
elseif nargin == 3
    M=varargin{1};
    C=varargin{2};
    K=varargin{3};
    % Find if damping is proportional. See for example 
    % Ewins, D. J., Modal Testing: Theory, Practice and Application,
    % Research Studies Press, 2000.    
    M1=(M\K)*(M\C);
    M2=(M\C)*(M\K);
    if norm(M1-M2)<1e-6           % If proportional damping
        % Solve the undamped case for mode shapes
        [V,D]=eig(M\K);
        [D,I]=sort(diag(D));    % Sort eigenvalues/frequencies, descending
        V=V(:,I);
        wn=sqrt(D);             % Undamped natural frequencies
        % Now diagonalize M, C, K into modal coordinates
        Mn=diag(V'*M*V);       % Modal Mass 
        for n = 1:length(Mn)
            V(:,n)=V(:,n)/sqrt(Mn(n));    % Unity modal mass
        end
        Mn=diag(eye(size(M)));
        Kn=diag(V'*K*V);       % Modal Stiffness 
        Cn=diag(V'*C*V);       % Modal Damping 
        z=(Cn/2)./sqrt(Kn.*Mn); % relative damping from uncoupled equations
        p=-z.*wn+j*wn.*sqrt(1-z.^2);    % Poles (with positive imaginary part)
        Prop=1;
        wd=imag(p);
        for n=1:length(Mn)                  % Rescale mode shapes to unity modal A
            V(:,n)=V(:,n)/sqrt((j*2*wd(n)));    % Which is equivalent to Mr=1/(j2wd)
        end
    else
        % Non-proportional damping, solve state-space formulation
        % See for example:
        % Craig, R.R., Kurdila, A.J., Fundamentals of Structural Dynamics, Wiley 2006
        % With this formulation, coordinates are z={x ; x_dot}
        A=[C    M;   M    0*M];
        B=[K  0*M; 0*M     -M];
        [V,D]=eig(B,-A);
        % Sort in descending order
        [Dum,I]=sort(diag(abs(imag(D))));
        p=diag(D);
        p=p(I);
        V=V(:,I);
        % Rotate vectors to real first element (row 1)
        phi=angle(V(1,:));
        phi=diag(exp(-j*phi));
        V=V*phi;
        % Scale to unity Modal A
        Ma=V.'*A*V;
        for col = 1:length(V(1,:))
            V(:,col)=V(:,col)/sqrt(Ma(col,col));
        end
        % Shorten to size N-by-N. NOTE! This means that in order to use the
        % modal model, you need to recreate the complex conjugate pairs!
        % See, e.g., MODAL2FRF
        [m,n]=size(V);
        p=p(1:2:m);
        V=V(1:m/2,1:2:n);
        Prop=0;
    end
end