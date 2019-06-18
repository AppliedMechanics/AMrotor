clear, close all

% EF soll aus Imapct Messung
EFsoll = [22.647, 106.131, 176.616, 215.302]'; % in Hz

raW = 4e-3;
raLvec = (4:0.1:8)*1e-3;%raW*(1:0.2:2);
raSvec = raLvec;
ticGesamt = tic;

disp('fuer free-free-System')
for iraL = 1:length(raLvec)
    for jraS = 1:length(raSvec)
        tic
        raL = raLvec(iraL);
        raS = raLvec(jraS);
        disp(['raL=',num2str(raL*1e3,3),'mm, raS=',num2str(raS*1e3,3),'mm'])
        
        
        import AMrotorSIM.*
        Config_Sim_freefree_verteilteML
        r=Rotorsystem(cnfg,'MLPS-System');
        r.assemble;
        r.show;
        r.rotor.assemble_fem;
        u_trans_rigid_body = r.compute_translational_rigid_body_modes;overall_mass = r.check_overall_translational_mass(u_trans_rigid_body);
        disp(['m=',num2str(overall_mass.m_x,3),'kg']);
        m=Experiments.Modalanalyse(r);
        rpmModalAnalysis=0;
        m.calculate_rotorsystem(16,rpmModalAnalysis);
        
        p = m.eigenValues.lateral([7,10,13,15]); % Waehle relevante EF aus
        EFsim{iraL,jraS} = imag(p)/2/pi;
        DeltaEF{iraL,jraS} = (EFsim{iraL,jraS}-EFsoll);
        DeltaEFgesMatr(iraL,jraS) = mean(DeltaEF{iraL,jraS});
        DeltaEFrel{iraL,jraS} = DeltaEF{iraL,jraS}./EFsoll;
        DeltaEFrelgesCell{iraL,jraS} = mean(DeltaEFrel{iraL,jraS});
        DeltaEFrelgesMatr(iraL,jraS) = mean(DeltaEFrel{iraL,jraS});
        DeltaEFrelgesMatrSquared(iraL,jraS) = mean(DeltaEFrel{iraL,jraS}.^2);
        toc
    end
end
toc(ticGesamt)
save Kennfeld_free_free raLvec raSvec EFsim DeltaEF DeltaEFrel DeltaEFrelgesCell DeltaEFrelgesMatr

% surface plot fuer free-free-System
figure
% surf(raLvec*1e3,raSvec*1e3,DeltaEFrelgesMatr*100)
surf(raLvec*1e3,raSvec*1e3,DeltaEFrelgesMatrSquared*100)
title('free-free-System')
xlabel('raL [mm]')
ylabel('raS [mm]')
zlabel('\Delta RMS EF_{rel,ges} [%]')

figure
surf(raLvec*1e3,raSvec*1e3,DeltaEFrelgesMatr*100)
title('free-free-System')
xlabel('raL [mm]')
ylabel('raS [mm]')
zlabel('\Delta EF_{rel,ges} [%]')

figure
surf(raLvec*1e3,raSvec*1e3,DeltaEFgesMatr)
title('free-free-System')
xlabel('raL [mm]')
ylabel('raS [mm]')
zlabel('\Delta EF_{ges} [Hz]')