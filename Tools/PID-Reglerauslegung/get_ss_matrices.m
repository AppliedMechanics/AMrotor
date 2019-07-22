%% get state-space-matrix for simulink model
% used for tuning of the pid-values
rpm = 0;
[A,B,C,D] = r.compute_state_space_for_controller(rpm/60*2*pi);
save('systemmatricesSS','A','B','C','D','rpm')
clear A B C D rpm