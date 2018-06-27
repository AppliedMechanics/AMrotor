function compute_matrices(obj)
        [M,G,D,K]=obj.rotor.compute_matrices(); 
        
        for lager = obj.lager
            [matrices.m,matrices.g,matrices.d,matrices.k]=lager.compute_matrices();
            [Ml,Gl,Dl,Kl]=assembling_matrices(lager.cnfg.position,matrices,obj.rotor);
            M=M+Ml; G=G+Gl; D=D+Dl; K=K+Kl;
        end
        
        for disc = obj.discs
            [matrices.m,matrices.g,matrices.d,matrices.k]=disc.compute_matrices();
            [Ml,Gl,Dl,Kl]=assembling_matrices(disc.cnfg.position,matrices,obj.rotor);
            M=M+Ml; G=G+Gl; D=D+Dl; K=K+Kl;
        end
        
        obj.systemmatrizen.M=sparse(M); 
        obj.systemmatrizen.G=sparse(G);
        obj.systemmatrizen.D=sparse(D);
        obj.systemmatrizen.K=sparse(K);

        obj.reduktionsmatrizen.EVmr = sparse(eye(size(M)));
        obj.reduktionsmatrizen.EWmr=0;
      
end