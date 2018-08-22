classdef Material < handle
    
    properties 
        name
        e_module
        G_module
        density
        poisson
        shear_factor
        
    end
    
    methods
        function self = Material(cnfg)
            if nargin==0
                self.name = 'No Material configuration';
            else
                self.name = cnfg.name;
                self.e_module = cnfg.e_module;
                self.density = cnfg.density;
                self.poisson = cnfg.poisson;
                self.shear_factor = cnfg.shear_factor;
                self.G_module = self.e_module/(2*(1+self.poisson));
            end
        end   
    end
end