%%% Utility

VampE = ampE;
VampGs = ampGs;
VampGc = ampGc;
VampGo = ampGo;
VthetaGs = thetaGs;
VthetaGc = thetaGc;
VthetaGo = thetaGo;
Vfreq = freq;

clearvars ampE ampGs ampGc ampGo thetaGs thetaGc thetaGo freq
save('FRF_2.mat', 'VampE','VampGs','VampGc','VampGo','VthetaGs','VthetaGc','VthetaGo','Vfreq');