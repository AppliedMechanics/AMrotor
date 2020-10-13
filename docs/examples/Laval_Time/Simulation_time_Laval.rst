Simulation_file_example
+++++++++++++++++++++++++++

This is an example code for a simulation file of a simple Laval rotor for time integration.
All the code snippets can be copied and pasted together in a Matlab script and executed 
directly. The hidden (commented out) code parts should show further possibilities.
The presented functions often contain options that cannot all be shown in the examples. 
More options can be found in the detailed documentation or in the source code.

Closing all former figures and cleaning the workspace.

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Clean up
    :End-before: Import

Import of the file path and  of the corresponding cnfg-file.

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Import
    :End-before: Compute Rotor

Assembly and visualization of the model

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Compute Rotor
    :End-before: Running Time Simulation

2D side view of the rotor (left) and 3D-isometry (right)

.. image:: Rotor_geometry.png
    :width: 48 %
.. image:: Rotor_geometry_3D.png
    :width: 48 %

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Running Time Simulation
    :End-before: Plot results

Writing the results into an external file and visualizing all the results.

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Plot results


