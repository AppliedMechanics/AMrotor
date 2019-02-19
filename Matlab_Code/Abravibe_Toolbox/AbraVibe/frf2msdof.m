function [p,V] = frf2msdof(H,f,fstart,NoLines,Type,ScaleDof)
%FRF2MSDOF Curve fit FRFs into poles and mode shapes, SDOF techniques
%
%       [p,V] = frf2msdof(H,F,fstart,NoLines,Type,ScaleDof)
%
%       p           Complex poles in column vector
%       V           Mode shape matrix, each mode in a column, D-by-Nmodes
%
%       H           Matrix with accelerance FRF(s), N-by-D (single reference!)
%       f           Frequency axis for H
%       fstart      Vector with start frequencies (one for each mode)
%       NoLines     Number of frequency lines to use at each mode (ODD
%                   number!), default is 7
%       Type        String: (Default is 'poly')
%                   'lsqrl' uses an SDOF local least squares method
%                           (using only positive pole pair)
%                   'poly' uses an SDOF polynomial least squares method
%                          (using complex conjugate pair).
%       ScaleDof    Dof (column in H) to scale for (driving point) if D > 1
%
% Mode shapes are scaled to unity modal A (see, e.g. modal2frf)
%
% Note: It is recommended only to use this function for pole estimation, as
% mode shapes are normally better estimated by an MDOF method. If there are
% frequency shifts between the FRFs, this function can be used for mode
% shape estimation, and then 'poly' or 'lsqrl' should be used.
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

%*************************************************************************
% This file is still in development!
%*************************************************************************

if nargin == 3
    Type = 'LSQRL';
    NoLines=7;
else
    Type = upper(Type);
end

if mod(NoLines,2) == 0
    NoLines=NoLines+1;
end
idxs=(NoLines-1)/2;             % Index shift

[N,D]=size(H);

% Convert from assumed accelerance to receptance 
H=fint(H,f,'lin',2);


if strcmp(Type,'LSQRL')
    jw=j*2*pi*f;
    p=zeros(D,length(fstart));
    V=zeros(D,length(fstart));
    for hn = 1:D
        Hin=H(:,hn);
        for n = 1:length(fstart)
            idx=min(find(f >= fstart(n)));
            idx=idx-idxs:idx+idxs;
            jwt=jw(idx);
            Hvect=Hin(idx);
            % Build matrices
            A=[Hvect ones(size(Hvect))];
            B=jwt.*Hvect;
            % Solve for poles and mode shapes
            S=pinv(A)*B;
            p(hn,n)=S(1);
            V(hn,n)=S(2);
        end
    end
    % Check results for 'outliers' in frequency
    fr=poles2fz(p);
    % Check for freqs that differ > 10% from fstart(n)
    for mode = 1:length(fstart)
        idx=find(abs((fr(:,mode)-fstart(mode))/fstart(mode)) < 0.1);
        idx2=find(abs((fr(:,mode)-fstart(mode))/fstart(mode)) > 0.1);
        if ~isempty(idx)                % There was one or more badly fitted mode
            p=p(idx,:);
            V(idx2,mode)=0;              % Assume method diverges because close to node line
        end
    end
    % Average remaining poles and force to column
    p=mean(p);
    p=p(:);
elseif strcmp(Type,'POLY')
    jw=j*2*pi*f;
    w2=abs(jw.^2);
    p=zeros(D,length(fstart));
    V=zeros(D,length(fstart));
    for hn = 1:D
        Hin=H(:,hn);
        for n = 1:length(fstart)
            idx=min(find(f >= fstart(n)));
            idx=idx-idxs:idx+idxs;
            jwt=jw(idx);
            w2t=w2(idx);
            Hvect=Hin(idx)
            % Build matrices
            A=[Hvect 2*jwt.*Hvect -ones(size(Hvect))]
            B=w2t.*Hvect
            % Solve for poles and mode shapes
            S=pinv(A)*B
            ar=sqrt(S(1));
            br=S(2)./ar;
            p(hn,n)=-br.*ar+j*ar.*sqrt(1-br.^2);
            %idx=min(find(w2t>=ar^2));
        end
    end
    % Check results for 'outliers' in frequency
    fr=poles2fz(p);
    % Check for freqs that differ > 10% from fstart(n)
    for mode = 1:length(fstart)
        idx=find(abs((fr(:,mode)-fstart(mode))/fstart(mode)) < 0.1)
%         idx2=find(abs((fr(:,mode)-fstart(mode))/fstart(mode)) > 0.1);
        if ~isempty(idx)                % There was one or more badly fitted mode
            pnew(mode)=mean(p(idx,mode));
%             V(idx2,mode)=0;              % Assume method diverges because close to node line
        end
    end
    p=pnew(:);
    % Estimate mode shapes using estimated poles
    for hn = 1:D
        for n = 1:length(p)
            idx=min(find(f >= abs(p(n))/2/pi));
            idx=idx-idxs:idx+idxs;
            Hin=H(idx,hn);
            jwt=jw(idx);  
            for fl=1:length(idx)
                Rr(fl)=Hin(fl)*(jwt(fl)-p(n))*(jwt(fl)-conj(p(n)));
            end
            V(hn,n)=mean((Rr))/(j*2*imag(p(n)));
            clear Rr
        end
    end
end

% Scale modes
if D == 1
        V=sqrt(V);
else
    if ~isempty(V)
        for mode=1:length(V(1,:))
            V(:,mode)=V(:,mode)/sqrt(V(ScaleDof,mode));
        end
    end
end
