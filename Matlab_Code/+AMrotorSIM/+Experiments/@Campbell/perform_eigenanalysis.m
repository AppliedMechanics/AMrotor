function [V,D] = perform_eigenanalysis(obj,mat,omega)
    opts.tol = 1e-16;
    criteria = true;
    minEigenFreq = 1e-2;
    num.eigenVectors = 4*(obj.num.modes);
    num.modes_local = obj.num.modes + 4; % +4 damit bei stark gedaempften EW immer noch genug EW berechnet werden sodass eine Mindestanzhal an forward und backward-Moden gefunden werden kann
    while criteria
        if ~mat.singular
        [V,tmp.lambda]=eigs(-mat.B,mat.A,num.eigenVectors,'sm',opts);        
        %[V,tmp.lambda]=eigs(-mat.B,mat.A,num.eigenVectors,'smallestimag',opts); % gives warning input matrix B is close to singular or badly scaled. Results may be inaccurate. Only gives negative eigenvalues? Why? look at Matlab_code/Tools/BehaviorOfSmallestimag.m which shows a different behavior
        else
        %%%Idee: Teste polyeig()%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         [M,C,G,K]= obj.rotorsystem.assemble_system_matrices(omega*60/2/pi);
%         tic
%         [V,tmp.lambda]=polyeig(K,C+omega*G,M);
%         toc
%         tmp.lambda = diag(tmp.lambda); % for compatiblitity with rest of code
%         V = [V, V; V, V]; %for compatiblilty with rest of code
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf(repmat('\b', 1, 69)); % Zeit ausgeben und wieder loeschen, sodass Uebersichtlichkeit erhalten bleibt
        fprintf('\nSystem is singular. Using eig for full system.\n');
        fprintf('Current rpm = %07.0f',60/2/pi*omega)
             %[V,tmp.lambda]=eigs(-mat.B,mat.A,length(mat.B),1,opts); % gibt mir nicht alle EW
             [V,tmp.lambda]=eig(-full(mat.B),full(mat.A)); %gibt alle EW
             num.eigenVectors = length(V);
             num.modes_local = length(V)/2;
             minEigenFreq = 10*2*pi;
             criteria = false;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % compute pseudo-inverse % funktioniert nicht, da singulaer
%         ind1 = 1:rank(full(mat.B));
%         BpseudoInverse = [inv(full(mat.B(ind1,ind1))), zeros(length(ind2)); zeros(length(ind2),length(mat.B))]; %SD p.53
%         powerIterationMatrix=-full(BpseudoInverse*mat.A); %Skript Structural Dynamics p. 67 (power iteration method) % matrix badly scaled
%         [V,tmp.lambda]=eig(powerIterationMatrix);
        end
        % sortiert lambdas aus, deren imaginaerteil kleiner als minEigenFreq ist
        indicesLambda = abs(imag(diag(tmp.lambda))) > minEigenFreq; 
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