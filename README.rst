.. image:: doc/examples/Rotor_geometry_3D_MBTR.png
   :align: center

AMrotor
-------

AMrotor is an object-oriented matlab-based toolbox for rotor dynamics. The toolbox provides the main component
"rotor", which can be modelled with Timoshenko beam elements. In addition to this, different components, from simple static elements such as
"disc" (additional massand moment of inertia) or "bearing" (spring-damper elements) to active components such as "active magnetic bearings (AMB)" 
with "controllers", are available. After building the model, various common analysis methods (FFT, FRF, Orbits, ...) are available.

Thus AMrotor is an easy to use, flexible and mighty toolbox for quick tests as well as sophisticated rotor modells. 

Documentation of the code
-------------------------

The documentation, necessary software and some useful examples can be found on ReadTheDocs under this `link`_.

Citation
--------

Paper with reference to the toolbox are:

.. [1] AMrotor – A MATLAB Toolbox for the Simulation of Rotating Machinery, Johannes Maierhofer, M.Kreutz, T.Mulser, T. Thümmel, D. Rixen. 
.. [2] Comparison of different time integration schemes and application to a rotor system with magnetic bearings in Matlab, Michael Kreutz, J. Maierhofer, T. Thümmel, D. Rixen

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