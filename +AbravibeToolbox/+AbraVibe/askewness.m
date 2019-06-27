function S = askewness(x);
%ASKEWNESS Calculate skewness
%
%       S = askewness(x);
%
%       S           Skewness (third moment over sigma^3)
%
%       x           Time data, if more than one column, each column is
%                   computed and S is a row vector
% 
%


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Sigma=std(x);
S=amoment(x,3)./(Sigma.^3);
