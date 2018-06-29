function create_mesh(self,Geometry)
    %f = figure;
    self.geometry = Geometry;
    n_nodes = length(Geometry.geometry.nodes);
    geo_node_z=zeros(1,n_nodes);
    geo_node_x=zeros(1,n_nodes);

    for k=1:n_nodes

        geo_node_z(k) = Geometry.geometry.nodes(k).z;
        geo_node_x(k) = Geometry.geometry.nodes(k).x;

    end

    %% Meshing of the Geometry

    node_number = 1;
    i = 1;
    for k=2:n_nodes

        if geo_node_z(k-1) ~= geo_node_z(k)

            distance_nodes = geo_node_z(k)-geo_node_z(k-1);
            for j = self.mesh.d_min:self.mesh.d_min:self.mesh.d_max
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
            %Hier ein Switch Case rein    
%                     if m ~= 0
%                         switch self.approximation
%                             case 'lower sum'
%                                 z_new = zeros(1,2*length(z)-2);
%                                 z_new(1,1:2:length(z_new)) = z(1,1:end-1);
%                                 z_new(1,2:2:length(z_new)) = z(1,1:length(z)-1);
%                                                       
%                                 r_new = zeros(1,2*length(z)-1);
%                                 r_new(1,2:2:length(r_new)) = r(1,2:end);
%                                 r_new(1,1:2:length(r_new)) = r(1,1:end);
%                             
%                                 z = z_new;
%                                 r = r_new;
%                                 
%                             case 'upper sum'
%                                 z_new = zeros(1,2*length(z)-1);
%                                 z_new(1,1:2:length(z_new)) = z(1,1:end);
%                                 z_new(1,2:2:length(z_new)) = z(1,2:length(z));
%                                                       
%                                 r_new = zeros(1,2*length(z)-1);
%                                 r_new(1,2:2:length(r_new)) = r(1,1:end-1);
%                                 r_new(1,1:2:length(r_new)) = r(1,1:end);
%                             
%                                 z = z_new;
%                                 r = r_new;
%                             case 'mean'
%                         end
%                     end

        %% Create a structure of Node-Objects
            for a = 1:length(z)
              if node_number == 1
                self.mesh.nodes(node_number) =...
                MeshNode(node_number, z(a), r(a));
                node_number = node_number + 1;
              else
                  if z(a) == self.mesh.nodes(node_number-1).z
                      %Wenn die z Koordinaten vom vorherigem Knoten
                      %mit dem jetzigen möglichen Knoten übereinstimmt, Knoten nicht
                      %doppelt erstellen
                  else
                    self.mesh.nodes(node_number) =...
                        MeshNode(node_number, z(a), r(a));
                    node_number = node_number + 1; 
                  end
               end  
            end
        end      
    end

    %%Define Mesh-Elements
    elem_nr = 1;
    for k = 1:(node_number-2)

       if self.mesh.nodes(k).z ~= self.mesh.nodes(k+1).z
        self.mesh.elements(elem_nr) = Element.TimoshenkoLinearElement...
            (elem_nr,self.mesh.nodes(k),self.mesh.nodes(k+1), Geometry.material);
        create_ele_loc_matrix(self.mesh.elements(elem_nr),self);
        calculate_geometry_parameters(self.mesh.elements(elem_nr),self);
        
        %Assemble elementary matrices
        assemble_stiffness_matrix(self.mesh.elements(elem_nr));
        assemble_mass_matrix(self.mesh.elements(elem_nr));
        assemble_gyroscopic_matrix(self.mesh.elements(elem_nr));
        
        elem_nr = elem_nr +1;
       end

    end
end