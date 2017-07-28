classdef BearingForceApproach < handle
   properties
       cnfg=struct([])
       name
       InitialCoupledImbalanceMatrix
       RevisedCoupledImbalanceMatrix
       DifferentialCoupledImbalanceMatrix
       InitialKupplungsversatz
       RevisedKupplungsversatz
       DifferentialKupplungsversatz
       Bearing1_Initialforce
       Bearing2_Initialforce 
   end
   methods
       function obj=BearingForceApproach(a)
         if nargin == 0
           obj.name = 'MonitorKraft';
         else
           obj.name = a;
         end
       end
       
       function obj=initialize(obj,DATASET)
       [obj.InitialCoupledImbalanceMatrix,obj.Bearing1_Initialforce,obj.Bearing2_Initialforce,obj.InitialKupplungsversatz] = obj.approximate_initial_failures(DATASET);
       end
       
       function obj=revise(obj,DATASET)
           [obj.RevisedCoupledImbalanceMatrix,obj.DifferentialCoupledImbalanceMatrix,obj.RevisedKupplungsversatz,obj.DifferentialKupplungsversatz] = obj.approximate_additional_failures(DATASET,obj.Bearing1_Initialforce,obj.Bearing2_Initialforce);
       end
       
       function obj=show(obj)
           disp('-------------- Monitoring Force ----------------')
           disp('Name:')
           disp(obj.name)
           disp('------------')
           disp('InitialCoupledImbalanceMatrix:')
           disp(obj.InitialCoupledImbalanceMatrix)
           disp('RevisedCoupledImbalanceMatrix:')
           disp(obj.RevisedCoupledImbalanceMatrix)
           disp('DifferentialCoupledImbalanceMatrix:')
           disp(obj.DifferentialCoupledImbalanceMatrix)
           disp('InitialKupplungsversatz:')
           disp(obj.InitialKupplungsversatz)
           disp('RevisedKupplungsversatz:')
           disp(obj.RevisedKupplungsversatz)
           disp('DifferentialKupplungsversatz:')
           disp(obj.DifferentialKupplungsversatz)
           disp('--------------------------------------------------')
       end
   end
end