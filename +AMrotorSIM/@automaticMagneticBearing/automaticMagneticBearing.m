classdef automaticMagneticBearing < handle
% automaticMagneticBearing Class for AMB
%   Creates other objects of the type SimpleBearing and pidController
    properties
        name
        position
        
        % Bearing-object that gets created by this object (AMB)
        % See also AMrotorSIM.Components.Bearings.SimpleBearing
        simpleBearing@AMrotorSIM.Components.Bearings.SimpleBearing
        
        % pidController-objects that get created by AMB-object
        % See also AMrotorSIM.pidController
        pidController@AMrotorSIM.pidController
        
        % evtl. naechsten Teil der Eigenschaften weglassen und nur in
        % config-stuct abspeichern (das als propertiy uebergeben wird), die
        % folgenden Eigenschaften werden ja dazu genutzt, um die Bearing
        % und Controller-Objekte zu bauen. Die geasmte Information ist dann
        % in diesen Bearing und Controller-Objekten enthalten
        
        %cnfg
        
        kx % N/m, stiffness because of the magnetic field, typically negative value
        
        targetDisplacementX
        targetDisplacementY
        
        ki % N/A, proportionality of magnetic force to electric current
        
        electricalP % A/m
        electricalI % A/(m*s)
        electricalD % As/m
    end
    methods
        %Konstruktor
        function obj=automaticMagneticBearing(cnfg)
            if nargin == 0
                obj.name = 'Empty automatic magnetic bearing';
                obj.position = 0;
                %obj.simpleBearing = AMrotorSIM.Components.Bearings.SimpleBearing();
                %obj.pidController(1) = AMrotorSIM.pidController();
                %obj.pidController(2) = AMrotorSIM.pidController();
            else
            obj.name = cnfg.name;
            obj.position = cnfg.position;
            obj.kx = cnfg.kx;
            obj.targetDisplacementX = cnfg.targetDisplacementX;
            obj.targetDisplacementY = cnfg.targetDisplacementY;
            obj.ki = cnfg.ki;
            obj.electricalP = cnfg.electricalP;
            obj.electricalI = cnfg.electricalI;
            obj.electricalD = cnfg.electricalD;
            % in Konstruktor bereits die controller und bearing objects
            % erstellen ODER in extra Funtkion erstellen, die dann in
            % assemble aufgerufen wird und der dann auch die ertsellten
            % Objekte an das rotorsystem uebergibt
            end
        end
        
    end
end