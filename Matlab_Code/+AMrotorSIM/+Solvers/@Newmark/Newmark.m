classdef Newmark < AMrotorSIM.Solvers.Solver
    % NEWMARK führt eine Zeitintegration mit dem Newmark-Scheme durch
    
    properties
        M;
        C;
        K;
        beta=0.25;
        gamma=0.5;
        t=[0:0.01:1];
        P=1;
        G=1;
        
        q_0=0.0;
        qd_0=0.0;
        qdd_0=0.0;
        
        q;
        qd;
        qdd;
    end
    
    properties (Access = private)
        % Pre-computed constants.
        ndofin=0;
        L;
        U;
    end
    
    methods
        % Constructor
        function obj = Newmark(varargin)
            % Support name-value pair arguments when constructing the
            % object.
            %setProperties(obj,nargin,varargin{:});
        end
    end
    
    methods
       [q,qd,qdd] = newmark_integration(obj, beta , gamma, M, D, K,f,t,q_0,qd_0,qdd_0,constant)
    end
    
    methods
        %% Common functions
        function setupImpl(obj)
            % Implement tasks that need to be performed only once,
            % such as pre-computed constants.
        if isvector(obj.t)
            nsteps=length(obj.t);
        else
            fprintf(2,'Fehler in newmark_intergration: t muss ein Vektor sein');
            return;
        end
        
        obj.T_A=obj.t(2)-obj.t(1);
        
            fprintf('LU-Zerlegung...');
            [obj.L,obj.U] = lu(obj.M + (obj.T_A*obj.gamma).*obj.C+(obj.T_A^2*obj.beta).*obj.K);
            obj.ndofin = size(obj.P,2);
            fprintf('beendet.\n');
        end
        
        function [q, qd, qdd] = stepImpl(obj,u)
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
            qdd = qdd_new;
            qd=qd_p+obj.T_A*obj.gamma.*qdd_new;
            q=q_new;
            
            obj.qdd=qdd;
            obj.qd=qd;
            obj.q=q;
        end
        
        function resetImpl(obj)
            % Initialize discrete-state properties.
            obj.q = obj.q_0;
            obj.qd = obj.qd_0;
            obj.qdd = obj.qdd_0;
        end
        
    end
end
