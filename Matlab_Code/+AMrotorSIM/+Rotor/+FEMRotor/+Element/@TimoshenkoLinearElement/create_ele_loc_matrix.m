function create_ele_loc_matrix(self,fe_model)

        %Vektorversion der Localisierungsmatrix:
        Lv0_ele = [3,9,6,12,1,5,7,11,2,4,8,10];
        
        %Matrixversion:
        L_ele = sparse(12,12); 
        for k = 1:12
            L_ele(k,Lv0_ele(k)) = 1;
        end
            
        self.localisation_matrix = L_ele;           
end