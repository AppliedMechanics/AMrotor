# Getting Started

## Rotorsimualtionsprogramm AMrotor

<https://gitlab.lrz.de/jmaierhofer/AMrotor> - Zugangsberechtigung bei Johannes Maierhofer erfragen

Zur komfortablen Verfolgung des Projekts und zur Mitarbeit über eigene Commits eignet sich das Programm SourceTree [sourcetreeapp.com](https://www.sourcetreeapp.com) , eine Verfolgung über das Browser-Interface von [gitlab.lrz.de](https://gitlab.lrz.de/) ist auch möglich, ebenso wie eine Bedienung über die Konsole.

Setzen des Pfads der Simulation in *Matlab* mit dem Skript *InstallChecker.m*

Beispiele zur Demonstration der Funktionalität des Simulationsprogramms in Ordner *AMrotor\\Matlab\_Code\\Examples\\Simple\_Laval*

Getrennte Beispiele für Modalanalyse und für Zeitintegration: *Simulation\_Modal, Simulation\_Time\
.\\AMrotor\\Matlab\_Code\Examples\\Simple\_Laval\\Simulation\_Modal.m*
*.\\AMrotor\\Matlab\_Code\\Examples\\Simple\_Laval\\Simulation\_Time.m*

Funktionalität des Simulationscodes ist in Kommentaren in den beiden angegebenen Dateien gegeben. Diese Dateien eignen sich gut als Ausgangspunkt für eigene Analysen mit dem Simulationsprogramm. Dazu können die getrennten Config-files angepasst werden, die in den beiden Dateien aufgerufen werden.

Eigene Simulationen sollten in einen eigenen Ordner in *./Simulationen/eigeneSimulation/* abgespeichert werden. Der Ordner *./Simulationen* enthält außerdem weitere Beispiele, die weitere Funktionen des Codes demonstrieren, die nicht im allgemeinen Beispiel verwende werden. 