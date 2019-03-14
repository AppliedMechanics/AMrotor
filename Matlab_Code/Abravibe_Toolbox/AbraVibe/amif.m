function Mif = amif(H,Type)
% AMIF   Calculate mode indicator function of (accelerance) FRFs
%
%       Mif = amif(H,Type)
%
%       Mif     Mode indicator function(s)
%
%       H       Frequency response, can be single function or matrix up to
%               3D dimensions N-by-D-by-R
%       Type    String with MIF type:
%               'mif1'  produces mif 1 (sum(imag)^2/sum(abs)^2 type)
%               'power' produces sum(abs(H)^2)
%               'mvmif' produces multivariate mif (Default) (multireference)
%               'mrmif' produces modified real mif (multireference)
%               'cmif'  produces the complex mif (which is real, as the others)

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2012-04-04 Changed default to 'mvmif'
% This file is part of ABRAVIBE Toolbox for NVA

% Reference: 
% Rades, M.: A Comparison of Some Mode Indicator Functions, Mechanical
% Systems and Signal Processing, 1994, 8, p. 459-474

% Check input parameters
if nargin == 1
    Type='MVMIF';
else
    Type=upper(Type);
end

[N,D,R]=size(H);

if strcmp(Type,'MIF1')
    if R > 1                % Produce one larger matrix, with R*D columns
        Hr=real(H(:,:,1));
        Ha=abs(H(:,:,1));
        for r=2:R
            Hr=[Hr real(H(:,:,r))];
            Ha=[Ha abs(H(:,:,r))];
        end
    else                    % Use H as it is
        Hr=real(H);
        Ha=abs(H);
    end
    Hr=Hr';
    Ha=Ha';
    Mif = (sum(Hr.^2)./sum(Ha.^2))';
    Mif(1)=Mif(2);                      % Avoid NaN at DC
elseif strcmp(Type,'POWER')
    if R > 1                % Produce one larger matrix, with R*D columns
        Ha=abs(H(:,:,1));
        for r=2:R
            Ha=[Ha abs(H(:,:,r))];
        end
    else
        Ha=abs(H);
    end
    Mif = sum((Ha').^2)';
elseif strcmp(Type,'MVMIF')
    for n=2:N               % Loop through frequencies except DC
        Hf=permute(H(n,:,:),[2 3 1]);
        Hi=imag(Hf);
        Hr=real(Hf);
        A=Hr'*Hr;
        B=Hi'*Hi;
        D=eig(A,A+B);
        D=sort(D);
        Mif(n,:)=D';     
    end
    Mif(1,:)=Mif(2,:);      % Set first frequency (usually 0) equal to second
elseif strcmp(Type,'MRMIF')
    for n=2:N               % Loop through frequencies except DC
        Hf=permute(H(n,:,:),[2 3 1]);
        Hi=imag(Hf);
        Hr=real(Hf);
        A=Hr.'*Hr;
        B=Hi.'*Hi;
        D=eig(pinv(B)*A);
        D=sort(D);
        Mif(n,:)=D';     
    end
    Mif(1,:)=Mif(2,:);
    Mif(find(Mif>1))=1;             % Fix numerical roundoff
elseif strcmp(Type,'CMIF')
    for n=2:N               % Loop through frequencies except DC
        Hf=permute(H(n,:,:),[2 3 1]);
        S=svd(Hf);
        Mif(n,:)=S';
    end
    Mif(1,:)=Mif(2,:);
end
