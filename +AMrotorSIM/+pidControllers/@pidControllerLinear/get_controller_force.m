function force = get_controller_force(obj,varargin)
% Provides the controller force
%
%    :parameter varargin: Placeholder
%    :type varargin: 
%    :return: Controller force

% Licensed under GPL-3.0-or-later, check attached LICENSE file

ki = obj.ki;

force = ki * obj.current;

end