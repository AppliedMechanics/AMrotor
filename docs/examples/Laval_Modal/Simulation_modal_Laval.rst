Simulation_file_LavalModal
++++++++++++++++++++++++++

This is an example code for a working simulation file of a simple Laval rotor for system analyses (Campbell, Modal, FRF analyses).
All code snippets can be copied and pasted into a Matlab script in the given order (recommended) and executed directly.

Closing of all previous figures and cleaning of the workspace:

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Modal.m
    :language: matlab
    :linenos:
    :Start-after: Clean up
    :End-before: Import

Import the file path and the corresponding Configuration file:

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Modal.m
    :language: matlab
    :linenos:
    :Start-after: Import
    :End-before: Compute Rotor

Assembly and visualization of the model. The assembly of the model 
is the most important part of the Simulation file and must be done before the analyses:

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Modal.m
    :language: matlab
    :linenos:
    :Start-after: Compute Rotor
    :End-before: Running system analyses

2D side view of the rotor (left) and 3D isometry (right):

.. image:: Rotor_geometry.png
    :width: 48 %
.. image:: Rotor_geometry_3D.png
    :width: 48 %

Execution of the intended analysis methods (FRF, Campbell, Modal analysis) and their visualization:

.. literalinclude:: /../Examples/Simple_Laval/Simulation_Modal.m
    :language: matlab
    :linenos:
    :Start-after: Running system analyses

The results of the analyses performed include the following figures:

.. image:: Laval_Modal/FRF.png
    :width: 48 %
.. image:: Laval_Modal/Modal.png
    :width: 48 %

.. image:: Laval_Modal/Modal3D.png
    :width: 48 %
.. image:: Laval_Modal/Campbell.png
    :width: 48 %



