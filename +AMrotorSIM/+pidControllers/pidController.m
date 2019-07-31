classdef  pidController < matlab.mixin.Heterogeneous & handle%classdef (Abstract) pidController < handle
    % pidController Class for pid controller for force
    %   Outputs a force to a certain node, that is closest to position, to
    %   maintain the desired displacement at that node
    %   First calculates the current controller current:
    %   I = Kp*e(t) + Ki*int(e(tau),t) + Kd*de(t)/dt
    %   In every integrator step it calclates the force from a model
    %   force = f(x,I)
    properties
        name
        position
        direction % 'u_x','u_y','u_z','psi_x','psi_y','psi_z'
        
        % sub-type of the controller
        % important for force calculation from current and displacement
        % See also AMrotorsIM.pidControllers.pidControllerLinear
        type
        
        targetDisplacement
        
        electricalP % A/m
        electricalI % A/(m*s)
        electricalD % As/m
        
        cumError = 0 % cummulated error
        prevError = 0 % error in the previus step
        prevTime = 0 % time of the previous step
        
        current = 0 % A, current controller current
    end
    methods
        %Konstruktor
        function obj=pidController(cnfg)
            if nargin == 0
                obj.name = 'Empty PID-Controller';
            else
                obj.name = cnfg.name;
                obj.position = cnfg.position;
                obj.direction = cnfg.direction;
                obj.type = cnfg.type;
                %             obj.param = cnfg.param;
                obj.targetDisplacement = cnfg.targetDisplacement;
                obj.electricalP = cnfg.electricalP;
                obj.electricalI = cnfg.electricalI;
                obj.electricalD = cnfg.electricalD;
            end
        end
        
        function current = get_controller_current(obj,tCurr,y)
            % get the contoller-current i with unit A (ampere)
            % gets called at the controller-frequency
            %   obj: pidController-object
            %   t: time-vector of solution
            %   y: position vector at the corresponding controller node
            
            p = obj.electricalP;
            i = obj.electricalI;
            d = obj.electricalD;
            
            dof_name = {'u_x','u_y','u_z','psi_x','psi_y','psi_z'};
            dof_loc = [1,2,3,4,5,6];
            ldof = containers.Map(dof_name,dof_loc);
            entryNo = ldof(obj.direction);
            
            currVal = y(entryNo);
            dt = tCurr - obj.prevTime;
            
            cumError = obj.cumError;
            prevError = obj.prevError;
            
            target = obj.targetDisplacement;
            
            
            % "loop"
            % P
            error = target - currVal;
            pCor = p * error;
            % I
            cumError = cumError + error;
            iCor = i * cumError * dt;
            % D
            slopeError = (error - prevError) / dt;
            dCor = d * slopeError;
            prevError = error;
            prevTime = tCurr;
            
            cor = pCor + iCor + dCor;
            
            % Stellgroessenbegrenzung
            % if cor > maxCor, cor = maxCor; end
            % if cor < minCor, cor = minCor; end
            
            current = cor;
            
            % write new values to controller object
            obj.cumError = cumError;
            obj.prevError = prevError;
            obj.prevTime = prevTime;
            
        end
    end
    
    methods (Abstract)
        
        % get the controller force from the controller current and displacment
        force = get_controller_force(obj,time,displacement)
        
        print(obj)
    end
end