.. image:: ../docs/examples/Rotor_geometry_3D_MBTR.png
   :align: center

AMrotor
-------

AMrotor is an object-oriented matlab-based toolbox for rotor dynamics. The toolbox is built around the main component "rotor", 
which can be modeled with Timoshenko beam elements. Furthermore, various components are available, from simple static elements 
such as "disc" (additional mass and moment of inertia) or "bearing" (spring-damper elements) to active components such as 
"active magnetic bearings (AMB)" with "pidController". 
After creating the model and eventual application of external loads (or forces), several common analysis methods (FFT, FRF, Orbits, ...) can be performed.

This makes AMrotor an easy to use, flexible and powerful toolbox for fast tests as well as for sophisticated rotor models. 

Documentation of the code
-------------------------

The documentation, necessary software and some useful examples can be found on ReadTheDocs under this `link`_.

Citation
--------

Paper with reference to the toolbox and more specific information about the mathematical background are:

.. [1] AMrotor – A MATLAB Toolbox for the Simulation of Rotating Machinery, Johannes Maierhofer, M.Kreutz, T.Mulser, T. Thümmel, D. Rixen. DOI: `10.1201/9781003132639 <https://doi.org/10.1201/9781003132639>`_ 
.. [2] Comparison of different time integration schemes and application to a rotor system with magnetic bearings in Matlab, Michael Kreutz, J. Maierhofer, T. Thümmel, D. Rixen. DOI: `10.1201/9781003132639 <https://doi.org/10.1201/9781003132639>`_

License
-------

AMrotor is licensed under GPL-3.0-or-later.

.. _link: https://amrotor.readthedocs.io/en/latest/index.html

.. <!--## Ordnerstruktur

.. - *+AMrotorMONI* enthält Funktionen für das Monitoring von Rotorsystemen, diese Teile werden aktuell nicht im Simulationsprogramm genutzt
.. - *+AMrotorSIM* enthält den eigentlichen Simualtionscode. Das Rotorsimualtionsprogramm ist Objekt-orientiert aufgebaut. 
.. - *+AMrotorTools* enthält Tools, um beispielsweise plots übersichichtlich darzustellen oder einen Timer
.. - *Abravibe_Toolbox* enthält die Abravibe-Toolbox von Anders Brandt, die unter der GNU GPL Licence steht (siehe die Lizenz-Datei in diesem Ordner), sowie eine Funktionalität zur Animation von Eigenmoden; nützliche Funktionen zur (u.a. experimentellen) Modalanalyse
.. - *doc* enthält ein sehr kurzes *Getting Started*
.. - *Examples* enthält Beispiele zur Benutzung des Simulationscodes und kann als Ausgangspunkt für eigene Simulationen genutzt werden, soll die Funktionalität des Codes demonstrieren
.. - *Simulationen* enthält konkrete Simulationen von Prüfständen und anderen Anwendungsfällen. Dieser Ordner soll für eigene Anwendungsfälle von AMrotor genutzt werden
.. - *Tools* enthält nützliche Werkzeuge
.. - *InstallChecker.m* wird zur Einrichtung des Programms in *Matlab* ausgeführt. Es legt den Pfad fest.

.. ## interessante Links
.. - zur Dokumentation https://de.mathworks.com/matlabcentral/answers/100534-is-it-possible-to-include-package-and-class-directories-in-contents-report-created-programmatically

..
  ## Notwendige Software

  - getestet mit *Matlab R2020a*, sollte aber auch mit anderen *Matlab*-Versionen kompatibel sein
  - notwendige *Matlab*-Toolboxen
    - Symbolic Math Toolbox
    - Curve Fitting Toolbox (nur für Fourierorbitdarstellung der Sensorsignale bei Zeitintegration)-->
