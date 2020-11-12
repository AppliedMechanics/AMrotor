function [M,C,G,K]= assemble_system_matrices(self,rpm,varargin)
% Assembles the specific component matrices to the global matrices
%
%    :param rpm: Rotational speed
%    :type rpm: double
%    :param varargin: Placeholder
%    :return: Global component matrices (M,D,G,K)

% Licensed under GPL-3.0-or-later, check attached LICENSE file

         if nargin == 1
             rpm=0;
         elseif nargin==3
             Z=varargin{1};
         end

%% Rotormatrizen aus FEM erstellen
            
            
            %Lokalisierungsmatrix hat 6x6n 0 Einträge
            %Element L wird dann an der Stelle (i-1)*6 drauf addiert.

            
            
%% Add component matrices
        [M_Comp,D_Comp,G_Comp,K_Comp]= self.get_component_matrices(self.components,rpm);
          
        
%% Add to global matrices
        M = self.rotor.mass_matrix + M_Comp;
        C = self.rotor.damping_matrix + D_Comp ;
        G = self.rotor.gyroscopic_matrix + G_Comp;
        K = self.rotor.stiffness_matrix + K_Comp ;

        
      
end