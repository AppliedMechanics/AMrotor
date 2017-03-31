classdef Rotor < handle
   properties
      cnfg=struct([])
      
      name
      nodes
      
      moment_of_inertia
      
      sensors=Sensor().empty
      lager=Lager().empty
   end
   methods
       %Konstruktor
       function obj = Rotor(a)
         if nargin == 0
           obj.name = "Default Rotor";
         else
           obj.cnfg = a;
           obj.name = obj.cnfg.name;
         end
         addpath(strcat(fileparts(which(mfilename)),'\fcns'));
       end
       
       function mesh(obj)
           disp('Mesh ....')
          [obj.nodes] = meshing(obj.cnfg);  %function divide rotor in thin disks 
       end
      
      function print(obj)
         disp(obj.name);
      end
      
      function [M,G,D,K] = compute_matrices(obj)
        [obj.moment_of_inertia] = compute_moment_of_inertia(obj.cnfg); %column_1 cross section area; column_2 I_xi; column_3 I_eta; column_4 I_p; column_5 PhiS
        %massmatrix
        M  = compute_mass_matrix(obj.cnfg,obj.moment_of_inertia, obj.nodes);
        %stiffnesmatrix
        K  = compute_stiffness_matrix(obj.cnfg, obj.moment_of_inertia, obj.nodes);
        %gyroskopie
        G  = 2*compute_gyroscopic_matrix(obj.cnfg, obj.moment_of_inertia, obj.nodes);
        
        n_nodes = length(obj.nodes);

        %D=zeros(n_nodes*4, n_nodes*4);
        D=0.01*M+0.0002*K;
      end
      
      function visu(obj)
         addpath(strcat(fileparts(which(mfilename)),'\..\Graphs\Geometrie'));
         disp('Start visualization');
         Visu_Rotorgeometrie(obj).show();
      end 
      
   end
end