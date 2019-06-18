function [V,L,Res] = frfp2modes(varargin)
% FRFP2MODES     Estimate mode shapes from FRFs and poles in frequency domain
%
% V = frfp2modes(H,f,p,Plot) for an N-by-1 vector H, estimates mode
% shape coefficients for one FRF, without residual terms. If Plot=1 an
% overlay plot is generated showing the result.
% [V,Res] = frfp2modes(H,f,p,Plot) for an N-by-1 vector H, estimates mode
% shape coefficients for one FRF, including residual terms. If Plot=1 an
% overlay plot is generated showing the result.
% V = frfp2modes(H,f,p,ScaleDof,DispTime) for an N-by-D matrix H estimates a
% D-by-Nm matrix with mode shapes scaled to the driving point in ScaleDof.
% If DispTime~=0 or empty, an overlay plot is generated showing the result
% during DispTime seconds.
% [V,Res] = frfp2modes(H,f,p,ScaleDof,DispTime) for an N-by-D matrix H generates a
% D-by-Nm matrix with mode shapes scaled to the driving point in ScaleDof.
% [V,L] = frfp2modes(H,f,p,L,DispTime,Fdof) or
% [V,L,Res] = frfp2modes(H,f,p,L,DispTime,Fdof) generates D-by-Nm mode
% shapes in the case of poles and modal participation factors if  a
% multiple-reference method has been used for pole extraction and L is a matrix.
%
%       V           Mode shape matrix with modes in columns D-by-Nm
%       Res         Residual terms (Optional) [const1;const2/w^2 ], 2*R-by-D
%       L           Modified modal participation factors after scaling for
%                   unity modal A
%
%       H           Accelerance FRF matrix, up to N-by-D-by-R (see text)
%       f           Frequency axis for H, containin (as H) the frequencies
%                   that should be used for the curve fitting
%       p           Vector with poles for those modes that should be fitted
%       L           Modal participation matrix, 1 if single reference,
%                   otherwise output from multiref. curve fitting for poles
%       ScaleDof    Dof for scaling of FRFs (driving point)
%       Type        String with specification of method:
%                   'lsfreq' for least squares frequency domain (Default)
%       DispTime    If ~= 0 (or not given), then each FRF is plotted in overlay
%                   with the estimated model FRF during DispTime seconds
%       Fdof        Vector with which response number in H that corresponds
%                   to each reference number
%
% Mode shapes are scaled to unity modal A using the largest modal participation
% factor for each mode, see modal2frf
%
% See also FRF2MSDOF MODAL2FRF FRFSYNT

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23
%          1.1 2012-10-23  Updated to work with changed frf2ptime results
% This file is part of ABRAVIBE Toolbox for NVA

%**********************************************************
% This function is still in development!!!
% Still needs improved scaling before inverting B
%**********************************************************


% Parse inputs
if nargin == 3
    H=varargin{1};
    [N,D,R]=size(H);
    f=varargin{2};
    p=varargin{3};
    DispTime=0;
elseif nargin == 4
    H=varargin{1};
    [N,D,R]=size(H);
    f=varargin{2};
    p=varargin{3};
    ScaleDof=varargin{4};
    if D == 1   % Single FRF, then 4th parameter is Plot, but we use DispTime
        DispTime=varargin{4};
        ScaleDof=1;
    else
        [m,n]=size(ScaleDof);
        if m > 1 && n > 1
            L=ScaleDof;
            DispTime=0;
        else
            DispTime=ScaleDof;
        end
    end
elseif nargin == 5
    H=varargin{1};
    [N,D,R]=size(H);
    f=varargin{2};
    p=varargin{3};
    ScaleDof=varargin{4};
    DispTime=varargin{5};
    Fdof=ScaleDof;
elseif nargin == 6
    H=varargin{1};
    [N,D,R]=size(H);
    if R == 1
        error('Too many input parameters for single-dimension H!')
    else
        f=varargin{2};
        p=varargin{3};
        L=varargin{4};
        DispTime=varargin{5};
        Fdof=varargin{6};
    end
end
if nargout == 2
    Res=[];
end
Nm=length(p);

%============================================================
% Convert FRFs to receptance
Hp=fint(H,f,'lin',2);

% Normalize FRFs to unity maximum
% M=max(max(max(abs(H))))
% H=H/M;

