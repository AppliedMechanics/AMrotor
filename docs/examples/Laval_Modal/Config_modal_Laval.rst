Config_file_LavalModal
++++++++++++++++++++++

This is a working example code for a Configuration file of a simple Laval rotor. 
The focus of the subsequent simulation is a Modal analysis, a Campbell analysis and the determination 
of frequency response functions (FRF's) from the system matrices. The scope of 
the simulation can have effects on the configuration file. All code snippets can 
be copied and pasted into a Matlab script in the given order (recommended) and executed directly.

The first step is to define the rotor/shaft. This definition can be divided into three 
parts: Definition of the material parameters, the geometry of the rotor and the properties of the mesh:

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Modal.m
    :language: matlab
    :linenos:
    :start-after: Rotor
    :end-before: Sensors

Sensors are not absolutely necessary for the desired analysis methods, so 
that no sensors need to be defined. Nevertheless the initialization of the sensor is 
necessary to avoid errors. The initialization consists of the assignment 
of a sensor field in the cnfg-struct and the definition of a control variable "count":

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Modal.m
    :language: matlab
    :linenos:
    :start-after: Sensors
    :end-before: Components

The inclusion of components (in this case bearings) consists of the initialization of a component 
field in the cnfg-struct and a control variable called "count". Each additional component 
(regardless of type) increases the count variable and is defined by a name, the position 
along the z-axis of the rotor, the component type and additional parameters depending on the component:

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Modal.m
    :language: matlab
    :linenos:
    :start-after: Components
    :end-before: Loads

Loads are not absolutely necessary for the desired analysis methods, so 
that no loads need to be defined. Nevertheless the initialization of the load is necessary to avoid errors. 
The initialization consists of the assignment 
of a load field in the cnfg-struct and the definition of a control variable "count":

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Modal.m
    :language: matlab
    :linenos:
    :start-after: Loads
    :end-before: PID-controller

Since no AMB's are intended for this model, no pidControllers are needed. Nevertheless the 
initialization of the pidController is necessary to avoid errors. The initialization consists 
of the assignment of a pidController field in the cnfg-struct and the definition of a control variable "count":

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Modal.m
    :language: matlab
    :linenos:
    :start-after: PID-controller
    :end-before: Active Magnetic Bearing

No active magnetic bearings (AMB's) are intended for this model. Nevertheless the 
initialization of the AMB is necessary to avoid errors. The initialization consists 
of the assignment of a AMB field in the cnfg-struct and the definition of a control variable "count":

.. literalinclude:: /../Examples/Simple_Laval/Config_Sim_Modal.m
    :language: matlab
    :linenos:
    :start-after: Active Magnetic Bearing



