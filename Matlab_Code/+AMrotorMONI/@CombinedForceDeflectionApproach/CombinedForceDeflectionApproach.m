classdef CombinedForceDeflectionApproach < handle
   properties
       cnfg=struct([])
       name
       Pure_Initialimbalancematrix
       Pure_Revisedimbalancematrix
       Pure_Differentialimbalancematrix
       Pure_InitialSchlagMatrix
       Pure_RevisedSchlagMatrix
       Pure_DifferentialSchlagMatrix
       Pure_InitialKupplungsversatzMatrix
       Pure_RevisedKupplungsversatzMatrix
       Pure_DifferentialKupplunsveratzMatrix
       
   end
   methods
       function obj=CombinedForceDeflectionApproach(a)
         if nargin == 0
           obj.name = 'MonitorKombi';
         else
           obj.name = a;
         end
       end
       
       function obj=initialize(obj)
       [obj.Pure_Initialimbalancematrix,obj.Pure_InitialSchlagMatrix,obj.Pure_InitialKupplungsversatzMatrix] = obj.InitialCombinedApproach();
       end
       
       function obj=revise(obj)
       [obj.Pure_Revisedimbalancematrix,obj.Pure_Differentialimbalancematrix,obj.Pure_RevisedSchlagMatrix,obj.Pure_DifferentialSchlagMatrix,obj.Pure_RevisedKupplungsversatzMatrix,obj.Pure_DifferentialKupplunsveratzMatrix] = obj.RevisionalCombinedApproach();
       end
       
       function obj=show(obj)
           disp('-------------- Monitoring Deflection & Force Combination ----------------')
           disp('Name:')
           disp(obj.name)
           disp('---------')
           disp('Pure_Initialimbalancematrix:')
           ANZ=[num2str(obj.Pure_Initialimbalancematrix(1)),' m   ' , num2str(obj.Pure_Initialimbalancematrix(2)),' g m   ',num2str(obj.Pure_Initialimbalancematrix(3)),' rad   '];
           disp(ANZ)
           disp('Pure_Revisedimbalancematrix:')
           ANZ=[num2str(obj.Pure_Revisedimbalancematrix(1)),' m   ' , num2str(obj.Pure_Revisedimbalancematrix(2)),' g m   ',num2str(obj.Pure_Revisedimbalancematrix(3)),' rad   '];
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