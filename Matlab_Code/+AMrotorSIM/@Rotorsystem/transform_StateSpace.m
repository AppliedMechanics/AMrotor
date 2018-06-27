 function transform_StateSpace(obj)

    M=obj.systemmatrizen.M; % Masse
    D=obj.systemmatrizen.D; % Dämpfung
    G=obj.systemmatrizen.G; % Gyroskopie
    K=obj.systemmatrizen.K; % Steifigkeit

    n_nodes=length(obj.rotor.nodes);
    dim_ss=8*n_nodes;

    M_inv = M\eye(size(M));
    obj.systemmatrizen.M_inv=M_inv;

    obj.systemmatrizen.ss = sparse([zeros(length(M)),eye(length(M));-M_inv*K,-M_inv*D]);
    obj.systemmatrizen.ss_G = sparse([zeros(length(M)),zeros(length(M));zeros(length(M)),-M_inv*G]);

    %Ergänze StateSpace um Zustand zur Drehzahl integration /
    %Drehmoment

    dim_ss1=dim_ss+2;

    ss_rot = [0,1;0,0];

    ss_temp = zeros(dim_ss1);
    ss_temp1 = zeros(dim_ss1);

    ss_temp1(1:8*n_nodes,1:8*n_nodes)=obj.systemmatrizen.ss_G;
    obj.systemmatrizen.ss_G=sparse(ss_temp1);

    ss_temp(1:dim_ss,1:dim_ss)=obj.systemmatrizen.ss;
    ss_temp(dim_ss+1:dim_ss1,dim_ss+1:dim_ss1)=ss_rot;
    obj.systemmatrizen.ss=sparse(ss_temp);

    %Ergänze StateSpace um Integrationsglieder aus Regelkreisen

    ss = obj.systemmatrizen.ss;

    for i=obj.lager
        if i.cnfg.type==3
        obj.systemmatrizen.ss = i.add_controller_ss(ss,3,obj);
        end
    end
    dim_ss2=length(obj.systemmatrizen.ss);

    %% Lastvektor in SS transformieren

    obj.systemmatrizen.ss_h.h = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h;zeros(dim_ss2-dim_ss,1)]; %andere h-Terme nicht vergessen!
    obj.systemmatrizen.ss_h.h_sin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_sin;zeros(dim_ss2-dim_ss,1)];
    obj.systemmatrizen.ss_h.h_cos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_cos;zeros(dim_ss2-dim_ss,1)];
    obj.systemmatrizen.ss_h.h_ZPsin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_ZPsin;zeros(dim_ss2-dim_ss,1)];
    obj.systemmatrizen.ss_h.h_ZPcos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_ZPcos;zeros(dim_ss2-dim_ss,1)];
    obj.systemmatrizen.ss_h.h_DBsin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_DBsin;zeros(dim_ss2-dim_ss,1)];
    obj.systemmatrizen.ss_h.h_DBcos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_DBcos;zeros(dim_ss2-dim_ss,1)];
    obj.systemmatrizen.ss_h.h_rotsin = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_rotsin;zeros(dim_ss2-dim_ss,1)];
    obj.systemmatrizen.ss_h.h_rotcos = [zeros(length(M),1);M_inv*obj.systemmatrizen.h.h_rotcos;zeros(dim_ss2-dim_ss,1)];


 end