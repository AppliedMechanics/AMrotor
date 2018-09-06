 function compute_euler_ss(obj)

    Timer = AMrotorTools.Timer();

    disp('Compute.... Forward Euler - State Space ....')
    obj.clear_time_result()

%-----EULER ------------------------------------------------------     
ss_A = obj.rotorsystem.systemmatrices.ss_A;
ss_B = obj.rotorsystem.systemmatrices.ss_B;
h_ges=sparse(2040,1);
h_ges(601)=10;

time=obj.time;
Z0 = zeros(length(ss_A),1);

x=zeros(length(Z0),length(time));
x(:,1)=0;
dt=time(2)-time(1);
for i=2:length(time)
    x(:,i)=x(:,i-1)+dt*(-ss_A\ss_B*x(:,i-1)+ss_A\h_ges);
    plot(x(1:6:end/2,i))
    drawnow
end
Z=x;
%------------------------------------------------------------------

disp(['... spent time for integration: ',num2str(Timer.getWallTime()),' s'])
        
        res.X = Z(1:6*n_nodes,:);
        res.X_d = Z(6*n_nodes+1:2*6*n_nodes,:);
        
        obj.result(drehzahl)=res;

 end