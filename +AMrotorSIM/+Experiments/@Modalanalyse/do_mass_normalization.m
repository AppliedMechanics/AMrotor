function VMassNormalized = do_mass_normalization(obj,V,M)
% perform mass normalization of the modes, so that transp(V)*M*V=1
modalMasses = diag(transp(V)*M*V);
tmp = 1./sqrt(modalMasses);
VMassNormalized = V*diag(tmp);
end