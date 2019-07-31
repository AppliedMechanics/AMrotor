classdef activeMagneticBearing < handle
% activeMagneticBearing Class for AMB
%   Creates other objects of the type SimpleBearing and pidController
    properties
        cnfg
        name
        position
        
        % Bearing-object that gets created by this object (AMB)
        % See also AMrotorSIM.Components.Bearings.SimpleBearing
        simpleBearing@AMrotorSIM.Components.Bearings.SimpleBearing
        
        % pidController-objects that get created by AMB-object
        % See also AMrotorSIM.pidControllers.pidController
        pidController@AMrotorSIM.pidControllers.pidController
        
        kx % N/m, stiffness because of the magnetic field, typically negative value
        
        targetDisplacementX
        targetDisplacementY
        
        pidType
        
        electricalP % A/m
        electricalI % A/(m*s)
        electricalD % As/m
    end
    methods
        %Konstruktor
        function obj=activeMagneticBearing(cnfg)
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