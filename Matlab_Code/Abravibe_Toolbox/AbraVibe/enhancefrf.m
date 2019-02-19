function [He,Se] = enhancefrf(H, type);
% ENHANCEFRF     Enhance FRF matrix by Singular Value Decomposition
%
% Syntax:       [He, Se] = enhancefrf(H, type);
%               [He, Se] = enhancefrf(H, Dr)
%
%       He      Enhanced FRF matrix, size N-by-Dr-by-R
%       Se      Singular values for each reference Dr-by-R
%
%       H       FRF matrix size, N-by-D-by-R
%       type    'auto' (default) or 'manual', see comment below.
%       NumResp Number of principal responses to compress to
%       N       Number of frequency lines
%       D       Number of responses
%       R       Number of references
%       Dr      Reduced number of responses (principal responses)
%
% This function uses Singular Value Decomposition to reduce the order of a
% frequency response (FRF) matrix. This method is commonly used to improve
% modal analysis results. In that case you should use He as input for the
% curve fit for poles (frequencies and dampings). Then use the
% original FRF matrix H to fit your mode shapes!
%
% If type is 'auto' the system is reduced to singular values > 1e-2
% times the highest singular value.
%
% If type is 'manual' a plot is produced where you can click at an
% apropriate number of singular values. In this case you should typically
% select a point where you see that the singular values (y-axis) have
% abruptly become very small (a 'knee', if there is one).
% 
% If the syntax with a number, Dr, as second input parameter is used, the
% matrix is condensed down to Dr principal responses.

% Copyright (c) 2009-2012 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2012-03-30   
% This file is part of ABRAVIBE Toolbox for NVA

% For theory consult Chapter 15 in Anders Brandt (2011): Noise and Vibration
% Analysis: Signal Analysis and Experimental Procedures," John Wiley and Sons.

% Set singular value limit. Change this value up or down if you please!
% This limit is multiplied with the highest singular value, and singular
% values less than this product are discarded.
Slimit = 1e-2;

% Parse inputs
if nargin == 1
    type = 'auto';
elseif nargin == 2
    if isnumeric(type)
        Dr=type;
        type='FIXED';
    end
end
type=upper(type);

[Nf,D,R]=size(H);
for r=1:R
    [U, S, V]=svd(H(:,:,r));
    if strcmp(type,'MANUAL') & r == 1
        figure
        plot(diag(S))
        ylabel('Singular values')
        xlabel('Singular Value Number')
        title('Select number of singular values. <RETURN> to continue...')
        [xx,dum]=ginput(1);
        N=round(xx);
    elseif strcmp(type,'AUTO') & r == 1
        N=min(find(abs(diag(S)) < Slimit*S(1,1)));
        if isempty(N)
            N=D;
        end
    elseif strcmp(type,'FIXED') & r == 1
        N=Dr;
    end
    Se(:,r)=diag(S(1:N,1:N));
    He(:,:,r)=U(:,1:N)*S(1:N,1:N)*V(1:N,1:N)';
end


