Simulation file for the MBTR
++++++++++++++++++++++++++++++++

This is a Simulation file for an investigation (approximation with spring-damper elements) of a real AMB test rig (MBTR). Of interest is
the behaviour of the rotor in steady state (Modal analysis) and in motion (Campbell analysis) as well
as the Stationary time behaviour (at 500 rpm) under the influence of an external excitation.

Closing of all previous figures and cleaning of the workspace:

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Simulation.m
    :language: matlab
    :linenos:
    :Start-after: Clean up
    :End-before: Import

Import of the file path and the corresponding Configuration file:

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Simulation.m
    :language: matlab
    :linenos:
    :Start-after: Import
    :End-before: Compute Rotor

Assembly and visualization of the model:

.. note:: The assembly of the model 
          is the most important part of the Simulation file and must be done before the analyses.

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Simulation.m
    :language: matlab
    :linenos:
    :Start-after: Compute Rotor
    :End-before: Running system analyses

2D side view of the rotor (left) and 3D isometry (right):

.. note:: The diameter steps in the rotor geometry (in the 2D side view)
          represent the reinforcements (check :ref:`ConfMBTR`) of the main rotor 
          and not the disc component as seen in the 3D isometry.

.. image:: Rotor_geometry_MBTR.png
    :width: 48 %
.. image:: Rotor_geometry_3D_MBTR.png
    :width: 48 %

Execution of the intended system analysis methods (Modal analysis and Campbell analysis) with visualization:

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Simulation.m
    :language: matlab
    :linenos:
    :Start-after: Running system analyses
    :End-before: Running Time Simulation

Representation of the 10th eigenmode (upscaled and with orbits) 
(left) and the Campbell diagram (right) of the rotor:

.. image:: ESF_plot_MBTR.png
    :width: 48 %
.. image:: Campbell_MBTR.png
    :width: 48 %

Execution of time integration (at 500 rpm for 1 second) with unbalance 
and external excitation (Forward-whirl-sweep-force) with visualization:

.. literalinclude:: /../Simulationen/MLPS_AMB_Modalanalyse/Simulation.m
    :language: matlab
    :linenos:
    :Start-after: Running Time Simulation

Time signal (x-direction) of the eddy-current sensor on the left side AMB 
(left) and the corresponding Fourier analysis (right):

.. image:: EddyL1_time_MBTR.png
    :width: 48 %
.. image:: EddyL1_fourier_MBTR.png
    :width: 48 %