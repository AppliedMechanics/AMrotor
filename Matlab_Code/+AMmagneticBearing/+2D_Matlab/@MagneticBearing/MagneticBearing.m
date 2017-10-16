classdef MagneticBearing < handle
    %MAGNETICBEARING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        cnfg
        model=createpde()
    end
    
    methods
        %Konstruktor
       function obj = MagneticBearing(name,cnfg)
            obj.name=name;
            obj.cnfg=cnfg;
          %
       end
       
    end
    
end

