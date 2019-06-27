function K = akurtosis(x);
%AKURTOSIS Calculate kurtosis
%
%       K = akurtosis(x);
%
%       K           kurtosis (third moment over sigma^3)
%
%       x           Time data, if more than one column, each column is
%                   computed and S is a row vector
%
% Note: The kurtosis here is defined so that it equals exactly 3 for
% Gaussian data (normal distribution). 
%


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Sigma=std(x);
K=amoment(x,4)./(Sigma.^4);
