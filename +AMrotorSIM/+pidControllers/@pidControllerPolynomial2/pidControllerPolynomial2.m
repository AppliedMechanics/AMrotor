% Licensed under GPL-3.0-or-later, check attached LICENSE file

classdef pidControllerPolynomial2 < AMrotorSIM.pidControllers.pidController
    % Sub-class of pid controller with 2nd order polynomial with displacement and current for force 
    
    
    %   force = [I, x]*A*[I^2;x^2] + [I,x]*B*[I;x] + cT*[I;x] + d
    %
    % Dietz: Mehrdimensionale Kalibrierung eines Magnetlagers mittels
    % Kraftmessplattform (Bachelor's Thesis, 2018), p. 58
    %Description of the properties:
        % mixed terms 3rd order: I^2*x, I*x^2, size: 2x2
        % units: [A] = [N/A^3, N/(A*m^2); N/(A^2*m), N/m^3]
        %A
        
        % 2nd order, 2x2
        % units: [B] = [N/A^2, N/(A*m); N/(A*m), N/m^2]
        %B
        
        % 1st order, 1x2
        % units: [cT] = [N/A, N/m]
        %cT
        
        % 0th order, 1x1
        % units: [d] = N
        %d
    
    properties
        A
        B
        cT
        d
    end
    
    methods
        function obj=pidControllerPolynomial2(cnfg)
            % Constructor
            %
            %    :parameter cnfg: Cnfg_component substruct of cnfg-struct
            %    :type cnfg: struct
            %    :return: pidControllerPolynomial2 object
            
            obj=obj@AMrotorSIM.pidControllers.pidController(cnfg);
            obj.A = cnfg.A;
            obj.B = cnfg.B;
            obj.cT = cnfg.cT;
            obj.d = cnfg.d;
        end
    end

end