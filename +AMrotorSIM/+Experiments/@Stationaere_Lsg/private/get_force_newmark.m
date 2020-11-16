function f = get_force_newmark(obj,t,x,dotx)
% Extracts the force from load-objects and from controller-objects
%
%    :param t: Time step
%    :type t: double
%    :param x: State vector (Z = [x; dotx];)
%    :type x: vector
%    :param dotx: Derivative part of state vector Z = [x; dotx];
%    :type dotx: vector 
%    :return: Force vector f

% Licensed under GPL-3.0-or-later, check attached LICENSE file

Z = [x; dotx];


f_loads = obj.rotorsystem.assemble_system_loads(t,Z);
f_controllers = obj.rotorsystem.assemble_system_controller_forces(t,Z);
f = f_loads + f_controllers;

end