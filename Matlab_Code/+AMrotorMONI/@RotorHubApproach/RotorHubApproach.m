classdef RotorHubApproach < handle
   properties
       cnfg=struct([])
       name
       Initialimbalancematrix
       Revisedimbalancematrix
       Differentialimbalancematrix
       InitialCoupledSchlagMatrix
       RevisedCoupledSchlagMatrix
       DifferentialCoupledSchlagMatrix
       ESF1
   end
   methods
       function obj=RotorHubApproach(a)
         if nargin == 0
           obj.name = 'MonitorPosi';
         else
           obj.name = a;
         end
       end
       
       function obj=initialize(obj,DATASET)
       [obj.Initialimbalancematrix,obj.InitialCoupledSchlagMatrix] = obj.Positionsmessung_Initial(DATASET,obj.ESF1);
       end
       
       function obj=revise(obj,DATASET)
       [obj.Revisedimbalancematrix,obj.Differentialimbalancematrix,obj.RevisedCoupledSchlagMatrix,obj.DifferentialCoupledSchlagMatrix] = obj.Positionsmessung_Revisional(DATASET,obj.ESF1,obj.Initialimbalancematrix,obj.InitialCoupledSchlagMatrix);
       end
       
       function obj=show(obj)
           disp('Initialimbalancematrix:')
           disp(obj.Initialimbalancematrix)
           disp('Revisedimbalancematrix:')
           disp(obj.Revisedimbalancematrix)
           disp('Differentialimbalancematrix:')
           disp(obj.Differentialimbalancematrix)
           disp('InitialCoupledSchlagMatrix:')
           disp(obj.InitialCoupledSchlagMatrix)
           disp('RevisedCoupledSchlagMatix:')
           disp(obj.RevisedCoupledSchlagMatrix)
           disp('DifferentialCoupledSchlagMatrix:')
           disp(obj.DifferentialCoupledSchlagMatrix)
           disp('Name:')
           disp(obj.name)
       end
   end
end