function display_frequencies( strCoordinate, D )

D = imag(D);
disp([strCoordinate,' ',num2str(D/(2*pi)),' Hz'])

end

