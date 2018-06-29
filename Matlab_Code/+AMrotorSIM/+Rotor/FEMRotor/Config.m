%-------Config for Geometry and Mesh Creation of a Rotorsystem------

%% Material Config

material.name = 'steel';
material.e_module = 211e9;  %[N/m^2]
material.density  = 7446;   %[kg/m^3] %%SI EINHEITEN!!
material.poisson  = 0.3;    %steel 0.27...0.3 [-]
material.shear_factor = 0.9;

%% Rotor Config
rotor.geo_nodes = {[0 0], [0 1], [1 1], [1 2], [2 2], [3 0.5], [4 0.5], [4 0]};
rotor.material = Material(material);
rotor.name = 'rotor';

%% FEM Config
mesh_opt.name = 'Mesh 1';
mesh_opt.d_min= 0.07;
mesh_opt.d_max = 0.1;
mesh_opt.approx = 'upper sum';   %Approximation for linear functions with gradient 1=0;
                                % Insert: upper sum, lower sum, mean.

%% Anwendung
geo = Geometry(rotor);
%geo.show_2D()
%geo.show_3D()
mesh = Mesh(mesh_opt);
fe_model = FeModel('FE Model',mesh);

fe_model.create_mesh(geo);
mesh.plot_mesh_2d();
fe_model.assemble_fem();