% Expand size of p to 2N by including complex conjugate poles
p=p(:);                 % Force to column
p=[p ; conj(p)];
% If multiple-reference, same with L
if exist('L','var')
    L=[L;conj(L)];
end

% First, single-reference case
if ~exist('L','var')
    % Set up matrices
    jw=j*2*pi*f;
    Lambda=zeros(N,2*Nm);
    for mode = 1:2*Nm
        Lambda(:,mode)=1./(jw-p(mode));
    end
    if nargout == 2
        Lambda(:,2*Nm+1)=1./(jw.^2);
        Lambda(:,2*Nm+2)=ones(N,1);
    end
    % Compute modes and residuals
    if nargout == 1
        A=zeros(D,2*Nm);                    % Residues, scaling to modes later
    else
        A=zeros(D,2*Nm+2);                  % Residues, scaling to modes later
    end
    Res=zeros(D,2);
    for d = 1:D
        Vt=pinv(Lambda)*H(:,d);
        %         Vt=Lambda\H(:,d);         % Alternative solution
        A(d,:)=Vt.';
        if ~exist('h','var') & DispTime > 0
            h=figure;
        end
        if DispTime > 0
            Hsynt=Lambda*A(d,:).';
            semilogy(f,abs(H(:,d)),f,abs(Hsynt),'k--')
            title(['Curve fit result, DOF=' int2str(d)])
            xlabel('Frequency [Hz]')
            ylabel('Accelerance')
            legend('Measured','Synthesized')
            pause(DispTime)
        end
    end
    % Split A into modes and residuals, and shrink down to D-by-Nm
    if nargout == 2
        Res=A(:,2*Nm+1:2*Nm+2);
    end
    for mode = 1:Nm
        V(:,mode)=A(:,mode)/sqrt(A(ScaleDof,mode));
    end
else        % If more than one reference, i.e. L exist
    % Initialize variables
    V=zeros(D,Nm);
    jw=j*2*pi*f;
    if nargout == 3
        Res=zeros(2*R,D);
    end
    % Build the B matrix
    % Build the extendedMPF matrix if residuals are requested, else use the
    % modal participation matrix alone
    if nargout == 3
        MPFe=[L.' eye(R) eye(R)];
        B=zeros(R,2*(Nm+R));
    else
        MPFe=L.';
        B=zeros(R,2*Nm);
    end
    for n = 1:N
        Lambdae=diag(1./(jw(n)-p));
        if nargout == 3
            Lambdae=[Lambdae zeros(2*Nm,2*R);,...
                zeros(R,2*Nm) eye(R) zeros(R);,...
                zeros(R,2*Nm+R) 1/(jw(n)^2)*eye(R)];
        end
        B(1+(n-1)*R:n*R,:)=MPFe*Lambdae;
    end
    Binv=pinv(B);
    clear MPFe Lambdae
    % Loop responses
    % Permute the FRF matrix for easier setup
    Hp=permute(Hp,[3 1 2]);
    for d = 1:D
        % Produce column vector with FRFs
        Ht=squeeze(Hp(:,:,d));
        Ht=Ht(:);
        % Store mode shape coefficients in row for response d
        %         A(d,:)=(Binv*Ht).';
        A(d,:)=(Binv*Ht).';
        %         A(d,:)=(B.'*B)\(B.'*Ht);
    end
    % Remove complex conjugate mode shapes and residual terms
    if nargout == 3
        Res=A(:,end-2*R+1:end).';       % Residuals are in last columns
        V=A(:,1:1:Nm);
        L=L(1:Nm,:);
    else
        V=A(:,1:Nm);
        L=L(1:Nm,:);
    end
    % Scale mode shapes using first the reference having the largest MPF
    % for each mode
    for r = 1:Nm
        [dum,I]=max(abs(L(r,:)));
        VV=L(r,I)*V(:,r);
        L(r,:)=L(r,:)/L(r,I);               % Product of VV and L constant
        V(:,r)=VV/sqrt(VV(Fdof(I)));
        L(r,:)=L(r,:)*sqrt(VV(Fdof(I)));
    end
    % Plot fits if requested
    if DispTime > 0
        p=p(1:end/2);
        if ~exist('Res','var')
            Res=[];
        end
        Hsynt=frfsynt(H,f,p,V,Res,Fdof,1:D,'a',DispTime,Fdof);
    end
end

if ~exist('L','var')
    L=Res;
end