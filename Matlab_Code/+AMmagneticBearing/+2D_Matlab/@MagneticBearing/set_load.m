function set_load( self, load, faces)
%SET_LOAD Summary of this function goes here
%   Detailed explanation goes here

    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleA_1,'Face',faces.SpuleA_1); % "Positive" Spulenteile
    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleB_1,'Face',faces.SpuleB_1); % "Negative" Spulenteile

    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleA_2,'Face',faces.SpuleA_2); % "Positive" Spulenteile
    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleB_2,'Face',faces.SpuleB_2); % "Negative" Spulenteile

    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleA_3,'Face',faces.SpuleA_3); % "Positive" Spulenteile
    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleB_3,'Face',faces.SpuleB_3); % "Negative" Spulenteile

    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleA_4,'Face',faces.SpuleA_4); % "Positive" Spulenteile
    specifyCoefficients(self.model,'m',0,'d',0,'c',1/(self.cnfg.material.mu_Kupfer),'a',0,'f',load.SpuleB_4,'Face',faces.SpuleB_4); % "Negative" Spulenteile


    
end

