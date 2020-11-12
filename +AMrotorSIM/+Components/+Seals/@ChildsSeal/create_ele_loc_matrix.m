function create_ele_loc_matrix(self)
% Builds a simple local localisation matrix in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :return: Localisation matrix

% Licensed under GPL-3.0-or-later, check attached LICENSE file

        %Vector version of the  localisation matrix:
        Lv0_ele = [2,1,3,4,5,6]; % vertauscht, damit forward und backward whirl stimmen
        
        %Matrix version:
        L_ele = sparse(6,6); 
        for k = 1:6
            L_ele(k,Lv0_ele(k)) = 1;
        end
            
        self.localisation_matrix = L_ele;             
end