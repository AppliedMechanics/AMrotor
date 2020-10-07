.. _Tutorial:

Tutorial
========

A very brief tutorial of a Laval-rotor should show the working principle of AMrotor.
To get deeper into AMrotor check :ref:`Examples`.

To run a simulation with AMrotor, two scripts are necessary:

* Configuration-script, contains all the necessary parameters for the subsequent simulation. These parameters contain
  information about the rotor and all additional components. Essential for the config-script is the initialization of
  all the necessary fields of the struct. If the struct-fields are not needed they can be left empty.

* Simulation-script, contains the assembly and the desired analyses applied on the model.

The scope of this tutorial is to build a simple Laval-rotor model with two simple radial bearings and
a disc in the center modelled as part of the rotor (no extra disc component). Therefore the following two
scripts are necessary.

Configuration script
++++++++++++++++++++

The following config-script can be copied-and-pasted into an empty matlab script. The script
must then be saved into the AMrotor path. For this tutorial we save the script with the name "Config_Tutorial"
in the Simulation- (Simulationen) folder of AMrotor. Eventually the folder has to be added
to the path. The name of the config-script is important, since it's later
needed in the simulation-script. By running the saved script the config-struct (cnfg) will be build.

.. code-block:: matlab 
   :linenos:
  
    %% Configuration

    %% ================Rotor===================================================
    %% Building of the rotor struct
    cnfg.cnfg_rotor.name = 'Simple example: Laval-Rotor';
    % All units in SI 
    cnfg.cnfg_rotor.material.name = 'steel';
    cnfg.cnfg_rotor.material.e_module = 211e9;  %[N/m^2]
    cnfg.cnfg_rotor.material.density  = 7860;   %[kg/m^3]
    cnfg.cnfg_rotor.material.poisson  = 0.3;    %[-]
    % Rayleigh damping: D=alpha1*K + alpha2*M
    cnfg.cnfg_rotor.material.damping.rayleigh_alpha1= 1e-5;
    cnfg.cnfg_rotor.material.damping.rayleigh_alpha2= 10;

    %% Rotor Config
    rW = 10e-3; % Radius of the shaft [m]
    rS = 50e-3; % Radius of the disc [m]
    % Format of the geometry definition: {[z, r_outer, r_inner], ...} without..
    % start- and end-node
    cnfg.cnfg_rotor.geo_nodes = {[0 rW 0], [0.220 rW 0], [0.220 rS 0], ...
    [0.280 rS 0], [0.280 rW 0], [0.500 rW 0]};
    clear rW rS

    %% FEM Config
    cnfg.cnfg_rotor.mesh_opt.name = 'Mesh 1';
    % Number of refinement steps between d_min and d_max
    cnfg.cnfg_rotor.mesh_opt.n_refinement = 10;
    cnfg.cnfg_rotor.mesh_opt.d_min = 0.001;
    cnfg.cnfg_rotor.mesh_opt.d_max = 0.05;
    % Definition of the element radius, if the geometry radius is not ...
    % constant in this section. Options: symmetric, mean, upper sum, lower sum
    cnfg.cnfg_rotor.mesh_opt.approx = 'symmetric';

    %% ====================Sensors============================================
    %% Initialization of the sensor section in the struct
    cnfg.cnfg_sensor=[];
    count = 0;

    %% =========================Components====================================
    %% Initialization of the components section in the struct
    count = 0;
    cnfg.cnfg_component = [];

    %% Bearings
    count = count + 1;
    cnfg.cnfg_component(count).name = 'RadBearing1';
    cnfg.cnfg_component(count).type='Bearings';
    cnfg.cnfg_component(count).subtype='SimpleBearing';
    cnfg.cnfg_component(count).position=0e-3; % [m]
    cnfg.cnfg_component(count).stiffness=1e6; % [N/m]
    cnfg.cnfg_component(count).damping = 0; % [Ns/m]
    count = count + 1;
    cnfg.cnfg_component(count).name = 'RadBearing2';
    cnfg.cnfg_component(count).type='Bearings';
    cnfg.cnfg_component(count).subtype='SimpleBearing';
    cnfg.cnfg_component(count).position=500e-3; % [m]
    cnfg.cnfg_component(count).stiffness=1e6; % [N/m]
    cnfg.cnfg_component(count).damping = 0; % [Ns/m]

    %% =========================Loads=========================================
    %% Initialization of the load section in the struct
    cnfg.cnfg_load=[];
    count = 0;

    %% ========================PID-controller==================================
    %% Initialization of the pid-controller section in the struct
    cnfg.cnfg_pid_controller=[];
    count = 0;

    %% ======================Active Magnetic Bearing===========================
    %% Initialization of the active magnetic bearing section in the struct
    cnfg.cnfg_activeMagneticBearing = [];
    count = 0;

Simulation script
+++++++++++++++++

After building the config-script this simulation-script can be copied-and-pasted.
Important in our case is that the called config-script name is consistent to "Config_Tutorial" (line 9).
The simulation script can be saved in the same folder as the corresponding config-script and then be executed.

.. code-block:: matlab 
   :linenos:
  
    %% Simulation
    %% Clean up
    close all
    clear all
    % clc

    %% Import and formating of the figures
    import AMrotorSIM.* % path
    Config_Tutorial % corresponding cnfg-file
    Janitor = AMrotorTools.PlotJanitor(); % Instantiation of class PlotJanitor
    Janitor.setLayout(2,3); %Setting layout of the figures

    %% Assembly of the rotordynamic model
    r=Rotorsystem(cnfg,'Laval-Rotor'); % Instantiation of class Rotorsystem
    r.assemble; % Assembly of the model parts, considering the ...
            % components (sensors,..) from the cnfg-file
    r.rotor.assemble_fem; % assembly of the global (rotor) system ...
                      % matrices: M, D, G, K

    %% Visualization of the assembled rotor model
    r.show; % lists the associated components of the model in teh Matlab ...
        % Command Window
    r.rotor.show_2D(); % Plot of a side view of the rotor elements
    g=Graphs.Visu_Rotorsystem(r); % Instantiation of class Visu_Rotorsystem
    g.show(); % Plot of a 3D-isometry of the rotor with sensors, loads,...
    Janitor.cleanFigures();

The result after the execution of the simulation script is the assembly of all the
components of the rotor system which is also visualized:

.. image:: tutorial/2D-tutorial.png
    :width: 48 %
.. image:: tutorial/3D-tutorial.png
    :width: 48 %

Further analysis methods can be included in the simulation-script after the presented
code block with the assembly. (check :ref:`Examples`)