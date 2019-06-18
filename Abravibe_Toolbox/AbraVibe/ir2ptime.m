function [p,L,H,f] = ir2ptime(h,fs,NLines,MaxModes,EstType,MIF,f,fOffset);
% IR2PTIME   Time domain MDOF methods for parameter extraction from free
% decay functions (impulse response or cross-correlation functions)
%
%         [p,L] = ir2ptime(h,fs,Nlines,MaxModes,EstType,MIF,f,fOffset);
%
%       p           Vector with complex poles with positive imaginary part
%       L           This is a variable which varies with the EstType
%                   for EstType='prony' or 'lsce', L = 1.
%                   for EstType='ptd' and 'mmitd', L contains the modal participation
%                   factors
%
%       h           Matrix with free-decay functions (impulse response,
%                   correlations, random decrements)
%       fs          Sampling frequency
%       Nlines      Number of time values to use
%       MaxModes    Maximum order number
%       EstType     'Prony', 'LSCE', 'PTD', or MMITD
%       MIF         Overlay function for stabilization diagram (Optional) 
%       f           Frequency axis for MIF. Mandatory if MIF given
%       fOffset     Frequency offset if h computed from zoomed freq. range
%                   Mandatory if MIF and f given
%
% See also FRF2PTIME 

% Note!             MIF, f, and fOffset are internal variables, used only  
%                   if this function is called from FRF2PTIME.

% Copyright (c) 2014 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.4 2014-01-27 Created from frf2ptime.
%          1.5 2018-01-05 Bug fixed to always use NLines
%          1.6 2018-03-09 Changed to use \ instead of pinv() for options
%                         'LSCE', 'PTD'
%          1.7 2018-05-10 Added MMITD method
%
% This file is part of ABRAVIBE Toolbox for NVA

