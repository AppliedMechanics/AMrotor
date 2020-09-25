Config_file_MBTR
===================

This is a config code file for an existing rotor that has also been validated experimentally. 
The config file for the Laval rotor (Link...) example was the template and has been adjusted and extended
for the purpose of the magnetic bearing test rig (MBTR) rotor.

The first step is the definition of the rotor/shaft. These definition can be devided
into three parts: definition of the material parameters, the geometry of the rotor and the
properties of the mesh.

Information: For this simulation the whole contour of the rotor is not included in the rotor geometry. Instead,
only the main radius of the rotor and some reinforcements (for transition stiffness purposes) 
are modelled in the rotor geometry. The other rotor steps will later be modelled as discs.

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Rotor
    :end-before: Components

The inclusion of components (in this case bearings and discs) consists of the initialization of a 
component struct-field and a control variable called "count". Every additional component (regardless of the type) increases 
the count variable and is defined by a name, the position along the z-axis of the rotor, 
the component type and additional parameters depending on the component.

Information: The radius and the width of the disc components is only necessary for
visualization purposes. The mass and the moments of inertia are declared separatly and 
origin from external CAD-files.

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Components
    :end-before: Sensors

The inclusion of different types of sensors consists of the initialization of a sensor 
struct-field and a control variable called "count". Every additional sensor (regardless of the type)
increases the count variable and is defined by a name, the position along the z-axis of the rotor
and the sensor type.

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Sensors
    :end-before: Loads

The inclusion of external loads consists of the initialization of a 
load struct-field and a control variable called "count". Every additional load (regardless of the type) increases 
the count variable and is defined by a name, the position along the z-axis of the rotor, 
the load type and additional parameters depending on the type of load.

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Loads
    :end-before: PID-controller

The initialization of the pid-controller struct-field and the corresponding
control variable called "count" comes here.

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: PID-controller
    :end-before: Active Magnetic Bearing

The initialization of the active magnetic bearing struct-field and the corresponding
control variable called "count" comes here.

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Active Magnetic Bearing
