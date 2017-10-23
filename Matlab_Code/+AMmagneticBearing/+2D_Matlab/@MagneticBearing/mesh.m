function [Ausgabe,GitterZellen ] = mesh( self )
%MESH Summary of this function goes here
%   Detailed explanation goes here


%generateMesh(self.model,'MesherVersion','R2013a');
generateMesh(self.model)
[p,e,t]=meshToPet(self.model.Mesh); % points, edges (die mit Koerperkante zusammenfallen), triangles

GitterZellen=size(t,2);

end

