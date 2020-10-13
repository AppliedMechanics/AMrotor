Config_file_example
+++++++++++++++++++++

This is an example code for a config file of a simple Laval rotor. All the code snippets can
be copied and pasted together in a Matlab script and executed directly. The hidden (commented out) 
code parts should show former possibilities.

The first step is the definition of the rotor/shaft. These definition can be devided
into three parts: definition of the material parameters, the geometry of the rotor and the
properties of the mesh.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Rotor
    :end-before: Sensors

The inclusion of different types of sensors consists of the initialization of a sensor 
struct-field and a control variable called "count". Every additional sensor (regardless of the type)
increases 
the count variable and is defined by a name, the position along the z-axis of the rotor
and the sensor type.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Sensors
    :end-before: Components

The inclusion of components (in this case bearings) consists of the initialization of a 
component struct-field and a control variable called "count". Every additional component (regardless of the type) increases 
the count variable and is defined by a name, the position along the z-axis of the rotor, 
the component type and additional parameters depending on the component.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Components
    :end-before: Loads

The inclusion of external loads consists of the initialization of a 
load struct-field and a control variable called "count". Every additional load (regardless of the type) increases 
the count variable and is defined by a name, the position along the z-axis of the rotor, 
the load type and additional parameters depending on the type of load.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Loads
    :end-before: PID-controller

The initialization of the pid-controller struct-field and the corresponding
control variable called "count" comes here.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: PID-controller
    :end-before: Active Magnetic Bearing

The initialization of the active magnetic bearing struct-field and the corresponding
control variable called "count" comes here.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Active Magnetic Bearing



