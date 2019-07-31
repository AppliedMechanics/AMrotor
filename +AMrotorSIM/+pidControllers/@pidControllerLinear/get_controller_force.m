function force = get_controller_force(obj,varargin)
ki = obj.ki;

force = ki * obj.current;

end