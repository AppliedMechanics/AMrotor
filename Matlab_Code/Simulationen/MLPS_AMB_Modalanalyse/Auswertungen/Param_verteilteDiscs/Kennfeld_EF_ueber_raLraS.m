clear, close all

% EF soll aus Imapct Messung
free.EFsoll = [22.647, 106.131, 176.616, 215.302]'; % in Hz

% EF aus MLPS-Messung
supported.EFsoll = [16.7, 103, 165]'; % in Hz

raW = 4e-3;
raLvec = (4:0.02:5.4)*1e-3;%(4:0.2:6)*1e-3;%raW*(1:0.2:2);
raSvec = raLvec;
ticGesamt = tic;


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
        
        free.p = m.eigenValues.lateral([7,10,13,15]); % Waehle relevante EF aus
        free.EFsim{iraL,jraS} = imag(free.p)/2/pi;
        free.DeltaEF{iraL,jraS} = (free.EFsim{iraL,jraS}-free.EFsoll);
        free.DeltaEFgesMatr(iraL,jraS) = mean(free.DeltaEF{iraL,jraS});
        free.DeltaEFrel{iraL,jraS} = free.DeltaEF{iraL,jraS}./free.EFsoll;
        free.DeltaEFrelgesCell{iraL,jraS} = mean(free.DeltaEFrel{iraL,jraS});
        free.DeltaEFrelgesMatr(iraL,jraS) = mean(free.DeltaEFrel{iraL,jraS});
        free.DeltaEFrelgesMatrSquared(iraL,jraS) = mean(free.DeltaEFrel{iraL,jraS}.^2);
        
        
        Config_Sim_eingebaut_verteilteML
        r=Rotorsystem(cnfg,'MLPS-System');
        r.assemble;
        r.show;
        r.rotor.assemble_fem;
        u_trans_rigid_body = r.compute_translational_rigid_body_modes;overall_mass = r.check_overall_translational_mass(u_trans_rigid_body);
        disp(['m=',num2str(overall_mass.m_x,3),'kg']);
        m=Experiments.Modalanalyse(r);
        rpmModalAnalysis=0;
        m.calculate_rotorsystem(16,rpmModalAnalysis);
        
        supported.p = m.eigenValues.lateral([1,8,11]); % Waehle relevante EF aus
        supported.EFsim{iraL,jraS} = imag(supported.p)/2/pi;
        supported.DeltaEF{iraL,jraS} = (supported.EFsim{iraL,jraS}-supported.EFsoll);
        supported.DeltaEFgesMatr(iraL,jraS) = mean(supported.DeltaEF{iraL,jraS});
        supported.DeltaEFrel{iraL,jraS} = supported.DeltaEF{iraL,jraS}./supported.EFsoll;
        supported.DeltaEFrelgesCell{iraL,jraS} = mean(supported.DeltaEFrel{iraL,jraS});
        supported.DeltaEFrelgesMatr(iraL,jraS) = mean(supported.DeltaEFrel{iraL,jraS});
        supported.DeltaEFrelgesMatrSquared(iraL,jraS) = mean(supported.DeltaEFrel{iraL,jraS}.^2);
        toc
    end
end
toc(ticGesamt)
% save Kennfeld_mit_Massenkorrektur raLvec raSvec free supported

% surface plot fuer free-free-System
figure
% surf(raLvec*1e3,raSvec*1e3,DeltaEFrelgesMatr*100)
surf(raLvec*1e3,raSvec*1e3,free.DeltaEFrelgesMatrSquared*100)
title('free-free-System')
xlabel('raL [mm]')
ylabel('raS [mm]')
zlabel('\Delta RMS EF_{rel,ges} [%]')

figure
surf(raLvec*1e3,raSvec*1e3,free.DeltaEFrelgesMatr*100)
title('free-free-System')
xlabel('raL [mm]')
ylabel('raS [mm]')
zlabel('\Delta EF_{rel,ges} [%]')

figure
surf(raLvec*1e3,raSvec*1e3,free.DeltaEFgesMatr)
title('free-free-System')
xlabel('raL [mm]')
ylabel('raS [mm]')
zlabel('\Delta EF_{ges} [Hz]')


figure
surf(raLvec*1e3,raSvec*1e3,supported.DeltaEFrelgesMatrSquared*100)
title('supported-System')
xlabel('raL [mm]')
ylabel('raS [mm]')
zlabel('\Delta RMS EF_{rel,ges} [%]')

figure
surf(raLvec*1e3,raSvec*1e3,(supported.DeltaEFrelgesMatrSquared+free.DeltaEFrelgesMatrSquared)/2*100)
title('frrefree and supported in 1 figure')
xlabel('raL [mm]')
ylabel('raS [mm]')
zlabel('\Delta RMS EF_{rel,ges} [%]')