Erstelle zun�chst die Matrizen **A,B,C,D** f�r das State Space-Modell der Strecke.
Zum Beispiel aus dem Code mit folgendem Befehl. Dabei empfiehlt es sich im Config-file nur einen Regler mit der Richtung x zu w�hlen, damit die Matrizen einfach bleiben. Der Code-Baustein muss nach dem Zusammenbauen des Modells erfolgen. Also an der Stelle an der auch die Systemanalysen durchgef�hrt werden w�rden.

    %% get state-space-matrix for simulink model
    % used for tuning of the pid-values
    rpm = 0;
    [A,B,C,D] = r.compute_state_space_for_controller(rpm/60*2*pi);
    save('systemmatricesSS','A','B','C','D')
    clear A B C D rpm

Danach kann die PID-tuning-Funktion im Simulink-Modell ausgef�hrt werden. Die State-Space-Matrizen m�ssen daf�r im workspace von Matlab geladen sein. 