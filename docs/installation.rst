============
Installation
============
:mod:`AMrotor` was tested on Matlab R2020a, but should also work with older Matlab-versions.

Necessary Matlab-toolboxes are:

* Symbolic Math Toolbox

* Curve Fitting Toolbox (for some special applications e.g. Fourierorbitdarstellung)


**********
First step
**********	

The folder of AMrotor needs to be in the Matlab-path. 
This can be checked by the script InstallChecker.m in the code folder or:

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

Afterwards the necessary scripts can be executed (see :ref:`Examples` and :ref:`Tutorial`). 

******
Source
******
The source code of AMrotor can be downloaded from `code`_.

.. _code: https://github.com/AppliedMechanics/AMrotor

