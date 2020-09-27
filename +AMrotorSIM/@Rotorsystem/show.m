function show(obj)
% Displays all parts of the system in the command window
%
%    :param obj: Object of type rotorsystem
%    :type obj: object
%    :return: Output in command window

            disp('--------------- Rotorsystem ------------------')
         disp(obj.name);
        for i=obj.rotor
            i.print();
        end

            disp('----------------------------------------------')
            disp('--------------- Components -------------------')
        for i=obj.components
            i.print();
        end
        
            disp('----------------------------------------------')
            disp('--------------- Sensors ----------------------')
        for i=obj.sensors
            i.print();
        end
            disp('----------------------------------------------')
            disp('--------------- Loads ------------------------')
         for i=obj.loads
             i.print();
         end
            disp('----------------------------------------------')
            disp('--------------- PID Controllers --------------')
         for i=obj.pidControllers
             i.print();
         end
            disp('----------------------------------------------')
end