function [ss_h]= compute_system_load_variant(self,t, Z, omega)

h_loads = self.assemble_system_loads(t,Z,omega);
% self.assemble_invariant_system_loads;
% self.assemble_timevariant_system_loads(t);
% h_bearing = self.assemble_bearing_loads(Z,omega);

%% Put together
h = h_loads; % +h_bearing

ss_h=[zeros(length(h),1);h];
         
end