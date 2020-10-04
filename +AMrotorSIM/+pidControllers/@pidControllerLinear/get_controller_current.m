% Licensed under GPL-3.0-or-later, check attached LICENSE file

function current = get_controller_current(obj,tCurr,y)
% Provides the controller current in ampere
%
%    :parameter obj: Object of type pidController
%    :type obj: object
%    :parameter tcurr: Time step
%    :type tcurr: double ????
%    :parameter y: position vector at the corresponding controller node
%    :type y: vector
%    :return: Controller current

current = get_controller_current@AMrotorSIM.pidControllers.pidController(obj,tCurr,y); % inherited from super-class

obj.current = current;

end