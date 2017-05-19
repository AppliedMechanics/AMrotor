function I = pid_ctrl(t,I,err,d_err,dd_err, Kp,Ki,Kd)

dI = [Kp*d_err(1) + Ki*err(1) + Kd*dd_err(1), Kp*d_err(2) + Ki*err(2) + Kd*dd_err(2)];

I(1:dim(1),1)=dI; 