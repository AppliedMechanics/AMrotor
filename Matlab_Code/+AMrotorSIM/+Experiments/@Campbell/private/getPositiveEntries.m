function D = getPositiveEntries( input )
%GETPOSITIVEENTRIES Summary of this function goes here
%   Detailed explanation goes here
D = input(imag(input)>0);
end

