% Licensed under GPL-3.0-or-later, check attached LICENSE file

function f=check_rigidbody(self)
% Checks for the translational rigid bodies??????????????
%
%    :return: Translational force vector f from rigid body stiffness

 u=zeros(6*length(self.mesh.nodes),1);

for node = self.mesh.nodes
   u(self.get_gdof('u_x',node.name))=1;
   u(self.get_gdof('u_y',node.name))=1;
   u(self.get_gdof('u_z',node.name))=1;
end

%f=self.matrices.K*u;

f=self.stiffness_matrix*u;

end