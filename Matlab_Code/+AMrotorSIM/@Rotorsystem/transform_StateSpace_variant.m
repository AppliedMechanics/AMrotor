 function transform_StateSpace_variant(obj)

    M=obj.systemmatrices.M; % Masse
    D=obj.systemmatrices.D; % Dämpfung
    G=obj.systemmatrices.G; % Gyroskopie
    K=obj.systemmatrices.K; % Steifigkeit
    h=obj.systemmatrices.h; % Lastvektor
    
    M_inv = M\eye(size(M));
    %obj.systemmatrizen.M_inv=M_inv;
        
    obj.systemmatrices.ss = sparse([zeros(length(M)),eye(length(M));-M_inv*K,-M_inv*D]);
    obj.systemmatrices.ss_G = sparse([zeros(length(M)),zeros(length(M));zeros(length(M)),-M_inv*G]);
 
    %% Lastvektor in SS transformieren

        fields = fieldnames(h);
        for j=1:numel(fields)
            obj.systemmatrices.ss_h.(fields{j})=[zeros(size(M,1),1);M_inv*h.(fields{j})];
        end

 end