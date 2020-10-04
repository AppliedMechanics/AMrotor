% Licensed under GPL-3.0-or-later, check attached LICENSE file

function show(obj)
% Displays the object name in the Command Window
%
%    :param obj: Object of type Eigenschwingformen
%    :type obj: object
%    :return: Notification of object name

    disp(obj.name);
    disp(obj.modalsystem.name);
end
