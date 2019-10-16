function num = set_dof_number(obj,direction)

dof_name = {'u_x','u_y','u_z','psi_x','psi_y','psi_z'};
dof_loc = [1,2,3,4,5,6];
ldof = containers.Map(dof_name,dof_loc);

ldof = containers.Map(dof_name,dof_loc);

if strcmpi(direction,'all')
    num = 1:6;
    return
end

if iscell(direction)
    for i=1:length(direction)
        if ischar(direction{i})
            num(i) = ldof(direction{i});
        elseif length(direction{i}) == 1
            num(i) = direction{i};
        end
    end
    
elseif ischar(direction)
    num = ldof(direction);
else
    num = direction;
end

% erweitere für mehr als einen Eingang


end