classdef RotorDeflectionApproach < handle
   properties
       cnfg=struct([])
       name
       Initialimbalancematrix
       Revisedimbalancematrix
       Differentialimbalancematrix
       InitialCoupledSchlagMatrix
       RevisedCoupledSchlagMatrix
       DifferentialCoupledSchlagMatrix
       XInitial
       XRevisional
       XDifferential
       ESF1
   end
   methods
       function obj=RotorDeflectionApproach(a)
         if nargin == 0
           obj.name = 'MonitorPosi';
         else
           obj.name = a;
         end
       end
       
       function obj=initialize(obj,DATASET)
       [obj.Initialimbalancematrix,obj.InitialCoupledSchlagMatrix,obj.XInitial] = obj.approximate_initial_failures(DATASET,obj.ESF1);
       end
       
       function obj=revise(obj,DATASET)
       [obj.Revisedimbalancematrix,obj.Differentialimbalancematrix,obj.RevisedCoupledSchlagMatrix,obj.DifferentialCoupledSchlagMatrix,obj.XRevisional,obj.XDifferential] = obj.approximate_additional_failures(DATASET,obj.ESF1,obj.XInitial);
       end
       
       function obj=show(obj)
           disp('-------------- Monitoring Deflection ----------------')
           disp('Name:')
           disp(obj.name)
           disp('--------')
           disp('Initialimbalancematrix:')
           ANZ=[num2str(obj.Initialimbalancematrix(1)),' Zpos m   ' , num2str(obj.Initialimbalancematrix(2)),' m   ',num2str(obj.Initialimbalancematrix(3)),' rad   '];
           disp(ANZ)
           disp('Revisedimbalancematrix:')
           ANZ=[num2str(obj.Revisedimbalancematrix(1)),' Zpos m   ' , num2str(obj.Revisedimbalancematrix(2)),' m   ',num2str(obj.Revisedimbalancematrix(3)),' rad   '];
           disp(ANZ)
           disp('Differentialimbalancematrix:')
           ANZ=[num2str(obj.Differentialimbalancematrix(1)),' Zpos m   ' , num2str(obj.Differentialimbalancematrix(2)),' m   ',num2str(obj.Differentialimbalancematrix(3)),' rad   '];
           disp(ANZ)
           disp(' ')
           disp('InitialCoupledSchlagMatrix:')
           ANZ=[num2str(obj.InitialCoupledSchlagMatrix(1)),' Radius m   ' , num2str(obj.InitialCoupledSchlagMatrix(2)),' rad   '];
           disp(ANZ)
           disp('RevisedCoupledSchlagMatrix:')
           ANZ=[num2str(obj.RevisedCoupledSchlagMatrix(1)),' Radius m   ' , num2str(obj.RevisedCoupledSchlagMatrix(2)),' rad   '];
           disp(ANZ)
           disp('DifferentialCoupledSchlagMatrix:')
           ANZ=[num2str(obj.DifferentialCoupledSchlagMatrix(1)),' Radius m   ' , num2str(obj.DifferentialCoupledSchlagMatrix(2)),' rad   '];
           disp(ANZ)
           disp('------------------------------------------------------')
       end
   end
end