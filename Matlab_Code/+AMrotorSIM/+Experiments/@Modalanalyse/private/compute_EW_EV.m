function [Aev,Aew,EVrot,EWrot] = compute_EW_EV(omega,n_ew,K,G,M,n_nodes)

s1=1;
s2=n_ew;
c=zeros(n_ew,1);

for n=0:n_ew-1
    
    c(1+n)=n_ew-n;
    
end


Aev=zeros(4*n_nodes,n_ew*length(omega));

Aew=zeros(2*n_ew,length(omega));


for n1 = 1:length(omega)
    
    G_rot = G.*omega(n1);
    
    [EVrot,EWrot] = polyeig(K,G_rot,M);
    
   [~,I]=sort((abs(EWrot())));
%    
     EWrot=EWrot(I);
%     
%     
%     EVrot = EVrot(:,I);
    

    Aev(:,s1:s2)=  EVrot(:,end/2 - 2*n_ew + 1:2:end/2);
    
    Aev(:,s1:s2) = Aev(:,c);
    
    Aew(1:n_ew*2,n1)= Aew(1:n_ew*2,n1) + EWrot((1:2:4*n_ew),:);
    
    s1=s1+n_ew;
    s2=s1+n_ew-1;
end

