function [ss_h]= compute_system_load_ss(self, t, Z)
% Computes the system load in state space form for time integration: h=[0;F]
%
%    :param t: Time step
%    :type t: double
%    :parameter Z: State-space vector [x; x_dot]
%    :type Z: vector(double)
%    :return: Load vector

% Licensed under GPL-3.0-or-later, check attached LICENSE file

h_loads = self.assemble_system_loads(t,Z);
h_controllers = self.assemble_system_controller_forces(t,Z);

%% Put together
h = h_loads + h_controllers;

ss_h=[zeros(length(h),1);h];
         
end