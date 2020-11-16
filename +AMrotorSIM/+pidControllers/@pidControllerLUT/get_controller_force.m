function force = get_controller_force(obj,time,displacement)
% Provides the controller force from LUT
%
%    :parameter tcurr: Time-vector of solution
%    :type tcurr: vector
%    :parameter displacement: Displacement
%    :type displacement: vector
%    :return: Controller force

% force = [I, x]*A*[I^2;x^2] + [I,x]*B*[I;x] + cT*[I;x] + d
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

dof_name = {'u_x','u_y','u_z','psi_x','psi_y','psi_z'};
dof_loc = [1,2,3,4,5,6];
ldof = containers.Map(dof_name,dof_loc);
entryNo = ldof(obj.direction);

u = displacement(entryNo); 

I = obj.current; 

uTable = obj.table.displacement;
iTable = obj.table.current;
fTable = obj.table.force;


force = interp2(uTable,iTable,fTable,u,I);


if u > max(uTable)
    warning(['Extrapolation of force for pidCOntroller from Look-Up-Table ',... 
            'at displacement of more than max(table.displacement)=',...
            num2str(max(uTable)),'. ',...
            'Results may be inaccurate!']);
end

if I > max(iTable)
    warning(['Extrapolation of force for pidCOntroller from Look-Up-Table ',... 
            'at current of more than max(table.current)=',...
            num2str(max(iTable)),'. ',...
            'Results may be inaccurate!']);
end

end