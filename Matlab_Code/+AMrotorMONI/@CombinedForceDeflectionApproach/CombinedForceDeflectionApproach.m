classdef CombinedForceDeflectionApproach < handle
   properties
       cnfg=struct([])
       name
       
       Init.Imbalancebased_Imbalancematrix
       Init.Imbalancebased_SchlagMatrix
       Init.Imbalancebased_ComparativeKupplungsversatzMatrix
       Init.Imbalancebased_KupplungsversatzMatrix
       
       Init.Kupplungsbased_KupplungsversatzMatrix
       Init.Kupplungsbased_SchlagMatrix
       Init.Kupplungsbased_ComparativeImbalancematrix
       Init.Kupplungsbased_Imbalancematrix
       
%        Revise_Imbalancebased_Imbalancematrix
%        Revise_Imbalancebased_SchlagMatrix
%        Revise_Imbalancebased_KupplungsversatzMatrix
%        Revise_Imbalancebased_ComparativeImbalancematrix
%        
%        Revise_Kupplungsbased_KupplungsversatzMatrix
%        Revise_Kupplungsbased_SchlagMatrix
%        Revise_Kupplungsbased_Imbalanvcematrix
%        Revise_Kupplungsbased_ComparativeKupplungsversatzMatrix
%        
%        Diff_Imbalancebased_Imbalancematrix
%        Diff_Imbalancebased_SchlagMatrix
%        Diff_Imbalancebased_KupplungsversatzMatrix
%        Diff_Imbalancebased_ComparativeImbalancematrix
%        
%        DIff_Kupplungsbased_KupplungsversatzMatrix
%        Diff_Kupplungsbased_SchlagMatrix
%        Diff_Kupplungsbased_Imbalanvcematrix
%        Diff_Kupplungsbased_ComparativeKupplungsversatzMatrix
       
   end
   methods
       function obj=CombinedForceDeflectionApproach(a)
         if nargin == 0
           obj.name = 'MonitorKombi';
         else
           obj.name = a;
         end
       end
       function obj=initialize(obj,XInitial,Bearing1_Initialforce,Bearing2_Initialforce)
           disp('Iniial Calculation')
       [obj.Init.Imbalancebased_Imbalancematrix
       obj.Init.Imbalancebased_SchlagMatrix
       obj.Init.Imbalancebased_ComparativeKupplungsversatzMatrix
       obj.Imbalancebased_KupplungsversatzMatrix] = obj.calculate_Imbalancebased(XInitial,Bearing1_Initialforce,Bearing2_Initialforce);
       
       [obj.Init.Kupplungsbased_KupplungsversatzMatrix
       obj.Init.Kupplungsbased_SchlagMatrix
       obj.Init.Kupplungsbased_ComparativeImbalancematrix
       obj.Init.Kupplungsbased_Imbalancematrix] = obj.calculate_Kupplungsbased(XInitial,Bearing1_Initialforce,Bearing2_Initialforce);
       end
       
       
       function obj=showInitialisation(obj)
           disp('-------------- Monitoring Deflection & Force Combination ----------------')
           disp('Name:')
           disp(obj.name)
           disp('---------')
           disp('Pure_Initialimbalancematrix:')
           ANZ=[num2str(obj.Imbalancebased_Imbalancematrix(1)),' m   ' , num2str(obj.Imbalancebased_Imbalancematrix(2)),' g m   ',num2str(obj.Imbalancebased_Imbalancematrix(3)),' rad   '];
           disp(ANZ)
           disp('Pure_Revisedimbalancematrix:')
           ANZ=[num2str(obj.Imbalancebased_SchlagMatrix(1)),' m   ' , num2str(obj.Imbalancebased_SchlagMatrix(2)),' g m   '];
           disp(ANZ)
           disp('Pure_Differentialimbalancematrix:')
           ANZ=[num2str(obj.Pure_Differentialimbalancematrix(1)),' m   ' , num2str(obj.Pure_Differentialimbalancematrix(2)),' g m   ',num2str(obj.Pure_Differentialimbalancematrix(3)),' rad   '];
           disp(ANZ)
           disp('Pure_InitialSchlagMatrix:')
           ANZ=[num2str(obj.Pure_InitialSchlagMatrix(1)),' Radius m   ' , num2str(obj.Pure_InitialSchlagMatrix(2)),' rad   '];
           disp(ANZ)
           disp('Pure_RevisedSchlagMatrix:')
           ANZ=[num2str(obj.Pure_RevisedSchlagMatrix(1)),' Radius m   ' , num2str(obj.Pure_RevisedSchlagMatrix(2)),' rad   '];
           disp(ANZ)
           disp('Pure_DifferentialSchlagMatrix:')
           ANZ=[num2str(obj.Pure_DifferentialSchlagMatrix(1)),' Radius m   ' , num2str(obj.Pure_DifferentialSchlagMatrix(2)),' rad   '];
           disp(ANZ)
           disp('Pure_InitialKupplungsversatzMatrix:')
           ANZ=[num2str(obj.Pure_InitialKupplungsversatzMatrix(1)),' m   ' , num2str(obj.Pure_InitialKupplungsversatzMatrix(2)),' KvBkv   ',num2str(obj.Pure_InitialKupplungsversatzMatrix(3)),' rad   '];
           disp(ANZ)
           disp('Pure_RevisedKupplungsversatzMatrix:')
           ANZ=[num2str(obj.Pure_RevisedKupplungsversatzMatrix(1)),' m   ' , num2str(obj.Pure_RevisedKupplungsversatzMatrix(2)),' KvBkv   ',num2str(obj.Pure_RevisedKupplungsversatzMatrix(3)),' rad   '];
           disp(ANZ)
           disp('Pure_DifferentialKupplunsveratzMatrix:')
           ANZ=[num2str(obj.Pure_DifferentialKupplunsveratzMatrix(1)),' m   ' , num2str(obj.Pure_DifferentialKupplunsveratzMatrix(2)),' KvBkv   ',num2str(obj.Pure_DifferentialKupplunsveratzMatrix(3)),' rad   '];
           disp(ANZ)
           disp('---------------------------------------------------')
       end
   end
end