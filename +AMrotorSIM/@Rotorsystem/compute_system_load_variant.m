function [ss_h]= compute_system_load_variant(self,t, Z)

h_loads = self.assemble_system_loads(t,Z);
h_controllers = self.assemble_system_controller_forces();

%% Put together
h = h_loads + h_controllers;

ss_h=[zeros(length(h),1);h];
         
end