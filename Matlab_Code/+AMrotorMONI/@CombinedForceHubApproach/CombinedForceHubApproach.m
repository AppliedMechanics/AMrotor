classdef CombinedForceHubApproach < handle
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
       function obj=CombinedForceHubApproach(a)
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
           disp('Pure_Initialimbalancematrix:')
           disp(obj.Pure_Initialimbalancematrix)
           disp('Pure_Revisedimbalancematrix:')
           disp(obj.Pure_Revisedimbalancematrix)
           disp('Pure_Differentialimbalancematrix:')
           disp(obj.Pure_Differentialimbalancematrix)
           disp('Pure_InitialSchlagMatrix:')
           disp(obj.Pure_InitialSchlagMatrix)
           disp('Pure_RevisedSchlagMatrix:')
           disp(obj.Pure_RevisedSchlagMatrix)
           disp('Pure_DifferentialSchlagMatrix:')
           disp(obj.Pure_DifferentialSchlagMatrix)
           disp('Pure_InitialKupplungsversatzMatrix:')
           disp(obj.Pure_InitialKupplungsversatzMatrix)
           disp('Pure_RevisedKupplungsversatzMatrix:')
           disp(obj.Pure_RevisedKupplungsversatzMatrix)
           disp('Pure_DifferentialKupplunsveratzMatrix:')
           disp(obj.Pure_DifferentialKupplunsveratzMatrix)
           disp('Name:')
           disp(obj.name)
       end
   end
end