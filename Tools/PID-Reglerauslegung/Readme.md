Erstelle zunächst die Matrizen **A,B,C,D** für das State Space-Modell der Strecke.
Zum Beispiel aus dem Code mit folgendem Befehl. Dabei empfiehlt es sich im Config-file nur einen Regler mit der Richtung x zu wählen, damit die Matrizen einfach bleiben. Der Code-Baustein muss nach dem Zusammenbauen des Modells erfolgen. Also an der Stelle an der auch die Systemanalysen durchgeführt werden würden.

    %% get state-space-matrix for simulink model
    % used for tuning of the pid-values
    rpm = 0;
    [A,B,C,D] = r.compute_state_space_for_controller(rpm/60*2*pi);
    save('systemmatricesSS','A','B','C','D')
    clear A B C D rpm

Danach kann die PID-tuning-Funktion im Simulink-Modell ausgeführt werden. Die State-Space-Matrizen müssen dafür im workspace von Matlab geladen sein. 