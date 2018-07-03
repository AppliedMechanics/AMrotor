function mesh = create_mesh(self,mesh_opt,Geometry,material)

    mesh = AMrotorSIM.Rotor.FEMRotor.Mesh(mesh_opt);

    n_nodes = length(Geometry.nodes);
    geo_node_z=zeros(1,n_nodes);
    geo_node_x=zeros(1,n_nodes);

    for k=1:n_nodes

        geo_node_z(k) = Geometry.nodes(k).z;
        geo_node_x(k) = Geometry.nodes(k).x;

    end

    %% Meshing of the Geometry

    node_number = 1;
    i = 1;
    for k=2:n_nodes

        if geo_node_z(k-1) ~= geo_node_z(k)

            distance_nodes = geo_node_z(k)-geo_node_z(k-1);
            for j = mesh.d_min:mesh.d_min:mesh.d_max
                n_mesh_el = distance_nodes/j;

                if round(n_mesh_el) == n_mesh_el
                     break
                end

            end
            z = linspace(geo_node_z(k-1), geo_node_z(k), n_mesh_el);

            [m,b] = linegradient(geo_node_z(k-1),...
                geo_node_x(k-1), geo_node_z(k), geo_node_x(k));
            r = zeros(1, length(z));

           %Approximation der Schrägen mit Stufen falls die
           %Steigung der Funktion m ungleich 1

            for a = 1:length(z)    
                r(a)=m*z(a)+b;
            end

        %% Create a structure of Node-Objects
            for a = 1:length(z)
              if node_number == 1
                mesh.nodes(node_number) =...
                AMrotorSIM.Rotor.FEMRotor.MeshNode(node_number, z(a), r(a));
                node_number = node_number + 1;
              else
                  if z(a) == mesh.nodes(node_number-1).z
                      %Wenn die z Koordinaten vom vorherigem Knoten
                      %mit dem jetzigen möglichen Knoten übereinstimmt, Knoten nicht
                      %doppelt erstellen
                  else
                    mesh.nodes(node_number) =...
                        AMrotorSIM.Rotor.FEMRotor.MeshNode(node_number, z(a), r(a));
                    node_number = node_number + 1; 
                  end
               end  
            end
        end      
    end

    %%Define Mesh-Elements
    elem_nr = 1;
    for k = 1:(node_number-2)

       if mesh.nodes(k).z ~= mesh.nodes(k+1).z
        mesh.elements(elem_nr) = AMrotorSIM.Rotor.FEMRotor.Element.TimoshenkoLinearElement...
            (elem_nr,mesh.nodes(k),mesh.nodes(k+1), material);
        create_ele_loc_matrix(mesh.elements(elem_nr),self);
        calculate_geometry_parameters(mesh.elements(elem_nr),self);
        
        %Assemble elementary matrices
        assemble_stiffness_matrix(mesh.elements(elem_nr));
        assemble_mass_matrix(mesh.elements(elem_nr));
        assemble_gyroscopic_matrix(mesh.elements(elem_nr));
        
        elem_nr = elem_nr +1;
       end

    end
    
end