classdef (Abstract) Component < matlab.mixin.Heterogeneous & handle
    % Component Superclass for components that are added to the rotor
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
        %Konstruktor
        function self = Component(arg)
            % create the component and initialize with the cnfg-struct
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