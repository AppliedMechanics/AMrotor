name='TestRigLam';
ndof=6;

for number=1:2
    for ecc=[0,50,80,90,95]
        clearvars -except number ecc  name ndof
        filename = [name,num2str(number),'Ecc',num2str(ecc)];
        load(filename)
        
        % Bringe cell auf groesse 6x6 (fuelle einfach mit zeros aus)
        if size(M_seal,1)<ndof
            istart = size(M_seal,1)+1;
            jstart = size(M_seal,2)+1;
            
            for i=istart:ndof % Zeilen auffuellen
                for j=1:ndof
                    M_seal{i,j}=zeros(length(rpm),1);
                    C_seal{i,j}=zeros(length(rpm),1);
                    K_seal{i,j}=zeros(length(rpm),1);
                end
            end
            
            for i=1:ndof % Spalten auffuellen
                for j=jstart:ndof
                    M_seal{i,j}=zeros(length(rpm),1);
                    C_seal{i,j}=zeros(length(rpm),1);
                    K_seal{i,j}=zeros(length(rpm),1);
                end
            end
        end
        
        %vertauschen, da in Eingabe-files falsch rum
        tmp.M_seal = M_seal;
        M_seal{1,1} = tmp.M_seal{2,2};
        M_seal{2,2} = tmp.M_seal{1,1};
        M_seal{1,2} = tmp.M_seal{2,1};
        M_seal{2,1} = tmp.M_seal{1,2};
        tmp.C_seal = C_seal;
        C_seal{1,1} = tmp.C_seal{2,2};
        C_seal{2,2} = tmp.C_seal{1,1};
        C_seal{1,2} = tmp.C_seal{2,1};
        C_seal{2,1} = tmp.C_seal{1,2};
        tmp.K_seal = K_seal;
        K_seal{1,1} = tmp.K_seal{2,2};
        K_seal{2,2} = tmp.K_seal{1,1};
        K_seal{1,2} = tmp.K_seal{2,1};
        K_seal{2,1} = tmp.K_seal{1,2};
        clear tmp
        
        stiffness_matrix = K_seal; % [N/m]
        %dof: [u_x, u_y, u_z, psi_x, psi_y]',
        damping_matrix = C_seal;
        mass_matrix = M_seal;
        rpm = rpm;
        save([filename],'stiffness_matrix','damping_matrix','mass_matrix','rpm','par')
        
    end
end