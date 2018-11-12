function F = get_loc_force(self,rpm,u)
    
    par = self.cnfg.par;
    par.omega = rpm/60*2*pi;
    phi0=u(6); % psi_z an der Stelle des Lagers auslesen %Stimmt das? Oder muss ich omega*t+u(6) rechnen? Ist u(6) der absolute Winkel oder nur ein delta zum fest vorgegebenen?
    par.phi=[0:(2*pi/par.N):(2*pi/par.N)*(par.N-1)]+phi0; %par.N=numberOfBalls
        
    % dof-order: ux,uy,uz,psix,psiy,psiz
    
    F = self.LimSinghForce(par,u(1:5));

    
end