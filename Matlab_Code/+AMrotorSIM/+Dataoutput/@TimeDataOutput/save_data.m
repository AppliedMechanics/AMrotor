function save_data(self,dataset, postfix)

Savepath=([pwd,'\results\',datestr(now,'yyyy-mm-dd')]);
mkdir(Savepath)

iter=1;
while isfile([Savepath '\Simulation-' date '-' postfix '-v' num2str(iter) '.mat'])
      iter=iter+1;
end
save([Savepath '\Simulation-' date '-' postfix '-v' num2str(iter) '.mat'],'dataset')

end