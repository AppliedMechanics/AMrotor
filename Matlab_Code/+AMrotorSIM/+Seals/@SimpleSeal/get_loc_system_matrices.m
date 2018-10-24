function [M_s,D_s,K_s] = get_loc_system_matrices(self,rpm)
% dof-order: ux,uy,uz,psix,psiy,psiz

M = sparse(6,6);
D = sparse(6,6);
K = sparse(6,6);

% auskommentierte Zeilen (sys.) werden in Config-file vorgegeben
% sys.T=42.5;
% nu40=46;
% nu100=7;
% nut=nu40+((nu40-nu100)/(40-100))*(sys.T-40);
%sys.nu = nut*sys.rho*10^(-6); % T=40; 46 T=100; 7


% Auswahl des Modells samt zugehörigen Testwerten aus Dyrobes
 auswahl = self.cnfg.sealModel.type;
% 1  dyrobes.com - Blackfigure
% 2  dyrobes.com - Childs | beachte verschiedenen Werte für sys.v0 zu setzen

 switch auswahl
     case 'Black'  % dyrobes.com - Blackfigure
        % auskommentierte Zeilen (sys.) werden in Config-file vorgegeben
        % sys.v0 = 0.5;
        % 
        % sys.d = 0.1-2*0.00017;                       % Innendurchmesser
        % sys.D = 0.1;          % Außendurchmesser
        % sys.L = 0.02;                       % Spaltlänge
        % 
        % sys.R = (0.5*sys.D+0.5*sys.d)*0.5;  % Mittlerer Radius
        % 
        % sys.Dpw = 0.5*(sys.D+sys.d);        % Mittlerer Durchmesser
        % sys.S = 0.5*sys.D-0.5*sys.d;        % Spaltweite
        % 
        % sys.xi_ein = 0.1;                   % Eintrittsverlust im Dichtspalt
        % sys.xi_aus = 1;                     % Austrittsverlust im Dichtspalt
        % 
        % sys.p = 3e5;                     % Druckdifferenz über Dichtung in Pa, N/m^2, 1bar=10^5Pa
        % sys.rho = 880;                      % Dichte
        % sys.nu = nut*sys.rho*10^(-6);                   % dynamische Viskosität Pa*s
        
        % Zustand 0 AR  Initialisierung
        init.x0AR = [0;0;0];
        init.phi0AR = [0;0;0];
        init.xd0AR = [0;0;0];
        init.omega0AR = [0;0;0];
        
        % Zustand 0 IR
        init.x0IR = [0;0;0];
        init.phi0IR = [0;0;0];
        init.xd0IR = [0;0;0];
        init.omega0IR = [rpm*pi/30;0;0];        % Einheit: rad/s ? 
        
        [ M_s,D_s,K_s ] = self.BlackModel( init );
        
        
        %B(k,:)=[rpm, MB(1,1),MB(1,2),DB(1,1),DB(1,2),KB(1,1),KB(1,2)];
        
        
     case 'Childs'  % dyrobes.com - Childs | beachte verschiedenen Werte für sys.v0 zu setzen
        %NOTE Achtung!! Padavala kann wohl mit der Konvention (negatives Vorzeichen)
        %nichts anfangen
        % folgende auskommentierte Zeilen (sys.) werden in Config-file vorgegeben
        % sys.v0 = 0;%-0.5;                      
        % 
        % sys.d = 0.1-2*0.00017;                       % Innendurchmesser
        % sys.D = 0.1; %sys.d + 2 * 0.1397e-3;          % Außendurchmesser
        % sys.L = 0.02;                       % Spaltlänge
        % 
        % sys.R = (0.5*sys.D+0.5*sys.d)*0.5;  % Mittlerer Radius
        % 
        % sys.Dpw = 0.5*(sys.D+sys.d);        % Mittlerer Durchmesser
        % sys.S = 0.5*sys.D-0.5*sys.d;        % Spaltweite
        % 
        % sys.xi_ein = 0.1;                   % Eintrittsverlust im Dichtspalt
        % sys.xi_aus = 1;                     % Austrittsverlust im Dichtspalt
        % 
        % sys.p = 3e5;                     % Druckdifferenz über Dichtung in Pa, N/m^2, 1bar=10^5Pa
        % sys.rho = 880;                      % Dichte
        % sys.nu = nut*sys.rho*10^(-6);                   % dynamische Viskosität Pa*s
        % 
        % Zustand 0 AR  Initialisierung
        init.x0AR = [0;0;0];
        init.phi0AR = [0;0;0];
        init.xd0AR = [0;0;0];
        init.omega0AR = [0;0;0];
        
        % Zustand 0 IR
        init.x0IR = [0;0.0;0];
        init.phi0IR = [0;0;0];
        init.xd0IR = [0;0;0];
        init.omega0IR = [rpm*pi/30;0;0];       % Einheit: rad/s !
        
        [ M_s,D_s,K_s ] = self.ChildsModel( init );

      %  C(k,:)=[rpm, MC(1,1),MC(1,2),DC(1,1),DC(1,2),KC(1,1),KC(1,2)];
      
     case 'Table'
        [ M_s,D_s,K_s ] = self.LookUpTable( rpm );
 end
 
 M(1:2,1:2) = M_s;
 D(1:2,1:2) = D_s;
 K(1:2,1:2) = K_s;
 
self.mass_matrix = M;
self.damping_matrix = D;
self.stiffness_matrix = K;

end