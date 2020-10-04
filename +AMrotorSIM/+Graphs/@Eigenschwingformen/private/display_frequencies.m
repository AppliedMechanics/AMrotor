% Licensed under GPL-3.0-or-later, check attached LICENSE file

function display_frequencies( strCoordinate, D )
% Displays the eigenfrequencies in the Command Window
%
%    :param strCoordinate: Description of the eigenfrequency
%    :type strCoordinate: char
%    :param eigenvalue: EV's from the modal analysis
%    :type eigenvalue: complex double
%    :return: Notification of the eigenfrequencies

D = imag(D);
disp([strCoordinate,' ',num2str(D/(2*pi)),' Hz'])

end

