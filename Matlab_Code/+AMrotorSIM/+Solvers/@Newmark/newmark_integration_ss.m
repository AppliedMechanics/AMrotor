function [q,qd,qdd] = newmark_integration_ss(obj, beta , gamma,ss,f,t,q_0,qd_0,qdd_0,constant)
% NEWMARK_INTEGRATION   führt eine Newmark Zeitintegration durch
%
% Syntax:
%   [q,qd,qdd] = newmark_integration(beta,gamma,M,D,K,f,t,q_0,qd_0,qdd_0,constant)
%
%   Rückgabewerte:  q   = Verschiebungen für jeden Zeitschritt (i-te Zeile = i-ter DOF, i-te Spalte = i-ter Zeitschritt)
%                   qd  = Geschwindigkeiten für jeden Zeitschritt (i-te Zeile = i-ter DOF, i-te Spalte = i-ter Zeitschritt)
%                   qdd = Beschleunigungen für jeden Zeitschritt (i-te Zeile = i-ter DOF, i-te Spalte = i-ter Zeitschritt)
%
%   Parameter:     beta = Beta (Parameter für das Newmark-Verfahren)
%                 gamma = Gamma (Parameter für das Newmark-Verfahren)
%                   M   = Massenmatrix
%                   D   = Dämpfungsmatrix
%                   K   = Steifigkeitsmatrix
%                   f   = Lastvektor für jeden Zeitschritt (i-te Zeile = DOF, i-te Spalte = i-ter Zeitschritt)
%                   t   = Zeitvektor (Zeit nach jedem Zeitschritt, beginnend bei 0)
%                   q_0 = Vektor mit Anfangsbedingungen für die Verschiebung
%                  qd_0 = Vekotr mit Anfangsbedingungen für die Geschwindigkeit
%                 qdd_0 = Vektor mit Anfangsbedingungen für die Beschleunigung
%              constant = 0/1, 1=alle Zeitschrittbreiten sind gleich (beschleunigt den Algorithmus!),
%                              0=Zeitschrittbreiten sind verschieden


%      Author: Andreas Bartl AM
%      Edited: Christian Meyer
%     Created: 23.1.2014
%     Updated: 22.8.2015
% Description: newmark_integration
%   Parameter: beta, gamma, M, D, K, f, t, q_0, qd_0, qdd_0, constant
%      Return: [q,qd,qdd]

    % Initialize
    q=0;
    qd=0;
    qdd=0;
    
    % Anzahl der Freiheitsgrade
    ndof=size(M,1);
    
    cons=constant;
    
    % Überprüfe, ob alle notwendigen Parameter übergeben wurden
%     if nargin < 10
%         fprintf(2,'Fehler in newmark_integration: Zu wenige Parameter übergeben!');
%         return;
%     else
%         if nargin > 10
%             cons=constant;
%         else
%             % cons nicht übergeben wurde, nimm an, dass die Zeitschritte
%             % nicht konstant sind
%             cons=0;
%         end
        
        % Prüfe, ob M, D und K kompatibel sind
        if ~(size(D,1)==ndof && size(K,1)==ndof)
            fprintf(2,'Fehler in newmark_integration: M,D und K müssen dieselbe Dimension haben');
            return;
        end

        % Anzahl der Integrationsschritte
        if isvector(t)
            nsteps=length(t);
        else
            fprintf(2,'Fehler in newmark_intergration: t muss ein Vektor sein');
            return;
        end
        
        % Reserviere Speicher für q, qd und qdd (Ort, Geschwindigkeit, Beschleunigung)
        q=zeros(ndof,nsteps);
        qd=zeros(ndof,nsteps);
        qdd=zeros(ndof,nsteps);
        
        % Überprüfe, ob die Anfangsbedingungen zu der Dimension von M, D
        % und K passen
        if (length(q_0)==ndof && length(qd_0)==ndof && length(qdd_0)==ndof)
            
            % Setze die Anfangsbedingungen in den Lösungsvektor zum 1.
            % Zeitschritt
            q(:,1)=q_0;                 %q_0
            qd(:,1)=qd_0;               %qd_0
            qdd(:,1)=qdd_0;             %qdd_0
        else
            fprintf(2,'Fehler in newmark_integration: Die Anfangsbedingungen stimmen nicht mit der Anzahl der Freiheitsgrade überein!');
            return;
        end
        
        % Überprüfe, ob beta und gamma gültige Werte annehmen
        if (gamma>=0 && gamma<=1 && beta>=0 && beta<=0.5)
            
            % 2 Fälle:
            % Wenn cons==1 ist, heißt das, dass die Zeitschritte alle
            % gleich groß sind. In diesem Fall ist die Matrix S (s.u.)
            % konstant und es kann eine LU-Faktorisierung vorgenommen
            % werden. Dies erhöht die Schnelligkeit der Newmark-Integration
            % ennorm, da nicht bei jedem Zeitschritt ein vollständiges
            % lineares Gleichungssystem gelöst werden muss.
            % Wenn cons~=1 ist, heißt das, dass die Zeitschritte nicht
            % konstant sind. In diesem Fall ändert sich S in jedem
            % Zeitschritt und es muss für jeden Zeitschritt ein neues
            % lineares Gleichungssystem gelöst werden.
            
            % Fall 1: cons=1
            if cons==1
                
                % Zeitschrittbreite
                dt=t(2)-t(1);
                
                % Systemmatrix
                S=M+dt*gamma*D+dt^2*beta*K;
                
                % LU-Zerlegung
                [L,U]=lu(S);
                
                % Für jeden Zeitschritt führe aus...
                for n = 2:nsteps
                    
                    %Prädiktion
                    qd_p=qd(:,n-1)+(1-gamma)*dt*qdd(:,n-1);
                    q_p=q(:,n-1)+dt*qd(:,n-1)+(0.5-beta)*dt^2*qdd(:,n-1);
                    
                    %Beschleunigungsberechnung
                    y_p=L\(f(:,n)-D*qd_p-K*q_p);
                    qdd(:,n)=U\y_p;
                    
                    %Correction
                    qd(:,n)=qd_p+dt*gamma*qdd(:,n);
                    q(:,n)=q_p+dt^2*beta*qdd(:,n);
                end
                
            % Fall 2: cons~=1    
            else
                % Führe für jeden Zeitschritt aus...
                for n = 2: nsteps
                    dt=t(n)-t(n-1);
                    %Prädiktion
                    qd_p=qd(:,n-1)+(1-gamma)*dt*qdd(:,n-1);
                    q_p=q(:,n-1)+dt*qd(:,n-1)+(0.5-beta)*dt^2*qdd(:,n-1);
                    %Beschleunigungsberechnung
                    S=M+dt*gamma*D+dt^2*beta*K;
                    qdd(:,n)=S\(f(:,n)-D*qd_p-K*q_p); 
                    %Correction
                    qd(:,n)=qd_p+dt*gamma*qdd(:,n);
                    q(:,n)=q_p+dt^2*beta*qdd(:,n);  
                end
            end
        else
            fprintf(2,'Fehler in newmark_integration: Beta und Gamma müssen gültige Werte annehmen');
            return;
        end % Ende if gamma > 0...
%     end % Ende nargin < 10
end % Ende der function