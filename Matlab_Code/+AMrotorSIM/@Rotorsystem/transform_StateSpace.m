 function transform_StateSpace(obj)

    M=obj.systemmatrices.M; % Masse
    D=obj.systemmatrices.D; % Dämpfung
    G=obj.systemmatrices.G; % Gyroskopie
    K=obj.systemmatrices.K; % Steifigkeit

    n_nodes=length(obj.rotor.mesh.nodes);
    dim_ss=8*n_nodes;

    obj.systemmatrices.ss_A = [D,M;M,sparse(size(M,1),size(M,2))];
    obj.systemmatrices.ss_B =[K,sparse(size(K,1),size(K,2));sparse(size(M,1),size(M,2)),-M];
    obj.systemmatrices.ss_AG =[G,sparse(size(G,1),size(G,2));...
        sparse(size(G,1),size(G,2)),sparse(size(G,1),size(G,2))];
    obj.systemmatrices.ss_h = sparse(size(obj.systemmatrices.ss_AG,1),1);
    %obj.systemmatrices.ss_h = sparse(1,size(obj.systemmatrices.ss_AG,1));

%      %Ergänze StateSpace um Integrationsglieder aus Regelkreisen
% 
%     ss = obj.systemmatrizen.ss;
% 
%     for i=obj.lager
%         if i.cnfg.type==3
%         obj.systemmatrizen.ss = i.add_controller_ss(ss,3,obj);
%         end
%     end
%     dim_ss2=length(obj.systemmatrizen.ss);
% 
%     %% Lastvektor in SS transformieren
% 
%     obj.systemmatrizen.ss_h.h = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h;zeros(dim_ss2-dim_ss,1)]; %andere h-Terme nicht vergessen!
%     obj.systemmatrizen.ss_h.h_sin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_sin;zeros(dim_ss2-dim_ss,1)];
%     obj.systemmatrizen.ss_h.h_cos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_cos;zeros(dim_ss2-dim_ss,1)];
%     obj.systemmatrizen.ss_h.h_ZPsin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_ZPsin;zeros(dim_ss2-dim_ss,1)];
%     obj.systemmatrizen.ss_h.h_ZPcos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_ZPcos;zeros(dim_ss2-dim_ss,1)];
%     obj.systemmatrizen.ss_h.h_DBsin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_DBsin;zeros(dim_ss2-dim_ss,1)];
%     obj.systemmatrizen.ss_h.h_DBcos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_DBcos;zeros(dim_ss2-dim_ss,1)];
%     obj.systemmatrizen.ss_h.h_rotsin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_rotsin;zeros(dim_ss2-dim_ss,1)];
%     obj.systemmatrizen.ss_h.h_rotcos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_rotcos;zeros(dim_ss2-dim_ss,1)];


 end