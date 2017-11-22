function set_load( self, load)
% Koeffizienten für die PDE werden festgelegt, um das Magnetische Potential
% zu bestimmen. self.cnfg.faces wird in Configuration_ML_ANTON_Displace zugeordnet
%% Koeffizienten festlegen
    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleA_1,'Face',self.cnfg.faces.SpuleA_1); % "Positive" Spulenteile
    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleB_1,'Face',self.cnfg.faces.SpuleB_1); % "Negative" Spulenteile

    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleA_2,'Face',self.cnfg.faces.SpuleA_2); % "Positive" Spulenteile
    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleB_2,'Face',self.cnfg.faces.SpuleB_2); % "Negative" Spulenteile

    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleA_3,'Face',self.cnfg.faces.SpuleA_3); % "Positive" Spulenteile
    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleB_3,'Face',self.cnfg.faces.SpuleB_3); % "Negative" Spulenteile

    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleA_4,'Face',self.cnfg.faces.SpuleA_4); % "Positive" Spulenteile
    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleB_4,'Face',self.cnfg.faces.SpuleB_4); % "Negative" Spulenteile
end

