 function transform_StateSpace(obj)

    M=obj.systemmatrices.M; % Masse
    D=obj.systemmatrices.D; % Dämpfung
    G=obj.systemmatrices.G; % Gyroskopie
    K=obj.systemmatrices.K; % Steifigkeit
    h=obj.systemmatrices.h; % Lastvektor
    
    obj.systemmatrices.ss_A = [D,M;M,sparse(size(M,1),size(M,2))];
    obj.systemmatrices.ss_B =[K,sparse(size(K,1),size(K,2));sparse(size(M,1),size(M,2)),-M];
    obj.systemmatrices.ss_AG =[G,sparse(size(G,1),size(G,2));...
        sparse(size(G,1),size(G,2)),sparse(size(G,1),size(G,2))];
 
    %% Lastvektor in SS transformieren

        fields = fieldnames(h);
        for j=1:numel(fields)
            obj.systemmatrices.ss_h.(fields{j})=[h.(fields{j});zeros(size(M,1),1)];
        end

 end