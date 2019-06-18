
function [G] = assemble_gyroscopic_matrix(self)
    G = sparse(12,12);
    G_ele = compute_gyroscopic_matrix(self);

    G(5:12,5:12) = G_ele;

    self.gyroscopic_matrix = G;
end