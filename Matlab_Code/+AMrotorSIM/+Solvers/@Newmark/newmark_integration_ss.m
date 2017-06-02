function [q,qd,qdd] = newmark_integration_ss(obj, beta , gamma,ss,f,t,q_0,qd_0,qdd_0,constant)
% NEWMARK_INTEGRATION   f�hrt eine Newmark Zeitintegration durch
%
% Syntax:
%   [q,qd,qdd] = newmark_integration(beta,gamma,M,D,K,f,t,q_0,qd_0,qdd_0,constant)
%
%   R�ckgabewerte:  q   = Verschiebungen f�r jeden Zeitschritt (i-te Zeile = i-ter DOF, i-te Spalte = i-ter Zeitschritt)
%                   qd  = Geschwindigkeiten f�r jeden Zeitschritt (i-te Zeile = i-ter DOF, i-te Spalte = i-ter Zeitschritt)
%                   qdd = Beschleunigungen f�r jeden Zeitschritt (i-te Zeile = i-ter DOF, i-te Spalte = i-ter Zeitschritt)
%
%   Parameter:     beta = Beta (Parameter f�r das Newmark-Verfahren)
%                 gamma = Gamma (Parameter f�r das Newmark-Verfahren)
%                   M   = Massenmatrix
%                   D   = D�mpfungsmatrix
%                   K   = Steifigkeitsmatrix
%                   f   = Lastvektor f�r jeden Zeitschritt (i-te Zeile = DOF, i-te Spalte = i-ter Zeitschritt)
%                   t   = Zeitvektor (Zeit nach jedem Zeitschritt, beginnend bei 0)
%                   q_0 = Vektor mit Anfangsbedingungen f�r die Verschiebung
%                  qd_0 = Vekotr mit Anfangsbedingungen f�r die Geschwindigkeit
%                 qdd_0 = Vektor mit Anfangsbedingungen f�r die Beschleunigung
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
    
    % �berpr�fe, ob alle notwendigen Parameter �bergeben wurden
%     if nargin < 10
%         fprintf(2,'Fehler in newmark_integration: Zu wenige Parameter �bergeben!');
%         return;
%     else
%         if nargin > 10
%             cons=constant;
%         else
%             % cons nicht �bergeben wurde, nimm an, dass die Zeitschritte
%             % nicht konstant sind
%             cons=0;
%         end
        
        % Pr�fe, ob M, D und K kompatibel sind
        if ~(size(D,1)==ndof && size(K,1)==ndof)
            fprintf(2,'Fehler in newmark_integration: M,D und K m�ssen dieselbe Dimension haben');
            return;
        end

        % Anzahl der Integrationsschritte
        if isvector(t)
            nsteps=length(t);
        else
            fprintf(2,'Fehler in newmark_intergration: t muss ein Vektor sein');
            return;
        end
        
        % Reserviere Speicher f�r q, qd und qdd (Ort, Geschwindigkeit, Beschleunigung)
        q=zeros(ndof,nsteps);
        qd=zeros(ndof,nsteps);
        qdd=zeros(ndof,nsteps);
        
        % �berpr�fe, ob die Anfangsbedingungen zu der Dimension von M, D
        % und K passen
        if (length(q_0)==ndof && length(qd_0)==ndof && length(qdd_0)==ndof)
            
            % Setze die Anfangsbedingungen in den L�sungsvektor zum 1.
            % Zeitschritt
            q(:,1)=q_0;                 %q_0
            qd(:,1)=qd_0;               %qd_0
            qdd(:,1)=qdd_0;             %qdd_0
        else
            fprintf(2,'Fehler in newmark_integration: Die Anfangsbedingungen stimmen nicht mit der Anzahl der Freiheitsgrade �berein!');
            return;
        end
        
        % �berpr�fe, ob beta und gamma g�ltige Werte annehmen
        if (gamma>=0 && gamma<=1 && beta>=0 && beta<=0.5)
            
            % 2 F�lle:
            % Wenn cons==1 ist, hei�t das, dass die Zeitschritte alle
            % gleich gro� sind. In diesem Fall ist die Matrix S (s.u.)
            % konstant und es kann eine LU-Faktorisierung vorgenommen
            % werden. Dies erh�ht die Schnelligkeit der Newmark-Integration
            % ennorm, da nicht bei jedem Zeitschritt ein vollst�ndiges
            % lineares Gleichungssystem gel�st werden muss.
            % Wenn cons~=1 ist, hei�t das, dass die Zeitschritte nicht
            % konstant sind. In diesem Fall �ndert sich S in jedem
            % Zeitschritt und es muss f�r jeden Zeitschritt ein neues
            % lineares Gleichungssystem gel�st werden.
            
            % Fall 1: cons=1
            if cons==1
                
                % Zeitschrittbreite
                dt=t(2)-t(1);
                
                % Systemmatrix
                S=M+dt*gamma*D+dt^2*beta*K;
                
                % LU-Zerlegung
                [L,U]=lu(S);
                
                % F�r jeden Zeitschritt f�hre aus...
                for n = 2:nsteps
                    
                    %Pr�diktion
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
                % F�hre f�r jeden Zeitschritt aus...
                for n = 2: nsteps
                    dt=t(n)-t(n-1);
                    %Pr�diktion
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
            fprintf(2,'Fehler in newmark_integration: Beta und Gamma m�ssen g�ltige Werte annehmen');
            return;
        end % Ende if gamma > 0...
%     end % Ende nargin < 10
end % Ende der function