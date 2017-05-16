classdef Newmark < AMrotorSIM.Solvers.Solver
    % NEWMARK führt eine Zeitintegration für eine Substruktur mit dem Newmark-Scheme durch
   
    properties
        % Public, tunable properties.
    end
    
    properties (Nontunable)
        % Public, non-tunable properties.
        M=1;
        C=0;
        K=1;
        beta=0.25;
        gamma=0.5;
        T_A=0.01;
        P=1;
        G=1;
        
        q_0=0.0;
        qd_0=0.0;
        qdd_0=0.0;
        
    end
    
    properties (Access = private)
        % Pre-computed constants.
        ndofin=0;
        L;
        U;
    end
    
    properties (Access = private, Nontunable)
        
    end
    
    properties (DiscreteState)
        q;
        qd;
        qdd;
    end
    
    methods
        % Constructor
        function obj = Newmark(varargin)
            % Support name-value pair arguments when constructing the
            % object.
            setProperties(obj,nargin,varargin{:});
        end
    end
    
    methods (Static, Access = protected)
        function header = getHeaderImpl
            header = matlab.system.display.Header('Newmark',...
                'Title','Newmark-Scheme for Substructures');
        end
        
        function groups = getPropertyGroupsImpl
            systemGroup = matlab.system.display.Section(...
            'Title','Systemmatrizen','Description','Newmark',...
            'PropertyList',{'M','C','K','P','G'});
 
            setupGroup = matlab.system.display.Section(...
            'Title','Newmark-Parameter',...
            'PropertyList',{'beta','gamma','T_A'});
        
            icGroup = matlab.system.display.Section(...
            'Title','Anfangswerte',...
            'PropertyList',{'q_0','qd_0','qdd_0'});
        
            groups = [systemGroup,setupGroup,icGroup];
        end
    end
    
    methods (Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Implement tasks that need to be performed only once,
            % such as pre-computed constants.
            fprintf('LU-Zerlegung...');
            [obj.L,obj.U] = lu(obj.M + (obj.T_A*obj.gamma).*obj.C+(obj.T_A^2*obj.beta).*obj.K);
            obj.ndofin = size(obj.P,2);
            fprintf('beendet.\n');
        end
        
        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of
            % input u and discrete states.
            % Prädiktion
            qd_p=obj.qd+((1-obj.gamma)*obj.T_A).*obj.qdd;
            q_p=obj.q+obj.T_A.*obj.qd+((0.5-obj.beta)*obj.T_A^2).*obj.qdd;

            %Beschleunigungsberechnung
            f=obj.P*u;
            y_p=obj.L\(f-obj.C*qd_p-obj.K*q_p);
            qdd_new=obj.U\y_p;

            % Ausgabe
            q_new=q_p+(obj.T_A^2*obj.beta).*qdd_new;
            y = obj.G*q_new;
            
            %Correction
            obj.qdd = qdd_new;
            obj.qd=qd_p+obj.T_A*obj.gamma.*qdd_new;
            obj.q=q_new;

        end
        
        function resetImpl(obj)
            % Initialize discrete-state properties.
            obj.q = obj.q_0;
            obj.qd = obj.qd_0;
            obj.qdd = obj.qdd_0;
        end
        
    end
end
