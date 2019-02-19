function [CVCyx, VPyyx, VGyx,VC] = apcaxy(Gxx,Gyx,Gyy)
% APCAXY  Compute cumulated virtual coherences etc. based on two sets of signals, x and y
%
%       [CVCyx, VPyyx, VGyx] = apcaxy(Gxx,Gyx,Gyy)
%
%       CVCyx       Cumulated virtual coherences between PC's and output, N/2+1-by-D-by-R
%       VPyyx       Virtual coherent output power (each virtual signals
%                   contribution in Gyy)
%       VGyx        Virtual cross-spectral density, N/2+1-by-D-by-R
%
%       Gxx         Input cross-spectral density matrix, N/2+1-by-R-by-R
%       Gyx         Input/output cross-spectral density matrix, N/2+1-by-D-by-R
%       Gyy         Output autospetral density matrix
%       N           FFT blocksize
%       D           Number of responses, y
%       R           Number of references, x
%
% See also apcax acsdw time2xmtrx odspick

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

[N,R,dum]=size(Gxx);
[N,D,dum]=size(Gyx);
if D > 1
    error('Multiple outputs not implemented yet. Run one output at the time')
end

for f=1:N
%     if nargout == 1
%         Gxxt=squeeze(Gxx(f,:,:));
%         PC(f,:)=svd(Gxxt);
%     elseif nargout > 1
        Gxxf=squeeze(Gxx(f,:,:));
        Gyxf=(Gyx(f,:));
        Gyyf=Gyy(f,:);
        [U1,S,U2]=svd(Gxxf);
        PC(f,:)=diag(S);
        Gxx_p=Gxxf*U1;              % Virtual cross spectrum
        Gxxf=diag(Gxxf);            % Reduce to autospectra
        VGyx(f,:)=Gyxf*U1;          % Virtual input/output cross spectrum
        S=diag(S);                  % Reduce to vector
        TC=[];
        for pc_sig=1:R
            TC=[TC abs(VGyx(f,pc_sig))^2/(Gyyf*S(pc_sig))];
        end
        VC(f,:)=TC;
%     end
end

% From the virtual coherences, now cumulate the results
for r = 1:R
    if r == 1
        CVCyx(:,r)=VC(:,1);
    else
        CVCyx(:,r)=CVCyx(:,r-1)+VC(:,r);
    end
end

% If requested, compute each virtual coherent output power
if nargout > 1
    for r = 1:R
        VPyyx(:,r)=Gyy.*VC(:,r);
    end
end
