classdef Material < handle
    
    properties 
        name
        e_module
        G_module
        density
        poisson
        shear_factor
        rayleigh_alpha1
        rayleigh_alpha2
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
                
                self.rayleigh_alpha1=cnfg.damping.rayleigh_alpha1;
                self.rayleigh_alpha2=cnfg.damping.rayleigh_alpha2;
            end
        end   
    end
end