classdef (Abstract) Component < matlab.mixin.Heterogeneous & handle
% Superclass (abstract) for all components such as bearings, discs, seals, ecc.
%
% See also AMrotorSIM.Components.Bearings, AMrotorSIM.Components.Seals, AMrotorSIM.Components.Disc, AMrotorSIM.Components.CompLUTMCK, AMrotorSIM.Loads

%that are added to the rotor matrices
%   Component-objects are added to the left-hand side of the system's
%   equations: 
%   (M+M_Component)*xdd + (C+C_Component+ Omega*(G+G_Component))*xd + (K+K_Component)*x = f
%
% for objects, that are added to the right-hand side of the equation see
% the Loads-Superclass
% 
% Licensed under GPL-3.0-or-later, check attached LICENSE file

    properties
        name 
        cnfg
        position
        type
        subtype
        localisation_matrix
        mass_matrix
        damping_matrix
        gyroscopic_matrix
        stiffness_matrix
        color='black'
    end
    methods
        function self = Component(arg)
            % Constructor

            if nargin == 0
                self.name = 'Empty Component';
            else
                self.name = arg.name;
                self.position=arg.position;
                self.type = arg.type;
                self.cnfg = arg;
            end
            
        end
        
    end
    
    methods(Abstract)
        
        print(self)
        
        create_ele_loc_matrix(self)
        
        get_loc_mass_matrix(self,varargin) 
        get_loc_gyroscopic_matrix(self,varargin) 
        get_loc_damping_matrix(self,varargin) 
        get_loc_stiffness_matrix(self,varargin) 
        
    end
    
end