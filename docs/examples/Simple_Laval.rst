Simple laval rotor example
==========================

This is an example code for a simple laval rotor simulation without an active magnetic bearing. The code snippets can be copied and 
pasted entirely in a Matlab script or can be found in the AMrotor folder under "examples".

The config files for the modal analysis and the time integration have the same content. Nevertheless,
the modal analysis config file has no force and sensors defined, since they are not necessary
for the analysis.

The simulation files of the modal analysis and the time integration call for different functions 
because the focus of these analyses are different. 

.. toctree::
   :maxdepth: 2

   Laval_Modal
   Laval_Time
