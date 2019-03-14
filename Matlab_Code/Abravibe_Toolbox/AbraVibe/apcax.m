function [PC,CVCxx,VCxx] = apcax(Gxx)
% APCAX  Compute principal components and cumulated virtual coherences 
%
%       [PC,CVCxx,VCxx] = apcax(Gxx)
%
%       PC          Principal components based on Gxx, N/2+1-by-R
%       CVCxx       Cumulated virtual coherences between PC's and signals x, N/2+1-by-R-by-R
%                   2nd indeces are signals x, 3rd indeces are virtual signals x'
%       VCxx        Virtual coherences between PC's and signals, same
%                   indeces as for CVCxx
%
%       Gxx         Input cross-spectral density matrix, N/2+1-by-R-by-R
%       Gyx         Input/output cross-spectral density matrix, N/2+1-by-D-by-R
%
%       N           FFT blocksize
%       D           Number of responses, y
%       R           Number of references, x
%
% See also APCAXY ACSDW TIME2XMTRX

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2014-05-07 Added VCxx as output
% This file is part of ABRAVIBE Toolbox for NVA

[N,R,dum]=size(Gxx);        % Note: N is used as number of freq. lines here, not FFT blocksize

% Compute principal components
if nargout == 1
    for f=1:N
        Gxxf=squeeze(Gxx(f,:,:));
        PC(f,:)=svd(Gxxf);
        A=PC(f,:);
    end
elseif nargout >= 2
    VCxx=zeros(N,R,R);
    for f=1:N
        Gxxf=squeeze(Gxx(f,:,:));
        [U1,S,U2]=svd(Gxxf);
        PC(f,:)=diag(S);
        VGxxf=Gxxf*U1;                  % Virtual cross spectrum
        Gxxf=real(diag(Gxxf));          % Reduce to autospectra
        for x_sig=1:R
            for pc_sig=1:R
                VCxx(f,x_sig,pc_sig)=abs(VGxxf(x_sig,pc_sig))^2/Gxxf(x_sig)/PC(f,pc_sig);
            end
        end
    end
end

if nargout > 1
    % From the virtual coherences, now cumulate the results
    for x_sig=1:R
        for r = 1:R
            if r == 1
                CVCxx(:,x_sig,r)=VCxx(:,x_sig,1);
            else
                CVCxx(:,x_sig,r)=CVCxx(:,x_sig,r-1)+VCxx(:,x_sig,r);
            end
        end
    end
end