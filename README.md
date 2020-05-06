## Notwendige Software

- getestet mit *Matlab R2020a*, sollte aber auch mit anderen *Matlab*-Versionen kompatibel sein
- notwendige *Matlab*-Toolboxen
  - Symbolic Math Toolbox
  - Curve Fitting Toolbox (nur für Fourierorbitdarstellung der Sensorsignale bei Zeitintegration)

## Dokumentation des Codes

Startpunkt ist Eingabe des Befehls `doc AMrotor` bzw. `doc AMrotorSIM.Rotorsystem`. Von dort aus kann die Struktur des Codes und wichtige Klassen durch Nutzung der Links nachvollzogen werden.

## Ordnerstruktur

- *+AMrotorMONI* enthält Funktionen für das Monitoring von Rotorsystemen, diese Teile werden aktuell nicht im Simulationsprogramm genutzt
- *+AMrotorSIM* enthält den eigentlichen Simualtionscode. Das Rotorsimualtionsprogramm ist Objekt-orientiert aufgebaut. 
- *+AMrotorTools* enthält Tools, um beispielsweise plots übersichichtlich darzustellen oder einen Timer
- *Abravibe_Toolbox* enthält die Abravibe-Toolbox von Anders Brandt, die unter der GNU GPL Licence steht (siehe die Lizenz-Datei in diesem Ordner), sowie eine Funktionalität zur Animation von Eigenmoden; nützliche Funktionen zur (u.a. experimentellen) Modalanalyse
- *doc* enthält ein sehr kurzes *Getting Started*
- *Examples* enthält Beispiele zur Benutzung des Simulationscodes und kann als Ausgangspunkt für eigene Simulationen genutzt werden, soll die Funktionalität des Codes demonstrieren
- *Simulationen* enthält konkrete Simulationen von Prüfständen und anderen Anwendungsfällen. Dieser Ordner soll für eigene Anwendungsfälle von AMrotor genutzt werden
- *Tools* enthält nützliche Werkzeuge
- *InstallChecker.m* wird zur Einrichtung des Programms in *Matlab* ausgeführt. Es legt den Pfad fest.

## interessante Links
- zur Dokumentation https://de.mathworks.com/matlabcentral/answers/100534-is-it-possible-to-include-package-and-class-directories-in-contents-report-created-programmatically