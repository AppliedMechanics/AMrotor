% Licensed under GPL-3.0-or-later, check attached LICENSE file

function f=check_rigidbody(self)
% Checks for the translational rigid body modes by calculating the internal forces f
%
%    :return: Internal force f (0 for rigid bodies)
%    :rtype: vector

% Explanation: "A special kind of eigenmode are displacement 
% modes which do not generate internal forces: the rigid body modes u. 
% They satisfy the fundamental relation Ku = 0."
% (Script: Engineering Dynamics, Chap.: 5.1.1)
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

 u=zeros(6*length(self.mesh.nodes),1);

for node = self.mesh.nodes
   u(self.get_gdof('u_x',node.name))=1;
   u(self.get_gdof('u_y',node.name))=1;
   u(self.get_gdof('u_z',node.name))=1;
end

%f=self.matrices.K*u;

f=self.stiffness_matrix*u;

end