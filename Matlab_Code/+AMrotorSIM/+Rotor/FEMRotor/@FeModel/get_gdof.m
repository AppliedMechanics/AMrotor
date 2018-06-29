function glob_dof = get_gdof(self,direction,Node)
    dof_name = {'u_x','u_y','u_z','xi_x','xi_y','xi_z'};
    dof_loc = [1,2,3,4,5,6];
    
    ldof = containers.Map(dof_name,dof_loc);
    
    
    if ischar(direction) == 1 
        entry_nr = ldof(direction);
    else
        error('Error: The first entry of get_gdof() has to be a string');
    end
        
    if isempty(find(ismember(dof_name,direction))) == 1
        error ('Error: Input not existent as a degree of freedom')
    end
    
    glob_dof = (Node-1)*6+entry_nr;
    
        
%     if isstring(Matrix) == 1 
%        error('Error: The third entry of find_entry() has to be a string');
%     end
%     
%     switch Matrix
%         case 'G'
%             result = Fe_Model.G(glob_dof,glob_dof);
%         case 'M'
%             result = Fe_Model.M(glob_dof,glob_dof);
%         case 'K'
%             result = Fe_Model.K(glob_dof,glob_dof);
%         case 'f'
%             result = Fe_Model.f(glob_dof,1);
%         case 'D'
%             result = Fe_Model.D(glob_dof,glob_dof);
%         otherwise
%             error('Error: Matrix not recognised or not a property of the FE Model');
%     end
 end

%% Rückgabewert den Global DoF 