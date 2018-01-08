function displayFrequencies( strCoordinate, D, s )
%DISPLAYFREQUENCIES Summary of this function goes here
%   Detailed explanation goes here

disp([strCoordinate,' ',num2str(imag(D(s))/(2*pi)),' Hz'])

end

