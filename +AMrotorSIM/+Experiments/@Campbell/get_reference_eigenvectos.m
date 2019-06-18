function [EV_for_ref, EV_back_ref] = get_reference_eigenvectos(obj,w)
[mat.A,mat.B] = obj.get_state_space_matrices(w);
[V,D] = obj.perform_eigenanalysis(mat);
Vpos = obj.get_position_entries(V);
[ EV_for_ref, ~, EV_back_ref, ~, ~, ~, ~, ~ ] = ...
    obj.get_separation_eigenvectors(Vpos,D);
end

