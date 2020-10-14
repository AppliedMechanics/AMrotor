Simulation_file_LavalTime
+++++++++++++++++++++++++++

This is an example code for a working Simulation file of a simple Laval rotor for 
time integration (Stationary and Run-up).
All code snippets can be copied and pasted into a Matlab script 
in the given order (recommended) and executed directly.

Closing of all previous figures and cleaning of the workspace:

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Clean up
    :End-before: Import

Import of the file path and the corresponding Configuration file:

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Import
    :End-before: Compute Rotor

Assembly and visualization of the model:

.. note:: The assembly of the model 
          is the most important part of the Simulation file and must be done before the analyses.

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Compute Rotor
    :End-before: Running Time Simulation

2D side view of the rotor (left) and 3D isometry (right):

.. image:: Rotor_geometry.png
    :width: 48 %
.. image:: Rotor_geometry_3D.png
    :width: 48 %

Execution of the intended analysis methods (Stationary time integration, 
Run-up time integration, FRF from time signals). Some are commented out:

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Running Time Simulation
    :End-before: Plot results

Export and visualization of the results:

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Plot results

The results of the analyses performed include the following figures:

.. image:: Laval_Time/FRF.png
    :width: 48 %
.. image:: Laval_Time/Coherence.png
    :width: 48 %

.. image:: Laval_Time/ForceOrbit.png
    :width: 48 %
.. image:: Laval_Time/Waterfall.png
    :width: 48 %

