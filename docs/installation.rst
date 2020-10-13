============
Installation
============
:mod:`AMrotor` was tested on Matlab R2020a, but should also work with older Matlab-versions.

Necessary Matlab-toolboxes are:

* Symbolic Math Toolbox

* Curve Fitting Toolbox (for some special applications e.g. Fourierorbitdarstellung)


******
Source
******
The source code of AMrotor can be downloaded from `code`_.

.. _code: https://github.com/AppliedMechanics/AMrotor


**********
First step
**********	

The folder of AMrotor must be located in the Matlab path. This can be checked with 
the InstallChecker.m script in the code folder or the equivalent lines of code:

.. code-block:: matlab 
  
    %% Set Path
   InstDir = fileparts(which(mfilename));
   addpath(InstDir)
   % add abravibe toolbox
   addpath(strcat(InstDir,filesep,'Abravibe_Toolbox'));
   addpath(strcat(InstDir,filesep,'Abravibe_Toolbox',filesep,'abravibe'));
   addpath(strcat(InstDir,filesep,'Abravibe_Toolbox',filesep,'animate'));
   pfad = strcat(fileparts(which(mfilename)),'/pathdef.m');
   savepath pfad

Afterwards :mod:`AMrotor` is ready. The next steps can be found in :ref:`Tutorial` 
and :ref:`Examples`. 


