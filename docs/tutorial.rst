.. _Tutorial:

########
Tutorial
########

******
Basics
******

A brief tutorial of a Laval rotor should show the working principle of AMrotor for building 
a rotordynamic model, followed by examples referring to the available analysis methods. 
More advanced models can be found under :ref:`Examples`.

To run a simulation with AMrotor, two scripts are required:

* Configuration script, contains parameters with information about the rotor and all additional 
  components. These parameters are processed in the subsequent Simulation script. 

* Simulation script, contains the composition of the model and the definition 
  of desired analysis methods that are applied to the model.

.. _Howtobuildamodel?:

*********************
How to build a model?
*********************

The scope of this tutorial is to build a simple Laval rotor model with two simple radial bearings 
and a disk in the middle, which is modeled as part of the rotor (no additional disk component). 

Configuration script
++++++++++++++++++++++++++

The following Config script can be inserted into an empty Matlab script by copy and paste. The script
must then be saved in the AMrotor path. For this tutorial we save the script under the name "Config_Tutorial"
in the Simulation(Simulations)-folder of AMrotor. It may be necessary to add the folder explicitly to the path. The name of 
the Configuration script is important, because it will be used later in the Simulation script. 

For this simple example not all components (only rotor and bearings) are necessary, but it is important 
that all components (sensors, pid controllers, active magnetic bearings, ...) are initialized to avoid errors.

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

By executing the saved script the Config-struct (cnfg) will be created.

Simulation script
+++++++++++++++++++++++++

After setting up the Configuration script, the Simulation script must be created. 
The following part of the Simulation script contains the assembly and visualization 
of the model and can be inserted into an empty Matlab script by copy and paste.
The Simulation script can be saved in the same folder as the corresponding Configuration 
script. For this tutorial it is important that the name of the called Configuration script 
in the Simulation script is equal to "Config_Tutorial" (line 9).

.. code-block:: matlab 
   :linenos:
  
    %% Simulation
    %% Clean up
    close all
    clear all
    % clc

    %% Import and formating of the figures
    import AMrotorSIM.*; % path
    Config_Tutorial; % Corresponding cnfg-file
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
    Janitor.cleanFigures(); % Formatting of the figures

After executing the Simulation script the following figures of the rotor model appear:

.. image:: tutorial/2D-tutorial.png
    :width: 48 %
.. image:: tutorial/3D-tutorial.png
    :width: 48 %

More advanced examples including subsequent analysis methods can be found under :ref:`Examples`.


************************************
How to make a **Campbell** analysis?
************************************

.. note::  The following analysis method does not work with the previous example :ref:`Howtobuildamodel?`, 
           because in that minimal example some components (e.g. sensors, loads, ...) are missing. 
           To merge a model with an analysis method see :ref:`Examples`. 
           
           In general, the analysis methods are defined in the Simulation script 
           and can be divided into two sub-blocks:

           * Calculation code block

           * Visualization code block

To calculate and visualize a Campbell analysis, the following code is required 
in the Simulation script after the lines of code for assembling the model.