%=========================================================================
% Initialize hardcode parameters
%=========================================================================
SelStartTime=0;             % Set to 1 to get a plot where start of impulse
%                             response is selected interactively (using
%                             first impulse response
SelEndTime=0;               % Set to 1 to also include selection of last
%                             impulse response value to use (thus overrides
%                             NLines input parameter
%

%=========================================================================
% Check input parameters
%=========================================================================
% If MIF is not given, ir2ptime is called directly, and not from frf2ptime.
% Then, use alternative MIF function based on the sum of the FFTs of h
if nargin == 5
    H=fft(h);
    [N,D,R]=size(H);
    H=H(1:N/2+1,:,:);
    f=makexaxis(H(:,1,1),fs/N);
    fOffset=0;
    MIF=amif(j*H,'mvmif');
    MIF=MIF(:,1);
    plot(MIF);
else
    MIF=MIF/max(MIF(1:end));
end
EstType=upper(EstType);
%=========================================================================
% If a selection of start and perhaps end point in the first h(t) is
% requested, produce a plot and have user select points to use
if SelStartTime == 1
    hfig=figure;
    plot(h(:,1,1))
    xlabel('Sample Number')
    if SelEndTime == 0
        title('Select start time in impulse response')
        [xx,dum]=ginput(1);
        while length(h(:,1,1)) - xx < NLines
            title('Too high start point to allow Nlines=%i. Select lower start point!\n',NLines);
        end
        tlo=max(1,round(xx));
        thi=xx+NLines-1;
    else
        title('Select start and end time in impulse response')
        [xx,dum]=ginput(2);
        if strcmp(EstType,'LSCE') | strcmp(EstType,'PRONY')     % Single reference methods!
            while (max(xx)-min(xx)) < MaxModes+1
                title('Too narrow range, select a higher time for end point!\n');
                xx=ginput(2);
            end
        else
            while (max(xx)-min(xx)) < R*MaxModes+1
                title('Too narrow range, select a higher time for end point!\n');
                xx=ginput(2);
            end
        end
        tlo=min(round(xx));
        tlo=max(1,tlo);
        thi=max(round(xx));
    end
else
    tlo=10;
%     thi=floor(length(h(:,1,1))/2);   % Bug fixed 2018-01-05
    thi=tlo+NLines-1;
end

% Truncate h matrix to thi-tlo+1 time samples
if mod(thi-tlo+1,2) ~= 0
    thi=thi+1;
end
h=h(tlo:thi,:,:);
[N,D,R]=size(h);

%=========================================================================
% Estimate depending on EstType
%=========================================================================
if strcmp(EstType,'PRONY')
    % The prony method is a local method, i.e. it uses only one FRF at the
    % time. It should be used preferably when only a single FRF is to be
    % fitted. The implementation here uses a stabilization diagram on every
    % impulse response, and then averages all poles, assuming the same number
    % of modes have been selected from each impulse response.
    % This is not an ideal solution, as in the case of several responses,
    % the ideal model order could vary. Use 'lsce' for larger data sets.
    %
    % Use first h to find model order
    Col=1;                          % Index into pole matrix
    for d=1:D
        for r=1:R
%             ht=h(tlo:thi,d,r);           % Use first h to find order of system
%           Next line: bug fix 2013-06-09: removed tlo:thi to work with new layout
            ht=h(:,d,r);                   % Use first h to find order of system
            for Order = 1:MaxModes     % Number of modes
                [B,A]=prony(ht,2*Order-2,2*Order);
                Roots=roots(A);
                Poles{Order}=fs*log(Roots);
                NumberModes(Order)=Order;
            end
            % Adjust poles for the limited frequency range
            for Order=1:MaxModes
                for n=1:length(Poles{Order})
                    Sign=sign(imag(Poles{Order}(n)));
                    wr=abs(Poles{Order}(n))+2*pi*fOffset;
                    zr=-real(Poles{Order}(n))/wr;
                    Poles{Order}(n)=-zr*wr+j*Sign*wr*sqrt(1-zr^2);
                end
            end
            p(:,Col)=sdiagramnew(f,Poles,2*NumberModes,MIF);
            Col=Col+1;
        end             % Reference
    end                 % Response
    % Now transpose pole matrix and average, if more than one FRF was
    % fitted
    p=p.';
    [n,m]=size(p);
    if m > 1 && n > 1
        p=mean(p);
    end
    p=p(:);
    L=1;
elseif strcmp(EstType,'LSCE')
    %=========================================================================
    % Least Squares Complex Exponential
    %=========================================================================
    % Least squares complex exponential is a global method, taking all FRFs
    % into account, but with no modal participation matrix (MPF) (i.e., it
    % is a scalar that we set to 1 here and thus ignore). The implementation
    % here uses all FRFs in the H matrix, even for several references, but
    % all FRFs are put together without respect to reference location.
    % This means that repeated poles will be estimated, but the mode shapes
    % will perhaps not be correctly estimated by frf2modes, because the lack
    % of MPF.
    % The least squares solution is produced by pinv() or \, see code around
    % line 238.
    %
    % Build the Toeplitz matrix
    T=toeplitz(flipud(h(:,1,1)));
    T=fliplr(T);
    T=T(1:end/2,1:end/2);
    for d=2:D
        for r=1:R
            Tt=toeplitz(flipud(h(:,d,r)));
            Tt=fliplr(Tt);
            T=[T; Tt(1:end/2,1:end/2)];
        end
    end
    % Go through all requested orders
    NoModes=[];
    for Order=1:MaxModes
        NoModes=[NoModes Order];
        N=2*Order;
        A=T(:,1:N);
        B=-T(:,N+1);
%         disp(['Size A: ' num2str(size(A))])
%        alfa=pinv(A)*B;
        alfa=A\B;
        alfa=[alfa;1];
        Roots=roots((alfa));
        p=fs*log(Roots);
        Poles{Order}=p;
    end
    % Adjust frequencies for offset due to limited frequency range
    for Order=1:MaxModes
        for n=1:length(Poles{Order})
            Sign=sign(imag(Poles{Order}(n)));
            wr=abs(Poles{Order}(n))+2*pi*fOffset;
            zr=real(Poles{Order}(n))/wr;
            Poles{Order}(n)=-zr*wr+j*Sign*wr*sqrt(1-zr^2);
        end
    end
    p=sdiagramnew(f,Poles,2*NoModes,MIF);        % Select poles in stability diagram
    L=1;
elseif strcmp(EstType,'PTD')
    %=========================================================================
    % Polyreference Time Domain
    %=========================================================================
    % The polyreference time domain method is a global MIMO method.
    % It computes both poles and modal participation factors
    % with a stabilization diagram in which poles can be chosen.
    % Closely spaced or repeated modes can be computed with this technique.

    % Build block Hankel matrix of order MaxModes+1 by 5 times more columns
    nr=2*MaxModes;
    nc=round(5*nr/D);
    % Build the block Hankel matrices
    % Build H1 with R extra rows at the bottom, which will be used for H2
    H1=h2ptdhankel(h,nr+1,nc);
    % Loop through model orders
    for Np = R:R:2*MaxModes      % Np is number of poles (2 per mode)
        % Reduce matrices to size Np
        H1p=H1(1:Np,:);
        H2p=H1(Np+1:Np+R,:);
        % Solve the matrix coefficients in LS sense
%         A=H2p*pinv(H1p);
        A=H2p/H1p;
        % Build the companion matrix, C
        % Start with first row which goes "backwards" compared to A
        L=length(A(1,:));
        for n = 1:Np/R
            C(1:R,(n-1)*R+1:n*R)=A(:,L-n*R+1:L-(n-1)*R);
        end
        % Then fill rest of C with diagonal with identity matrices
        for n = 1:Np/R-1
            Z=zeros(R,Np);
            Z(1:R,(n-1)*R+1:n*R)=eye(R);
            C=[C;Z];
        end
        % Solve eigenvalues and conv to poles
        [Vp,Dp]=eig(C);
        Dp=diag(Dp);
        poles=fs*log(Dp);
        %     [fr,zr]=poles2fz(poles)
        % Extract MPFs
        MPFt=Vp(1:R,:);
        % Save to arrays
        NoPoles(Np/R)=length(poles);
        Poles{Np/R}=poles;
        MPF{Np/R}=MPFt;
        clear C
    end
    % Adjust frequencies for offset due to limited frequency range
    for Order=1:length(Poles)
        for n=1:length(Poles{Order})
            Sign=sign(imag(Poles{Order}(n)));
            wr=abs(Poles{Order}(n))+2*pi*fOffset;
            zr=abs(real(Poles{Order}(n)))/wr;
            Poles{Order}(n)=-zr*wr+j*Sign*wr*sqrt(1-zr^2);
        end
    end
    [p,SelOrder]=sdiagramnew(f,Poles,NoPoles,MIF);        % Select poles in stability diagram
    % % Find modal participation factors corresponding to the selected poles
    clear V L
    for n = 1:length(p)
        o_idx = find(NoPoles == SelOrder{n});           % which order was clicked?
        [m,p_idx]=min(Poles{o_idx} - p(n));             % Closest pole
        L(n,:)=MPF{o_idx}(:,p_idx).';                   % Corresponding participation factors
    end
    if exist('L') == 0
        L=1;
    end
elseif strcmp(EstType,'MMITD')
    %=========================================================================
    % Modified multiple-reference Ibrahim time 
    %=========================================================================
    % The modified multiple-reference Ibrahim time domain method is a 
    % global MIMO method. It computes both poles and modal participation 
    % factors with a stabilization diagram in which poles can be chosen.
    % Closely spaced or repeated modes can be computed with this technique.
    
    dt=1/fs;
    %
    % Build block Hankel matrix of order 2*MaxModes
    nr=2*MaxModes;
    nc=nr;
    H1=h2hankel(h,nc,nr,1);     % Hankel at t
    H2=h2hankel(h,nc,nr,2);     % Hankel at t+dt
    % Compute transfer matrix
    [U,S,V]=svd(H1);
    % Loop through model orders. Start with first even number >= R
    if mod(R,2) == 0
        FirstOrder=R;
    else
        FirstOrder=R+1;
    end
    for Np = FirstOrder:2:2*MaxModes      % Np is number of poles (2 per mode)
        % Reduce matrices to size Np
        Vp=V(:,1:Np);       % V prime
        H1p=Vp.'*H1';       % Hankel(t) prime
        H2p=Vp.'*H2';       % ditto at t+dt
        % Build compressed system matrix
        Ap=(H2p*H1p.')*pinv(H1p*H1p.');
        % Solve eigenvalues and conv to poles
        [Lpt,Dp]=eig(Ap);
        Lp=Lpt.';
        Dp=diag(Dp);
        poles=log(Dp)/dt;
        % Expand (transposed) modal participation factors
        Lptemp=(pinv(Vp.')*Lp.').';
        % Save to arrays
        NoPoles(Np/2)=Np;
        Poles{Np/2}=poles;
        MPF{Np/2}=Lptemp(1:Np,1:R);
    end
    % Adjust frequencies for offset due to limited frequency range
    for Order=1:MaxModes
        for n=1:length(Poles{Order})
            Sign=sign(imag(Poles{Order}(n)));
            wr=abs(Poles{Order}(n))+2*pi*fOffset;
            zr=abs(real(Poles{Order}(n)))/wr;
            Poles{Order}(n)=-zr*wr+j*Sign*wr*sqrt(1-zr^2);
        end
    end
    [p,SelOrder]=sdiagramnew(f,Poles,NoPoles,MIF);        % Select poles in stability diagram
    % % Find modal participation factors corresponding to the selected poles
    clear V L
    for n = 1:length(p)
        o_idx = find(NoPoles == SelOrder{n});           % which order was clicked?
        [m,p_idx]=min(Poles{o_idx} - p(n));             % Closest pole
        L(n,:)=MPF{o_idx}(p_idx,:);                     % Corresponding participation factors
    end
    if exist('L') == 0
        L=1;
    end
end

