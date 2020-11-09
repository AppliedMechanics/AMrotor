classdef ActiveMagneticBearing < handle
% ActiveMagneticBearing class for AMB's

%   Creates other objects of the type SimpleBearing and pidController
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

    properties
        cnfg
        name
        position        
        simpleBearing@AMrotorSIM.Components.Bearings.SimpleBearing     
        pidController@AMrotorSIM.pidControllers.pidController        
        kx         
        targetDisplacementX
        targetDisplacementY        
        pidType        
        electricalP
        electricalI
        electricalD
    end
    methods
        function obj=ActiveMagneticBearing(cnfg)
            % Constructor
            %
            %    :parameter cnfg: cnfg-struct from separat Config-script
            %    :type cnfg: struct
            %    :return: AMB object
            
            if nargin == 0
                obj.name = 'Empty active magnetic bearing';
                obj.position = 0;
                %obj.simpleBearing = AMrotorSIM.Components.Bearings.SimpleBearing();
                %obj.pidController(1) = AMrotorSIM.pidController();
                %obj.pidController(2) = AMrotorSIM.pidController();
            else
                obj.cnfg = cnfg;
                obj.name = cnfg.name;
                obj.position = cnfg.position;
                obj.kx = cnfg.kx;
                obj.targetDisplacementX = cnfg.targetDisplacementX;
                obj.targetDisplacementY = cnfg.targetDisplacementY;
                obj.pidType = cnfg.pidType;
                obj.electricalP = cnfg.electricalP;
                obj.electricalI = cnfg.electricalI;
                obj.electricalD = cnfg.electricalD;
            end
        end
        
    end
end