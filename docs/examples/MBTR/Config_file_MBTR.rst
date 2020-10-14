.. _ConfMBTR:

Configuration file for the MBTR
++++++++++++++++++++++++++++++++

This is a Configuration file for a rotor system based on the magnetic bearing test rig (MBTR). 
The example of the Laval rotor (:ref:`Laval`) serves as a template and has been adapted 
and extended for the purposes of the MBTR rotor.

The first step is to define the rotor/shaft. This definition can be divided into three 
parts: Definition of the material parameters, the geometry of the rotor and the properties of the mesh:

.. note:: In this simulation, not the entire contour of the rotor is included in the rotor geometry. 
          Instead, only the main radius of the rotor and some reinforcements (for transition stiffness 
          purposes) are modeled in the rotor geometry. The other diameter steps of the rotor are later 
          modeled as discs.

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Rotor
    :end-before: Components

The inclusion of components (in this case bearings and discs) consists of the initialization of a component 
field in the cnfg-struct and a control variable called "count". Each additional component 
(regardless of type) increases the count variable and is defined by a name, the position 
along the z-axis of the rotor, the component type and additional parameters depending on the component:

.. note:: The radius and the width of the disc components is only required for
          visualization purposes. The mass and the mass moments of inertia are declared separatly and 
          origin from external CAD-files.

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Components
    :end-before: Sensors

The inclusion of sensors consists of the initialization of a sensor
field in the cnfg-struct and a control variable called "count". Each additional sensor 
(regardless of type) increases the count variable and is defined by a name, the position 
along the z-axis of the rotor, the sensor type and additional parameters depending on the sensor:

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Sensors
    :end-before: Loads

The inclusion of loads consists of the initialization of a load 
field in the cnfg-struct and a control variable called "count". Each additional load
(regardless of type) increases the count variable and is defined by a name, the position 
along the z-axis of the rotor, the load type and additional parameters depending on the load:

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Loads
    :end-before: PID-controller

Since no AMB's are intended for this model, no pidControllers are needed. Nevertheless the 
initialization of the pidController is necessary to avoid errors. The initialization consists 
of the assignment of a pidController field in the cnfg-struct and the definition of a control variable "count":

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: PID-controller
    :end-before: Active Magnetic Bearing

No active magnetic bearings (AMB's) are intended for this model. Nevertheless the 
initialization of the AMB is necessary to avoid errors. The initialization consists 
of the assignment of a AMB field in the cnfg-struct and the definition of a control variable "count":

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Config_Sim_eingebaut.m
    :language: matlab
    :linenos:
    :start-after: Active Magnetic Bearing
