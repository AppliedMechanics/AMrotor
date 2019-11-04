function f = get_force_newmark(obj,t,x,dotx)
% get the force from load-objects and from controller-objects

Z = [x; dotx];


f_loads = obj.rotorsystem.assemble_system_loads(t,Z);
f_controllers = obj.rotorsystem.assemble_system_controller_forces(t,Z);
f = f_loads + f_controllers;

end