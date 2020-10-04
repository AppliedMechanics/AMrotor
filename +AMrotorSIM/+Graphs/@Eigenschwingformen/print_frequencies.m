% Licensed under GPL-3.0-or-later, check attached LICENSE file

function print_frequencies(obj)
% Displays the eigenfrequencies with their corresponding modal damping in the Command Window
%
%    :return: Notification of eigenfrequencies and damping

     n_ew=obj.modalsystem.n_ew;
      %
      %disp('Eigenkreisfrequenzen')
      disp('Angular eigenfrequency')
        for s=1:n_ew
            disp(' ')
            disp([num2str(s),'. eigenfrequency'])
            display_frequencies('lateral',obj.modalsystem.eigenValues.lateral(s))
            display_damping('lateral',obj.modalsystem.eigenValues.lateral(s))
        end
        
end