function current = get_controller_current(obj,tCurr,y)
% get the current of the controller
%   obj: pidController-object
%   t: time-vector of solution
%   y: position vector at the corresponding controller node

current = get_controller_current@AMrotorSIM.pidControllers.pidController(obj,tCurr,y); % inherited from super-class

obj.current = current;

end