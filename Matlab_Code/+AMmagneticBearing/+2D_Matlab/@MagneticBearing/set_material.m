function set_material( self, faces )
%SET_MATERIAL Summary of this function goes here
%   Detailed explanation goes here


% Koeffizienten fuer Luftphase
specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Luft),'a',0,'f',0,'Face',faces.Luft);         

% Koeffezienten der Eisenphase / Unterscheidung: nichtlinear oder lineares Model
if self.cnfg.material.nonlinMu  
    cCoef = @(region,state) (mu_0*(mu_rEisen./(1+0.05*(state.ux.^2 +state.uy.^2))+200));    % nicht konstanter Koeffizient C (Permeabilitaet)
        %� = 4*pi*10^(-7)*(5000./(1+0.05*(ux.^2+uy.^2))+200) 
    specifyCoefficients(self.model,'m',0,'d',0,'c',cCoef,'a',0,'f',0,'Face',faces.Eisen);       % Eisenkern und Rotorbuechse

else 
      specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Eisen),'a',0,'f',0,'Face',faces.Eisen);       % Eisenkern und Rotorbuechse


end

% Koeffizienten der Kupferspulen
specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',0,'Face',[faces.SpuleA_1,faces.SpuleB_1,faces.SpuleA_2,faces.SpuleB_2,faces.SpuleA_3,faces.SpuleB_3,faces.SpuleA_4,faces.SpuleB_4]);  

end

