function [y,NoBlocks] = nskipblocks(x,N,NoSkip)
% NSKIPBLOCKS   Extract every NoSkip+1 blocks with size N from x
%
%       y = nskipblocks(x,N,NoSkip)
%
%       y       Output record with NoBlocks, each of size N
%
%       x       Input signal, may be several columns
%       N       Blocksize
%       NoSkip  Number of blocks to skip before taking one block into y
%               MUST be > 0 and integer

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

[Nrows,Ncols]=size(x);

NoBlocks=floor(Nrows/(NoSkip+1)/N);       % Number output blocks in y

y=zeros(NoBlocks*N,Ncols);
idx1=1;
idx2=N;
for n = 1:NoBlocks
    idx1=idx1+(NoSkip)*N;                 % Skip NoSkip blocks
    idx2=idx2+(NoSkip)*N;
    for c = 1:Ncols
        y((n-1)*N+1:n*N,c)=x(idx1:idx2,c);
    end
    idx1=idx1+N;
    idx2=idx2+N;
end

