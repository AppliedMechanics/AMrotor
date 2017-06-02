function [M,K,G,D,h,EVmr,EWmr] = compute_modal_reduction_rotor_only(M,K,G,D,h,moden,modal_reduction)


n=size(M);

if modal_reduction ==1
    
 [EVmr,EWmr]=eigs(K,M,moden,'sm');
     
% [EWmr,I]=sort(diag(EWmr),'descend');
%  EVmr =EVmr(:,I);      

   %Rotor
   M = EVmr'*M*EVmr;
   K = EVmr'*K*EVmr;
   G = EVmr'*G*EVmr;
   D = EVmr'*D*EVmr;
   
   %Kraefte
   h.h       = EVmr'*h.h;
   h.h_ZPsin = EVmr'*h.h_ZPsin;
   h.h_ZPcos = EVmr'*h.h_ZPcos;
   
   h.h_DBsin = EVmr'*h.h_DBsin;
   h.h_DBcos = EVmr'*h.h_DBcos;
   
   h.h_sin = EVmr'*h.h_sin;
   h.h_cos = EVmr'*h.h_cos;
   
   h.h_rotsin = EVmr'*h.h_rotsin;
   h.h_rotcos = EVmr'*h.h_rotcos;
    
else

    if modal_reduction==0
   
    EVmr=eye(n(1),n(2));
    EWmr=0;

    else
        
    disp('modal_reduction: ')
        disp(modal_reduction)
        error('set modal reduction = 1 or 0');
    end

end


