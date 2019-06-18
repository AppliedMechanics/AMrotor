classdef MuszynskaTurbulentSeal < AMrotorSIM.Loads.Load
   properties
   end
   methods
        function self=MuszynskaTurbulentSeal(arg)
            self = self@AMrotorSIM.Loads.Load(arg);
            if nargin == 0
            self.name = 'Empty Seal Load';
            else
            self.cnfg = arg;
            self.name = self.cnfg.name;
            self.position=self.cnfg.position;
            end

        end 
        [ Koeff ] = MuszynskaModelNew( self,sys,init )
        [residual] = residuumBernardo(lambda,sys, init)
   end
end