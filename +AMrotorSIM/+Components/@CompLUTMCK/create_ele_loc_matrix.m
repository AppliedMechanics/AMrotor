function create_ele_loc_matrix(self)

        %Vektorversion der Lokalisierungsmatrix:
        Lv0_ele = [1,2,3,4,5,6]; % vertauscht, damit forward und backward whirl stimmen
        
        %Matrixversion:
        L_ele = sparse(6,6); 
        for k = 1:6
            L_ele(k,Lv0_ele(k)) = 1;
        end
            
        self.localisation_matrix = L_ele;             
end