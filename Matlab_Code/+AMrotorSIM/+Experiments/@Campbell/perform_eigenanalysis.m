function [V,D] = perform_eigenanalysis(obj,mat)
    opts.tol = 1e-16;
    criteria = true;
    num.eigenVectors = 4*(obj.num.modes);
    while criteria
        [V,tmp.lambda]=eigs(-mat.B,mat.A,num.eigenVectors,'sm',opts);
        % sortiert lambdas aus, deren imaginaerteil kleiner al 1e-2 ist
        indicesLambda = abs(imag(diag(tmp.lambda))) > 1e-2; 
        % schoenheitskur fuer lambdas
        tmp.lambda = diag(tmp.lambda);
        tmp.lambda = tmp.lambda(indicesLambda);
        % wenn es noch nicht genuegend lambdas fuer die Moden gibt, die man
        % eigentlich haben will, dann wird die eigenanalyse noch einmal
        % gemacht mit mehr angefragten Werten
        if length(tmp.lambda) < obj.num.modes*2
            num.eigenVectors = num.eigenVectors + 10;
        else
            criteria = false;
            V = V(:,indicesLambda);
        end
    end
    % falls es mehr Werte als angefragte Moden sind, dann wird der groesse
    % nach sortiert und die grosse, die zu viel sind, weggeworfen
    if length(tmp.lambda) > obj.num.modes*2
%         [~,sortOrder] = sort(abs(imag(tmp.lambda)));
%         tmp.lambda = tmp.lambda(sortOrder(1:obj.num.modes*2));
%         V = V(:,sortOrder(1:obj.num.modes*2));
        tmp.lambda = tmp.lambda(1:obj.num.modes*2);
        V = V(:,1:obj.num.modes*2);
    end
    
    % sortiere die EW nach Hoehe des Imaginaerteils
    [~,sortOrder] = sort(abs(imag(tmp.lambda)));
    tmp.lambda = tmp.lambda(sortOrder(1:obj.num.modes*2));
    V = V(:,sortOrder(1:obj.num.modes*2));
    
    D = tmp.lambda;
end