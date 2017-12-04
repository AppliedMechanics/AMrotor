function [V,D] = performEigenAnalysis(obj,mat)
    opts.tol = 1e-7;
    [V,tmp.lambda]=eigs(-mat.B,mat.A,obj.num.modes*2,'sm',opts);
    D=diag(tmp.lambda);
end