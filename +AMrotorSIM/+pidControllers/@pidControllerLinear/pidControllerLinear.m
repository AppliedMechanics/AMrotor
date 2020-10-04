% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef pidControllerLinear < AMrotorSIM.pidControllers.pidController
    % Sub-class of pid controller with linear force (= ki*I)
    
    %   force = ki*I
    % ki... [N/A], proportionality between controller current and force, force = ki*I
    %
    properties
        ki 
    end
    
    methods
        function obj=pidControllerLinear(cnfg)
            % Constructor
            %
            %    :parameter cnfg: Cnfg_component substruct of cnfg-struct
            %    :type cnfg: struct
            %    :return: pidControllerLinear object
            
            obj=obj@AMrotorSIM.pidControllers.pidController(cnfg);
            obj.ki = cnfg.ki;
        end
    end

end