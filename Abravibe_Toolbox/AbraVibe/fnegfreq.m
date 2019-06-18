function [Yn,fn] = fnegfreq(Y,Type,f);
% FNEGFREQ  Create negative frequencies by mirroring positive
%
%       [Yn,fn] = fnegfreq(Y,Type,f);
%
%           Yn      Complete spectrum with negative and positive frequencies
%           fn      Frequency axis for Y. Requires input parameter f
%
%           Y       Input spectrum with frequencies from 0 to fs/2
%           Type    If 'plot', then fn and Yn contains neqative frequencies
%                   in the lower part of the vectors, so it will plot intuitively
%                   If 'fft' then fn and Yn contains negative frequencies
%                   in the upper part, the way FFT and IFFT wants it.
%                   'plot' is default
%           f       Frequency axis for Y (optional)
%
% It is assumed that Y (and f if given) contain frequencies from 0 to fs/2.
% If the original blocksize to produce Y was N, then Y must be size N/2+1,
% and only Y(2:end-1) will be mirrored, to produce a total length of Yn of
% 2N. It is also assumed that the original time function was real-valued,
% so that the spectrum Y has an even real part and an odd imaginary part.
% If Y contains more than one column, each column is treated as a separate
% spectrum, and produce one corresponding column in Yn. 

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2012-04-10  Added support for 3D-matrices (N-by-D-by-R)
% This file is part of ABRAVIBE Toolbox for NVA

% Check parameters
if nargout == 2
    if nargin < 3
        error('If fn is requested, then f must be given as input parameter');
    end
end

% Find size of Y
[N,D,R]=size(Y);
% if R ~= 1
%     error('Dimension error. Y must contain maximum 2 dimensions');
% end

if nargin > 1 && strcmp(upper(Type),'FFT')
    Yn=zeros(2*(N-1),D,R);
    for r = 1:R
        for d = 1:D
            Yn(:,d,r)=[Y(:,d,r);conj(Y(end-1:-1:2,d,r))];
        end
        if nargin == 3
            f=f(:);
            fn=[f ; -f(2:end-1)];
        end
    end
else
    Yn=zeros(2*(N-1),D,R);
    for r = 1:R
        for d = 1:D
            Yn(:,d,r)=[conj(Y(end-1:-1:2,d,r)); Y(:,d,r)];
        end
        if nargin == 3
            f=f(:);
            fn=[-f(end-1:-1:2); f];
        end
    end
end