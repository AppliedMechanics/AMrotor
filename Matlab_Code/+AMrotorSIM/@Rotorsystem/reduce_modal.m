 function reduce_modal(obj,number_of_modes)
          %disp('Reduzieren auf Moden: '+ number_of_modes)
          
          M=obj.systemmatrizen.M; G=obj.systemmatrizen.G; D=obj.systemmatrizen.D; K=obj.systemmatrizen.K;
          h=obj.systemmatrizen.h;
          [M,K,G,D,h,EVmr,EWmr] = compute_modal_reduction_rotor_only(M,K,G,D,h,number_of_modes,1);
          obj.systemmatrizen.M=M; obj.systemmatrizen.G=G; obj.systemmatrizen.D=D; obj.systemmatrizen.K=K;
          obj.systemmatrizen.h = h;
          
          obj.reduktionsmatrizen.EVmr = EVmr;
          obj.reduktionsmatrizen.EWmr = EWmr;
end