classdef CombinedForceDeflectionApproach < handle
   properties
       cnfg=struct([])
       name
       
      
       Forcebased_KupplungsversatzMatrix
       Forcebased_ComparativeImbalanceMatrix
       Forcebased_SchlagMatrix
       Forcebased_ImbalanceMatrix
       
       Deflectionbased_KupplungsversatzMatrix
       Deflectionbased_SchlagMatrix
       Deflectionbased_ComparativeKupplungsversatzMatrix
       Deflectionbased_ImbalanceMatrix
       
       
       
       
   end
   methods
       function obj=CombinedForceDeflectionApproach(a)
         if nargin == 0
           obj.name = 'MonitorKombi';
         else
           obj.name = a;
         end
       end
       
       function obj=calculation(obj,XInitial,Bearing1_Initialforce,Bearing2_Initialforce)
           disp('Initial Calculation')

       [obj.Deflectionbased_ImbalanceMatrix,obj.Deflectionbased_SchlagMatrix,obj.Deflectionbased_ComparativeKupplungsversatzMatrix,obj.Deflectionbased_KupplungsversatzMatrix] = calculate_Deflectionbased(obj,XInitial,Bearing1_Initialforce,Bearing2_Initialforce);  
           
       [obj.Forcebased_KupplungsversatzMatrix, obj.Forcebased_SchlagMatrix, obj.Forcebased_ComparativeImbalanceMatrix, obj.Forcebased_ImbalanceMatrix] = obj.calculate_Forcebased(XInitial,Bearing1_Initialforce,Bearing2_Initialforce);
       end
       
       
       function obj=show(obj)
           disp('-------------- Monitoring Deflection & Force Combination ----------------')
           disp('Name:')
           disp(obj.name)
           disp('------------------------------')
           disp('Forcebased Calculation')
           disp('++++++++++++++++++++++++++')
           disp('Pure_Kupplungsversatz:')
           ANZ=[num2str(obj.Forcebased_KupplungsversatzMatrix(1)),' m   ' , num2str(obj.Forcebased_KupplungsversatzMatrix(2)),' N   ',num2str(obj.Forcebased_KupplungsversatzMatrix(3)),' rad   '];
           disp(ANZ)
           disp('Pure_ComparrativeImbalance:')
           ANZ=[num2str(obj.Forcebased_ComparativeImbalanceMatrix(1)),' m   ' , num2str(obj.Forcebased_ComparativeImbalanceMatrix(2)),' g m   ',num2str(obj.Forcebased_ComparativeImbalanceMatrix(3)),' rad   '];
           disp(ANZ)
           disp('Pure_Schlag:')
           ANZ=[num2str(obj.Forcebased_SchlagMatrix(1)),' Radius m   ' , num2str(obj.Forcebased_SchlagMatrix(2)),' rad   '];
           disp(ANZ)
           disp('Pure_Imbalance:')
           ANZ=[num2str(obj.Forcebased_ImbalanceMatrix(1)),' m   ' , num2str(obj.Forcebased_ImbalanceMatrix(2)),' g m   ',num2str(obj.Forcebased_ImbalanceMatrix(3)),' rad   '];
           disp(ANZ)
           disp('------------------------------------')
           
           disp('Deflectionbased Calculation')
           disp('+++++++++++++++++++++++++++++++')
           disp('Pure_Kupplungsversatz:')
           ANZ=[num2str(obj.Deflectionbased_KupplungsversatzMatrix(1)),' m   ' , num2str(obj.Deflectionbased_KupplungsversatzMatrix(2)),' N   ',num2str(obj.Deflectionbased_KupplungsversatzMatrix(3)),' rad   '];
           disp(ANZ)
           disp('Pure_Schlag:')
           ANZ=[num2str(obj.Deflectionbased_SchlagMatrix(1)),' Radius m   ' , num2str(obj.Deflectionbased_SchlagMatrix(2)),' rad   '];
           disp(ANZ)
           disp('Pure_ComparrativeKupplungsversatz:')
           ANZ=[num2str(obj.Deflectionbased_ComparativeKupplungsversatzMatrix(1)),' m   ' , num2str(obj.Deflectionbased_ComparativeKupplungsversatzMatrix(2)),' N   ',num2str(obj.Deflectionbased_ComparativeKupplungsversatzMatrix(3)),' rad   '];
           disp(ANZ)
           disp('Pure_Imbalance:')
           ANZ=[num2str(obj.Deflectionbased_ImbalanceMatrix(1)),' m   ' , num2str(obj.Deflectionbased_ImbalanceMatrix(2)),' g m   ',num2str(obj.Deflectionbased_ImbalanceMatrix(3)),' rad   '];
           disp(ANZ)
       end
   end
end