Config_file_LavalTime
+++++++++++++++++++++

This is a working example code for a Configuration file of a simple Laval rotor. 
The focus of the subsequent simulation is a Stationary time integration, a Run-up time integration 
and the determinationof frequency response functions (FRF's) from the sensor time signals. The scope of 
the simulation can have effects on the configuration file. All code snippets can 
be copied and pasted into a Matlab script in the given order (recommended) and executed directly.

The first step is to define the rotor/shaft. This definition can be divided into three 
parts: Definition of the material parameters, the geometry of the rotor and the properties of the mesh.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Rotor
    :end-before: Sensors

The inclusion of sensors consists of the initialization of a sensor
field in the cnfg-struct and a control variable called "count". Each additional sensor 
(regardless of type) increases the count variable and is defined by a name, the position 
along the z-axis of the rotor, the sensor type and additional parameters depending on the sensor.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Sensors
    :end-before: Components

The inclusion of components (in this case bearings) consists of the initialization of a component 
field in the cnfg-struct and a control variable called "count". Each additional component 
(regardless of type) increases the count variable and is defined by a name, the position 
along the z-axis of the rotor, the component type and additional parameters depending on the component.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Components
    :end-before: Loads

The inclusion of loads consists of the initialization of a load 
field in the cnfg-struct and a control variable called "count". Each additional load
(regardless of type) increases the count variable and is defined by a name, the position 
along the z-axis of the rotor, the load type and additional parameters depending on the load.

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Loads
    :end-before: PID-controller

Since no AMB's are intended for this model, no pidControllers are needed. Nevertheless the 
initialization of the pidController is necessary to avoid errors. The initialization consists 
of the assignment of a pidController field in the cnfg-struct and the definition of a control variable "count".

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: PID-controller
    :end-before: Active Magnetic Bearing

No active magnetic bearings (AMB's) are intended for this model. Nevertheless the 
initialization of the AMB is necessary to avoid errors. The initialization consists 
of the assignment of a AMB field in the cnfg-struct and the definition of a control variable "count".

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Time.m
    :language: matlab
    :linenos:
    :start-after: Active Magnetic Bearing