.. code-block:: matlab 
   :linenos:

    %% Calculation
    cmp = Experiments.Campbell(r); % Instantiation of class Campbell for calculation
    cmp.set_up(0:2e2:2e3,20); % Set up (omega range in 1/min, #modes)
    cmp.calculate(); % Calculation

    %% Visualization
    cmpDiagramm = Graphs.Campbell(cmp); % Instantiation of class Campbell for visualization
				% of the obtained results
    cmpDiagramm.print_damping_zero_crossing(); % Prints in the Command Window
    cmpDiagramm.print_critical_speeds() % Prints in the Command Window
    cmpDiagramm.set_plots('all'); % Plots the visualization (Figures)
    Janitor.cleanFigures(); % Formatting of the figures


*********************************
How to make a **Modal** analysis?
*********************************

.. note::  The following analysis method does not work with the previous example :ref:`Howtobuildamodel?`, 
           because in that minimal example some components (e.g. sensors, loads, ...) are missing. 
           To merge a model with an analysis method see :ref:`Examples`. 
           
           In general, the analysis methods are defined in the Simulation script 
           and can be divided into two sub-blocks:

           * Calculation code block

           * Visualization code block

To calculate and visualize a Modal analysis, the following code is required 
in the Simulation script after the lines of code for assembling the model.

.. code-block:: matlab 
   :linenos:

    %% Calculation
    m=Experiments.Modalanalyse(r); % Instantiation of class Modalanalyse for calculation
    m.calculate_rotorsystem(16,0); % Calculation (#modes, rotation speed)

    %% Visualization 
    esf= Graphs.Eigenschwingformen(m); % Instantiation of class Eigenschwingformen for 
				% visualization of the obtained results
    esf.print_frequencies(); % Prints EF in the Command Window
    esf.plot_displacements(); % Plots the 2D mode shapes
    % esf.set_plots('half','Overlay'); % Plots of the odd-numbered eigenmodes .. 
                                % in overlay with the original rotor
    esf.set_plots(10,'Overlay','Skip',5,'tangentialPoints',30,'scale',3); % ...
				% Plot of the 3D mode shapes
    Janitor.cleanFigures(); % Formatting of the figures

.. _Stationary:

**********************************************
How to make a **Stationary** time integration?
**********************************************

.. note::  The following analysis method does not work with the previous example :ref:`Howtobuildamodel?`, 
           because in that minimal example some components (e.g. sensors, loads, ...) are missing. 
           To merge a model with an analysis method see :ref:`Examples`. 
           
           In general, the analysis methods are defined in the Simulation script 
           and can be divided into two sub-blocks:

           * Calculation code block

           * Visualization code block

To calculate and visualize a Stationary time integration, the following code is required 
in the Simulation script after the lines of code for assembling the model.
In a Stationary time integration, the angular velocity of the rotor is kept at a constant value.

.. code-block:: matlab 
   :linenos:

    %% Calculation
    St_Lsg = Experiments.Stationaere_Lsg(r,[500],[0:0.001:0.025]); % In...
        %stantiation of class Stationaere_Lsg
    St_Lsg.compute_ode15s_ss; % ode15s - method
    %St_Lsg.compute_newmark; % newmark - method

    %% Visualization
    t = Graphs.TimeSignal(r, St_Lsg); % Instantiation of class TimeSignal
    o = Graphs.Orbitdarstellung(r, St_Lsg); % Instantiation of class ...
                                     % Orbitdarstellung
    f = Graphs.Fourierdarstellung(r, St_Lsg); % Instantiation of class ...
                                       % Fourierdarstellung
    fo = Graphs.Fourierorbitdarstellung(r, St_Lsg); % Instantiation of class ..
                                             % Fourierorbitdarstellung
    w = Graphs.Waterfalldiagramm(r, St_Lsg); % Instantiation of class ...
                                      % Waterfalldiagramm
    w2 = Graphs.WaterfalldiagrammTwoSided(r, St_Lsg); % Instantiation of ...
                                       % class WaterfalldiagrammTwoSided
    for sensor = r.sensors % Loop over all sensors for plotting the sensor results
          t.plot(sensor); % Time signal
          o.plot(sensor); % Orbits
          f.plot(sensor); % Fourier
          fo.plot(sensor,1); % Fourierorbit 1st order
          fo.plot(sensor,2); % Fourierorbit 2nd order
          w.plot(sensor); % Waterfall
          w2.plot(sensor); % Waterfall 2sided
         Janitor.cleanFigures(); % Formatting of the figures
    end

.. _Runup:

******************************************
How to make a **Run-up** time integration?
******************************************

.. note::  The following analysis method does not work with the previous example :ref:`Howtobuildamodel?`, 
           because in that minimal example some components (e.g. sensors, loads, ...) are missing. 
           To merge a model with an analysis method see :ref:`Examples`. 
           
           In general, the analysis methods are defined in the Simulation script 
           and can be divided into two sub-blocks:

           * Calculation code block

           * Visualization code block

To calculate and visualize a Run-up time integration, the following code is required 
in the Simulation script after the lines of code for assembling the model.
In a Run-up time integration, the angular velocity of the rotor is linearly 
variable (up or down) over a defined range.


.. code-block:: matlab 
   :linenos:

    %% Calculation
    Runup = Experiments.Hochlaufanalyse(r,[0,1e3],(0:0.001:0.2)); % In...
        %stantiation of class Hochlaufanalyse (Runup)
    Runup.compute_ode15s_ss % ode15s - method

    %% Visualization
    t = Graphs.TimeSignal(r, Runup); % Instantiation of class TimeSignal
    o = Graphs.Orbitdarstellung(r, Runup); % Instantiation of class ...
                                     % Orbitdarstellung
    f = Graphs.Fourierdarstellung(r, Runup); % Instantiation of class ...
                                       % Fourierdarstellung
    fo = Graphs.Fourierorbitdarstellung(r, Runup); % Instantiation of class ..
                                             % Fourierorbitdarstellung
    w = Graphs.Waterfalldiagramm(r, Runup); % Instantiation of class ...
                                      % Waterfalldiagramm
    w2 = Graphs.WaterfalldiagrammTwoSided(r, Runup); % Instantiation of ...
                                       % class WaterfalldiagrammTwoSided
    for sensor = r.sensors % Loop over all sensors for plotting the sensor results
          t.plot(sensor); % Time signal
          o.plot(sensor); % Orbits
          f.plot(sensor); % Fourier
          fo.plot(sensor,1); % Fourierorbit 1st order
          fo.plot(sensor,2); % Fourierorbit 2nd order
          w.plot(sensor); % Waterfall
          w2.plot(sensor); % Waterfall 2sided
         Janitor.cleanFigures(); % Formatting of the figures
    end

*******************************************
How to get **FRF's** from the rotor system?
*******************************************

.. note::  The following analysis method does not work with the previous example :ref:`Howtobuildamodel?`, 
           because in that minimal example some components (e.g. sensors, loads, ...) are missing. 
           To merge a model with an analysis method see :ref:`Examples`. 
           
           In general, the analysis methods are defined in the Simulation script 
           and can be divided into two sub-blocks:

           * Calculation code block

           * Visualization code block

To calculate and visualize frequency response functions (FRF's), the following code is required 
in the Simulation script after the lines of code for assembling the model.

.. code-block:: matlab 
   :linenos:

    %% Calculation
    frf=Experiments.Frequenzgangfunktion(r,'FRF'); % Instantiation of ... 
                        % class Frequenzgangfunktion
    type = 'd'; % FRF type: displ. 'd', veloc. 'v', accel. 'a'
    inPos = [0,100,200]*1e-3; % Input positions on the rotor axis
    outPos = 100e-3; % Output positions along the rotor axis
    f = 1:2:100; % Frequency resolution of the FRF
    rpm = 0; % Rotational speed
    [f,H]=frf.calculate(f,inPos,outPos,type,rpm,{'u_x','u_y','psi_x'}, {'u_x','psi_x'}); % ...
	              % Calculation of the FRF's from the three input ... 
                      % directions {'u_x','u_y','psi_x'} to the two ... 
                      % output directions {'u_x','psi_x'} at the ...
                      % corresponding positions
    [deltaIn,deltaOut]=frf.print_distance_delta; % Plot of the gap between ...
                      % the desired positions along the rotor axis and ...
                      % the closest node position in the Command Window.
    %% Visualization
    visufrf = Graphs.Frequenzgangfunktion(frf); % Instantiation of ... 
                        % class Frequenzgangfunktion for figures
    visufrf.set_plots('amplitude','db') % Amplitude plot of all FRF's
    visufrf.set_plots('phase','db') % Phase plot of all FRF's
    visufrf.set_plots('bode','log','deg') % Bode plot of all FRF's
    visufrf.set_plots('nyquist') % Nyquist plot of all FRF's
    Janitor.cleanFigures(); % Formatting of the figures

***********************************************************
How to get **FRF's from time signals** of the rotor system?
***********************************************************

.. note::  The following analysis method does not work with the previous example :ref:`Howtobuildamodel?`, 
           because in that minimal example some components (e.g. sensors, loads, ...) are missing. 
           To merge a model with an analysis method see :ref:`Examples`. 
           
           In general, the analysis methods are defined in the Simulation script 
           and can be divided into two sub-blocks:

           * Calculation code block

           * Visualization code block

To calculate and visualize frequency response functions (FRF's) from time signals, the following code is required 
in the Simulation script after the lines of code for assembling the model.
FRF's from time signals are based on results of previously performed time integrations (see Stationary: :ref:`Stationary` or Runup: :ref:`Runup`). 
It is essential that the desired rotation speed (rpm) for the FRF's is included in the results from the time integrations 
performed previously.

.. code-block:: matlab 
   :linenos:

    %% Calculation
    St_Lsg; % Runup; %Results from time integration are necessary (Stationary or Runup)
    frf = Experiments.FrequenzgangfunktionTime(St_Lsg); % Instantiation ...
                                        % of class FrequenzgangfunktionTime
    frf.calculate(r.sensors(2),r.sensors(1),[1100],'u_x','u_x',4,'boxcar'); % Calculation

    %% Visualization
    visufrf = Graphs.Frequenzgangfunktion(frf); % Instantiation of class FrequenzgangfunktionTime
    visufrf.set_plots('bode','log','deg','coh'); % Plot of the FRF's
    Janitor.cleanFigures(); % Formatting of the figures