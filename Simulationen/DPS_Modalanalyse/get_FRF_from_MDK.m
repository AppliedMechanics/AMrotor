function [H] = get_FRF_from_MDK(r,f,M,D,K,inposition,outposition,Type)

indof = zeros(size(inposition));
outdof = zeros(size(outposition));
for k = 1:length(inposition)
    position = inposition(k);
    node_nr = r.rotor.find_node_nr(position);
    inposition_soll = position;
    indof_real_position=r.rotor.mesh.nodes(node_nr).z;
    delta_in(k) = inposition_soll-indof_real_position;
    indof(k) = (node_nr-1)*6+1;
end
for k = 1:length(outposition)
    position = outposition(k);
    node_nr = r.rotor.find_node_nr(position);
    outposition_soll = position;
    outdof_real_position=r.rotor.mesh.nodes(node_nr).z;
    delta_out(k) = outposition_soll-outdof_real_position;
    outdof(k) = (node_nr-1)*6+1;
end

H = conj(mck2frf(f,M,D,K,indof,outdof,Type));

end