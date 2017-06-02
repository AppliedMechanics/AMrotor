function dZ = integrate_function(t,Z, ss,ss_h,n_nodes,omega_rot_const_force,rotorsystem)

phi=Z(8*n_nodes+1);                           %phi    = z(end-2);
omega=Z(8*n_nodes+2);
domega=0;

h_ges = (ss_h.h +(ss_h.h_ZPsin.*(omega^2) + ss_h.h_DBsin.*domega +ss_h.h_sin).*(-1)*sin(phi) ...
              +(ss_h.h_ZPcos.*(omega^2) + ss_h.h_DBcos.*domega +ss_h.h_cos).*(-1)*cos(phi)) ...
              + ss_h.h_rotsin.*sin(phi*omega_rot_const_force) + ss_h.h_rotcos.*cos(phi*omega_rot_const_force); %+Dichtung+Lager

%%  Magnetlagerkraft berechnen
%

        for i=rotorsystem.lager
            if i.cnfg.type==3
                
            n_x = i.ss_position.n_x;
            n_Ix = i.ss_position.n_Ix;
            n_y = i.ss_position.n_y;
            n_Iy = i.ss_position.n_Iy;
% x aus Zustandsvektor suchen
% I aus Zustandsvektor suchen
% Kraft F(x,I) berechnen 
            [Fx,Fy]=i.compute_force( Z(n_x),Z(n_y),Z(n_Ix),Z(n_Iy));
% F zu h_ges hinzufügen  
            h_ges(n_x)=h_ges(n_x)+Fx;
            h_ges(n_y)=h_ges(n_y)+Fy;
            end
        end          

%% Iteration zur Einstellung des neuen Gleichgewichts
%
% while dZ_neu - dZ_alt > Toleranz
% dZ_neu = ss*Z+h_ges_neu
% end


%%                  
dZ = ss*Z+h_ges;
end

