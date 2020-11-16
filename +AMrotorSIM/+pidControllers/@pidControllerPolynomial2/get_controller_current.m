function current = get_controller_current(obj,tCurr,y)
% Provides the controller current 
%
%    :parameter obj: Object of type pidController
%    :type obj: object
%    :parameter tcurr: Time-vector of solution
%    :type tcurr: vector
%    :parameter y: position vector at the corresponding controller node
%    :type y: vector
%    :return: Controller current

% Licensed under GPL-3.0-or-later, check attached LICENSE file

current = get_controller_current@AMrotorSIM.pidControllers.pidController(obj,tCurr,y); % inherited from super-class

obj.current = current;

end