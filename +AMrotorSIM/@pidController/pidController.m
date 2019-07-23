classdef pidController < handle
    % pidController Class for pid controller for force
    %   Outputs a force to a certain node, that is closest to position, to
    %   maintain the desired displacement at that node
    %   F = Kp*e(t) + Ki*int(e(tau),t) + Kd*de(t)/dt
    properties
        name
        position
        direction % 'u_x','u_y','u_z','psi_x','psi_y','psi_z'
        
        targetDisplacement
        
        P % N/m
        I % N/(m*s)
        D % Ns/m
        
        cumError = 0 % cummulated error
        prevError = 0 % error in the previus step
        prevTime = 0 % time of the previous step
        
        force = 0 % current controller force
    end
    methods
        %Konstruktor
        function obj=pidController(cnfg)
            if nargin == 0
                obj.name = 'Empty PID-Controller';
                obj.position = 0;
                obj.P = 0;
                obj.I = 0;
                obj.D = 0;
            else
            obj.name = cnfg.name;
            obj.position = cnfg.position;
            obj.direction = cnfg.direction;
            obj.targetDisplacement = cnfg.targetDisplacement;
            obj.P = cnfg.P;
            obj.I = cnfg.I;
            obj.D = cnfg.D;
            end
        end
        
    end
end