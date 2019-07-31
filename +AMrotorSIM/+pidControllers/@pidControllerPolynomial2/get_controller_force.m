function force = get_controller_force(obj,time,displacement)
% force = [I, x]*A*[I^2;x^2] + [I,x]*B*[I;x] + cT*[I;x] + d

A = obj.A;
B = obj.B;
cT = obj.cT;
d = obj.d;

dof_name = {'u_x','u_y','u_z','psi_x','psi_y','psi_z'};
dof_loc = [1,2,3,4,5,6];
ldof = containers.Map(dof_name,dof_loc);
entryNo = ldof(obj.direction);

Z = [obj.current; displacement(entryNo)];

force = Z.'*A*(Z.^2) + Z.'*B*Z + cT*Z + d;

end