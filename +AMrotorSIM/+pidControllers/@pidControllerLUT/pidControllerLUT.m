% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef pidControllerLUT < AMrotorSIM.pidControllers.pidController
    % Sub-class of pid controller with LookUpTable for force using MATLABs interp2
    
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
            % Constructor
            %
            %    :parameter cnfg: Cnfg_component substruct of cnfg-struct
            %    :type cnfg: struct
            %    :return: pidControllerLUT object
            
            obj=obj@AMrotorSIM.pidControllers.pidController(cnfg);
            obj.table = cnfg.table;
        end
    end

end