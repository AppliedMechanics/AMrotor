function [Vout, Dout] = get_positive_entries( Vin, Din )
%GETPOSITIVEENTRIES Summary of this function goes here
%   Detailed explanation goes here
Dout = Din(imag(Din)>0);
Vout = Vin(:,imag(Din)>0);
end

