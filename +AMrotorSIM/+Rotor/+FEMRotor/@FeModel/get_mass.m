function [m, J]=get_mass(self)
% Provides the translational m ('u_x') and the mass moment of inertia J ('psi_z') 
%
%    :return: Translational mass and mass moment of inertia [m, J]
%    :rtype: double

% Licensed under GPL-3.0-or-later, check attached LICENSE file

u=zeros(6*length(self.mesh.nodes),1);

for node = self.mesh.nodes
  u(self.get_gdof('u_x',node.name))=1;
%  u(self.get_gdof('u_y',node.name))=1;
%  u(self.get_gdof('u_z',node.name))=1;
end

%m=u'*self.matrices.M*u;
m=u'*self.mass_matrix*u;

u=zeros(6*length(self.mesh.nodes),1);

for node = self.mesh.nodes
  u(self.get_gdof('psi_z',node.name))=1;
end

%J=u'*self.matrices.M*u;
J=u'*self.mass_matrix*u;

end