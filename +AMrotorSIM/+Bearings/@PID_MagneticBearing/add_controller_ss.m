function [ ss_out] = add_controller_ss(obj, ss_in, dir,rotorsystem)
%ADD_CONTROLLER_SS Fügt einen PID-Regler zum System Zustand hinzu
% Eingabe: Zustandsraumdarstellung
% Ausgabe: Zustandsraumdarstellung um einen Stromzustand erweitert
% dir: Direction - Richtung in der der Regler wirkt: 1:x-Richtung, 2:y-Richtung, 3:x&y-Richtung

if dir == 1
    disp('Noch nicht implementiert')
elseif dir == 2
    disp('Noch nicht implementiert')
elseif dir == 3
    disp('Hinzufügen eines PID Controllers auf beide Richtungen')
    
            Kp=obj.cnfg.mag.Kp;
            Kd=obj.cnfg.mag.Kd;
            Ki=obj.cnfg.mag.Ki;
            
            z_pos = obj.position;
            
   % Position im Zustandsvektor finden für x und dx
   [n_x,n_dx,n_y,n_dy]=rotorsystem.find_next_node_ss(z_pos);
   
   obj.ss_position.n_x = n_x;
   obj.ss_position.n_y = n_y;
   obj.ss_position.n_dx = n_dx;
   obj.ss_position.n_dy = n_dy;
   
   ss_controller_x = zeros(length(ss_in)+2);
   ss_controller_y = zeros(length(ss_in)+2);
   
   ss_pi_x = zeros(1,length(ss_in)+2);
   ss_pi_x(n_x)=-Ki; ss_pi_x(n_dx)=-Kp;
   
   ss_pi_y = zeros(1,length(ss_in)+2);
   ss_pi_y(n_y)=-Ki; ss_pi_y(n_dy)=-Kp;
   
   ss_controller_x(end-1,:) =-Kd*[ss_in(n_dx,:),0,0]+ss_pi_x;
   ss_controller_y(end,:) = -Kd*[ss_in(n_dy,:),0,0]+ss_pi_y;
   
   obj.ss_position.n_Ix = length(ss_controller_x)-1;
   obj.ss_position.n_Iy = length(ss_controller_y);
   
   ss_out = [ss_in,zeros(length(ss_in),2);zeros(2,length(ss_in)+2)]+ss_controller_x+ss_controller_y;
end
end

