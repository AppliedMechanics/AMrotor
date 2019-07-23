function [ss_h]= compute_system_load_ss(self,t, Z)
% compute the system load in state space form for time integration: h=[0;F]

h_loads = self.assemble_system_loads(t,Z);
h_controllers = self.assemble_system_controller_forces();

%% Put together
h = h_loads + h_controllers;

ss_h=[zeros(length(h),1);h];
         
end