classdef BearingForceApproach < handle
   properties
       cnfg=struct([])
       Debugging
       name
       InitialAchsversatz
       InitialCoupledImbalanceMatrix
       RevisedCoupledImbalanceMatrix
       DifferentialCoupledImbalanceMatrix
       InitialKupplungsversatz
       RevisedKupplungsversatz
       DifferentialKupplungsversatz
       Bearing1_Initialforce
       Bearing2_Initialforce
       Bearing1_Revisionalforce
       Bearing2_Revisionalforce
       Bearing1_Differentialforce
       Bearing2_Differentialforce
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
       [obj.Bearing1_Initialforce,obj.Bearing2_Initialforce,obj.InitialCoupledImbalanceMatrix,obj.InitialKupplungsversatz,obj.InitialAchsversatz] = obj.approximate_initial_failures(DATASET);
       end
       
       function obj=revise(obj,DATASET)
           [obj.Bearing1_Revisionalforce,obj.Bearing2_Revisionalforce,obj.Bearing1_Differentialforce,obj.Bearing2_Differentialforce,obj.RevisedCoupledImbalanceMatrix,obj.DifferentialCoupledImbalanceMatrix,obj.RevisedKupplungsversatz,obj.DifferentialKupplungsversatz] = obj.approximate_additional_failures(DATASET,obj.Bearing1_Initialforce,obj.Bearing2_Initialforce);
       end
       
       function obj=show(obj)
           disp('-------------- Monitoring Force ----------------')
           disp('Name:')
           disp(obj.name)
           disp('------------')
           disp('InitialAchsversatz:');
           ANZ=[num2str(obj.InitialAchsversatz(1)),' Zpos m   ' , num2str(obj.InitialAchsversatz(2)),' N   ',num2str(obj.InitialAchsversatz(3)),' rad  '];
           disp(ANZ)
           disp(' ')
           disp('InitialCoupledImbalanceMatrix:');
           ANZ=[num2str(obj.InitialCoupledImbalanceMatrix(1)),' Zpos m   ' , num2str(obj.InitialCoupledImbalanceMatrix(2)),' kgm   ',num2str(obj.InitialCoupledImbalanceMatrix(3)),' rad  '];
           disp(ANZ)
           disp('RevisedCoupledImbalanceMatrix:')
           ANZ=[num2str(obj.RevisedCoupledImbalanceMatrix(1)),' Zpos m   ' , num2str(obj.RevisedCoupledImbalanceMatrix(2)),' kgm   ',num2str(obj.RevisedCoupledImbalanceMatrix(3)),' rad   '];
           disp(ANZ)
           disp('DifferentialCoupledImbalanceMatrix:')
           ANZ=[num2str(obj.DifferentialCoupledImbalanceMatrix(1)),' Zpos m   ' , num2str(obj.DifferentialCoupledImbalanceMatrix(2)),' kgm   ',num2str(obj.DifferentialCoupledImbalanceMatrix(3)),' rad   '];
           disp(ANZ)
           disp(' ')
           disp('InitialKupplungsversatz:')
           ANZ=[num2str(obj.InitialKupplungsversatz(1)),' Zpos m   ' , num2str(obj.InitialKupplungsversatz(2)),' N   ',num2str(obj.InitialKupplungsversatz(3)),' rad   '];
           disp(ANZ)
           disp('RevisedKupplungsversatz:')
           ANZ=[num2str(obj.RevisedKupplungsversatz(1)),' Zpos m   ' , num2str(obj.RevisedKupplungsversatz(2)),' N   ',num2str(obj.RevisedKupplungsversatz(3)),' rad   '];
           disp(ANZ)
           disp('DifferentialKupplungsversatz:')
           ANZ=[num2str(obj.DifferentialKupplungsversatz(1)),' Zpos m   ' , num2str(obj.DifferentialKupplungsversatz(2)),' N   ',num2str(obj.DifferentialKupplungsversatz(3)),' rad   '];
           disp(ANZ)
           disp('--------------------------------------------------')
           
       end
   end
end