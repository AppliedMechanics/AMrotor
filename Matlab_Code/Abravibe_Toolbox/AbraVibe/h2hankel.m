function Hank = h2hankel(h,nr,nc,nstart)
% H2HANKEL   Build Hankel matrix of time functions
%
%       Hank = h2hankel(h,nr,nc,nstart)
%
%       Hank        The system Hankel matrix
%
%       h           Matrix of impulse responses, N/2+1-by-D-by-R
%       nr          Number of row time shifts
%       nc          Number of column time shifts
%       nstart      time sample to start at (default = 1)
%

if nargin == 3
    nstart=1;
end

% Skip first nstart-1 samples in h
h=h(nstart:end,:,:);

% Check size of h
[hLength,D,R]=size(h);

% Check that nc and nr does not exhaust h

% Build Hank
Hank=zeros(D*nr,R*nc);
for c = 1:nc
    for r = 1:nr
        Hank(1+(r-1)*D:r*D,1+(c-1)*R:c*R)=squeeze(h(r+c-1,:,:));
    end
end

