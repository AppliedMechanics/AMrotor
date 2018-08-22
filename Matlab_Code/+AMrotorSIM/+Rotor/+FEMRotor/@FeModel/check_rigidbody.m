function f=check_rigidbody(self)

 u=zeros(6*length(self.mesh.nodes),1);

for node = self.mesh.nodes
   u(self.get_gdof('u_x',node.name))=1;
   u(self.get_gdof('u_y',node.name))=1;
   u(self.get_gdof('u_z',node.name))=1;
end

f=self.matrices.K*u;

end