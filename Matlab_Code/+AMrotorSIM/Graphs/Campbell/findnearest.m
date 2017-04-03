function [valuevec,idxvec]=findnearest(vec1,vec2)
% [valuevec,idxvec] = findnearest(vec1,vec2)
% 
% Searches for vec2 values in vec1 and returns the 
% values which are closest to the vec2 numbers.
% Returns also the indexes. Function works with vectors
% and matrices!
%
%  (c) B. Käferstein

vec1     = vec1(:);
vec2     = vec2(:);
valuevec =  [];
idxvec   =  [];

for ncntr = [1:length(vec2)]
    [nil,idxvectmp] = min(abs(vec1-vec2(ncntr)));
    valuevectmp     = vec1(idxvectmp);
    valuevec  = [valuevec,valuevectmp];
    idxvec    = [idxvec,idxvectmp];
end
