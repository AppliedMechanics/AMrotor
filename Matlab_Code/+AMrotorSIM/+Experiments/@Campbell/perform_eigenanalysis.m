function [V,D] = perform_eigenanalysis(obj,mat)
    opts.tol = 1e-16;
    criteria = true;
    minEigenFreq = 0;%1e-2;
    num.eigenVectors = 4*(obj.num.modes);
    num.modes_local = obj.num.modes + 4; % +4 damit bei stark gedaempften EW immer noch genug EW berechnet werden sodass eine Mindestanzhal an forward und backward-Moden gefunden werden kann
    while criteria
        [V,tmp.lambda]=eigs(-mat.B,mat.A,num.eigenVectors,'sm',opts);        
        %[V,tmp.lambda]=eigs(-mat.B,mat.A,num.eigenVectors,'smallestimag',opts); % gives warning input matrix B is close to singular or badly scaled. Results may be inaccurate. Only gives negative eigenvalues? Why? look at Matlab_code/Tools/BehaviorOfSmallestimag.m which shows a different behavior
        % sortiert lambdas aus, deren imaginaerteil kleiner als minEigenFreq ist
        indicesLambda = abs(imag(diag(tmp.lambda))) >= minEigenFreq; 
        % schoenheitskur fuer lambdas
        tmp.lambda = diag(tmp.lambda);
        tmp.lambda = tmp.lambda(indicesLambda);
        % wenn es noch nicht genuegend lambdas fuer die Moden gibt, die man
        % eigentlich haben will, dann wird die eigenanalyse noch einmal
        % gemacht mit mehr angefragten Werten
        if length(tmp.lambda) < num.modes_local*2
            num.eigenVectors = num.eigenVectors + 10;
        else
            criteria = false;
            V = V(:,indicesLambda);
        end
    end
    % falls es mehr Werte als angefragte Moden sind, dann wird der groesse
    % nach sortiert und die grosse, die zu viel sind, weggeworfen
    if length(tmp.lambda) > num.modes_local*2
        [~,sortOrder] = sort(abs(imag(tmp.lambda)));
        tmp.lambda = tmp.lambda(sortOrder(1:num.modes_local*2));
        V = V(:,sortOrder(1:num.modes_local*2));
        tmp.lambda = tmp.lambda(1:num.modes_local*2);
        V = V(:,1:num.modes_local*2);
    end
    
    % sortiere die EW nach Hoehe des Imaginaerteils
    [~,sortOrder] = sort(abs(imag(tmp.lambda)));
    tmp.lambda = tmp.lambda(sortOrder);%tmp.lambda = tmp.lambda(sortOrder(1:num.modes_local*2));
    V = V(:,sortOrder);%V = V(:,sortOrder(1:num.modes_local*2));
    
    D = tmp.lambda;
end