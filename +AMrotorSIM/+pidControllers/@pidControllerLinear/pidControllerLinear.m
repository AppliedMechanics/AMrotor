classdef pidControllerLinear < AMrotorSIM.pidControllers.pidController
    % pidControllerLinear sub-Class of pid controller with linear force
    %   force = ki*I
    %
    properties
        ki % N/A, proportionality between controller current and force, force = ki*I
    end
    
    methods
        function obj=pidControllerLinear(cnfg)
            obj=obj@AMrotorSIM.pidControllers.pidController(cnfg);
            obj.ki = cnfg.ki;
        end
    end

end