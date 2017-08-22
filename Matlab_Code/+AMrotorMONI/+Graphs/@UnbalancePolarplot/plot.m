function [] = plot( self )
%PLOT Summary of this function goes here
%   Detailed explanation goes here

      disp(self.name)

      a=self.Monitor.InitialCoupledImbalanceMatrix
      b=self.Monitor.RevisedCoupledImbalanceMatrix
      c=self.Monitor.DifferentialCoupledImbalanceMatrix
      
      figure('name',self.name)
      polarplot(a(3),a(2));
      
end

