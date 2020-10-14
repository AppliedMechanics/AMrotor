Simulation file for the MBTR with AMB
++++++++++++++++++++++++++++++++++++++++++++++++++++++++

This is a Simulation file for an investigation of a real AMB test rig (MBTR). Of interest is
the Run-up time behaviour (from 0 to 1000 rpm) under the influence of external random excitations
at the AMB's.

Closing of all previous figures and cleaning of the workspace:

.. literalinclude:: /../Simulationen/MLPS_pid/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Clean up
    :End-before: Import

Import of the file path and the corresponding Configuration file:

.. literalinclude:: /../Simulationen/MLPS_pid/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Import
    :End-before: Compute Rotor

Assembly and visualization of the model:

.. note:: The assembly of the model 
          is the most important part of the Simulation file and must be done before the analyses.

.. literalinclude:: /../Simulationen/MLPS_pid/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Compute Rotor
    :End-before: Running Time Simulation

2D side view of the rotor (left) and 3D isometry (right):

.. note:: The diameter steps in the rotor geometry (in the 2D side view)
          represent the reinforcements (check :ref:`ConfMBTR`) of the main rotor 
          and not the disc component as seen in the 3D isometry.

.. image:: Rotor_geometry_MBTR.png
    :width: 48 %
.. image:: Rotor_geometry_3D_MBTRwAMB.png
    :width: 48 %

Execution of the Run-up time integration (from 0 to 1000 rpm for 0.2 seconds) with
external excitation (random on both AMB's only in x-direction) with visualization:

.. literalinclude:: /../Simulationen/MLPS_pid/Simulation_Time.m
    :language: matlab
    :linenos:
    :Start-after: Running Time Simulation

Time signal (x-direction) of the eddy-current sensor on the left AMB (left)
and the corresponding Fourier analysis (right):

.. image:: EddyL1_time_MBTRwAMB.png
    :width: 48 %
.. image:: EddyL1_fourier_MBTRwAMB.png
    :width: 48 %