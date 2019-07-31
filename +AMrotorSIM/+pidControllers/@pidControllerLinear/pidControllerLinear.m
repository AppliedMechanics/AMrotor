classdef pidControllerLinear < AMrotorSIM.pidControllers.pidController
    % pidController sub-Class for pid controller for force
    %   force = ki*I
    %
    % param must contain 
    %   param.ki: N/A, proportionality between controller current and force
    properties
        ki
    end
    
    methods
        function obj=pidControllerLinear(cnfg)
            obj=obj@AMrotorSIM.pidControllers.pidController(cnfg);
            obj.ki = cnfg.param.ki;
        end
    end

end