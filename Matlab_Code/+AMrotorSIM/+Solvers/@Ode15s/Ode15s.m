classdef Ode15 < AMrotorSIM.Solvers.Solver
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
        function obj = Ode15(varargin)
            % Support name-value pair arguments when constructing the
            % object.
            setProperties(obj,nargin,varargin{:});
        end
    end
     
    methods (Access = protected)
        %% Common functions
 
        
    end
end
