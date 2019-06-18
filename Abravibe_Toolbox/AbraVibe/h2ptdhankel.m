function Hank = h2ptdhankel(h,nr,nc,nstart)
% H2PTDHANKEL   Build Hankel matrix of time functions for PTD method
%
%       Hank = h2hankel(h,nc,nstart)
%
%       Hank        The system Hankel matrix, R*nr-by-D*nc
%
%       h           Matrix of impulse responses, N/2+1-by-D-by-R
%       nr          Number of row time repetitions
%       nc          Number of column repetitions for each response
%       nstart      time sample to start at (default = 1)
%
% This is an internal function.

% Copyright (c) 2009-2012 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2012-04-15
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 3
    nstart=1;
end

% Skip first nstart-1 samples in h
h=h(nstart:end,:,:);

% Check size of h
[hLength,D,R]=size(h);

% Check that nc and nr does not exhaust h
if (nc+nr) > hLength
    error('nr+nc must be <= number of time samples in h')
end
    
% Build Hankel matrix with column vectors of all references
Hank=zeros(R*nr,D*nc);
h=permute(h,[3 1 2]);       % Now comes in order of ref, time, resp
for d = 1:D
    % Pick out the impulse response to repeat
    ht=h(:,:,d);
    % Make it a column vector
    ht=ht(:);
    % Repeat it shifted in nc columns
    for c = 1:nc
      Hankt(:,c)=ht((c-1)*R+1:(c-1+nr)*R);
    end
    % Move all vectors for this response into final Hankel matrix
    Hank(:,(d-1)*nc+1:d*nc)=Hankt;
end

