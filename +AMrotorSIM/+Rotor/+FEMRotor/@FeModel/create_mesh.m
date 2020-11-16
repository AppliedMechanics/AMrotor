function mesh = create_mesh(self,mesh_opt,Geometry,material)
% Creates the mesh based on geometry
%
%    :parameter mesh_opt: Mesh options from Config-file
%    :type mesh_opt: struct 
%    :parameter Geometry: Geometry
%    :type Geometry: object
%    :parameter material: Material
%    :type material: object
%    :return: Mesh object

% Licensed under GPL-3.0-or-later, check attached LICENSE file

    mesh = AMrotorSIM.Rotor.FEMRotor.Mesh(mesh_opt);

    n_nodes = length(Geometry.nodes);
    geo_node_z=zeros(1,n_nodes);
    geo_node_x=zeros(1,n_nodes);
    geo_node_xi=zeros(1,n_nodes);

    for k=1:n_nodes

        geo_node_z(k) = Geometry.nodes(k).z;
        geo_node_x(k) = Geometry.nodes(k).x;
        geo_node_xi(k) = Geometry.nodes(k).xi; % Innenradius/Hohlwelle

    end

    %% Meshing of the Geometry

    node_number = 1;
    for k=2:n_nodes

        if geo_node_z(k-1) ~= geo_node_z(k)

            distance_nodes = geo_node_z(k)-geo_node_z(k-1);
            for d = linspace(mesh.d_max,mesh.d_min,mesh.n_refinement)
                n_mesh_el = distance_nodes/d;                

                if n_mesh_el > 0.5 || ((round(n_mesh_el)>n_mesh_el-1e-10) && (round(n_mesh_el)<n_mesh_el+1e-10))
                    % Falls das aktuelle d mindestens einmal in den Abstand 'distance_nodes' hineinpasst
                     break
                end

            end
            n_mesh_el =round(n_mesh_el,10); % wegen numerischer Genauigkeit, z.B. wenn n_mesh_el=1+1e-15 wegen num. Genauigkeit, soll n_mesh_el=1 sein
            z = linspace(geo_node_z(k-1), geo_node_z(k), ceil(n_mesh_el)+1); %"+1" fuer n_Knoten

            [m,b] = linegradient(geo_node_z(k-1),...
                geo_node_x(k-1), geo_node_z(k), geo_node_x(k));
            [mi,bi] = linegradient(geo_node_z(k-1),...
                geo_node_xi(k-1), geo_node_z(k), geo_node_xi(k)); % Hohlwelle
            r = zeros(1, length(z));
            ri = zeros(1, length(z)); % Hohlwelle

           %Approximation der Schrägen mit Stufen falls die
           %Steigung der Funktion m ungleich 1

            for a = 1:length(z)    
                r(a)=m*z(a)+b;
                ri(a)=mi*z(a)+bi;
            end

        %% Create a structure of Node-Objects
            for a = 1:length(z)
              if node_number == 1
                mesh.nodes(node_number) =...
                AMrotorSIM.Rotor.FEMRotor.MeshNode(node_number, z(a), r(a), ri(a));
                node_number = node_number + 1;
              else
                  if z(a) == mesh.nodes(node_number-1).z
                      %Wenn die z Koordinaten vom vorherigem Knoten
                      %mit dem jetzigen möglichen Knoten übereinstimmt, Knoten nicht
                      %doppelt erstellen
                      % immer den groessten Wert abspeichern
                      mesh.nodes(node_number-1).radius_outer = max(mesh.nodes(node_number-1).radius_outer, r(a));
                      mesh.nodes(node_number-1).radius_inner = max(mesh.nodes(node_number-1).radius_inner, ri(a));
                  else
                    mesh.nodes(node_number) =...
                        AMrotorSIM.Rotor.FEMRotor.MeshNode(node_number, z(a), r(a), ri(a));
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
        elem_nr = elem_nr +1;
       end
    end
    
    for el=mesh.elements
        
        el.create_ele_loc_matrix();
        el.calculate_geometry_parameters(mesh.approximation);
        
        %Assemble elementary matrices
        el.assemble_stiffness_matrix();
        el.assemble_mass_matrix();
        el.assemble_gyroscopic_matrix(); 
    end
    
end