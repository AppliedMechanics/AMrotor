## Notwendige Software

- getestet mit *Matlab R2018b*, sollte aber auch mit anderen *Matlab*-Versionen kompatibel sein
- notwendige *Matlab*-Toolboxen
  - Symbolic Math Toolbox
  - Image Processing Toolbox
  - Curve Fitting Toolbox (nur für Fourierorbitdarstellung der Sensorsignale bei Zeitintegration)

## Ordnerstruktur

- *+AMrotorMONI* enthält Funktionen für das Monitoring von Rotorsystemen, diese teile werden aktuell nicht im Simulationsprogramm genutzt
- *+AMrotorSIM* enthält den eigentlichen Simualtionscode. Das Rotorsimualtionsprogramm ist Objekt-orientiert aufgebaut. 
- *+AMrotorTools* enthält Tools, um plots ü+bersichichtlich darzustellen oder einen Timer
- *Abravibe_Toolbox* enthält die Abravibe-Toolbox von Anders Brandt, die unter GNU GPL Licence, siehe die Lizenz-Datei in diesem Ordner, sowie eine Funktionalität zur Animation von Eigenmoden; nützliche Funktionen zur (u.a. experimentellen) Modalanalyse
- *doc* enthält ein sehr kurzes *Getting Started*
- *Examples* enthält Beispiele zur Benutzung des Simulationscodes und kann als Ausgangspunkt für eigene Simulationen genutzt werden, soll die Funktionalität des Codes demonstrieren
- *Simulationen* enthält konkrete Simulationen von Prüfständen und anderen Anwendungsfällen. Dieser Ordner soll für eigene Anwendungsfälle von AMrotor genutzt werden
- *Tools* enthält nützliche Werkzeuge
- *InstallChecker.m* wird zur Einrichtung des Programms in *Matlab* ausgeführt. Es legt den Pfad fest.


## ToDos

ToDo: **Christian Looschen** (christian_looschen@hotmail.com)

- Rotorgeometrie Methode: get_diameter(at position z = ...)
- Visualisierung Lagerringe
- Drehung der Visualisierung
- Farbe der Lagerringe je nach Lagertyp ?ndern - Magnetlager (typ3) orange, Gleitlager (typ1)=blau
- Klasse Kraftsensor generieren
- Geschwindigkeitssensor 
- Beschleunigungssensor
- TimeSignal - OrbitSignal Darstellung vereinheitlichen

-----------------------------------------------------------------------------

- Fourierdarstellung der Signale
- Stromsensor+Kraftsensor Magnetlager erstellen
- 
- Anregungskräfte (Chirp/Step/Sine)
- Ausgabe der "Messwerte"

-----------------------



- Torsions-DGL einpflegen/erstellen
  - Trägheit je Element assemblieren
  - Steifigkeitsmatrix assemblieren
  - Klasse Motor einf?hren --> konstante Drehzahl / konstantes Drehmoment
  - State-Space-formulierung & Zeitintegration
  - Berechnung Torsionseigenmoden --> Darstellung



- Dokumentation

ToDo: **Johannes Maierhofer**

- Transferfunction Auswertung
- Transferfunction Einkopplung