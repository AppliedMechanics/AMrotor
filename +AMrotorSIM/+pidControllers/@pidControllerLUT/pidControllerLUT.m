classdef pidControllerLUT < AMrotorSIM.pidControllers.pidController
    % pidControllerLUT sub-Class of pid controller with LookUpTable for
    % force using interp2
    %   force = table(x,I)
    properties
        % table is a struct which must include the following variables
        % table.displacement = 1 x Ndisplacment array
        % table.current = 1 x Ncurrent array
        % table.force = Ncurrent x Ndisplacement
        table
    end
    
    methods
        function obj=pidControllerLUT(cnfg)
            obj=obj@AMrotorSIM.pidControllers.pidController(cnfg);
            obj.table = cnfg.table;
        end
    end

end