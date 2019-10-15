function save_data(self,dataset, postfix)
% SAVE_DATA saves the data set to a mat-file
% AMrotorSIM.Dataoutput.TimeDataOutput/save_data 
%    save_data(self,dataset, postfix)
%
%   See also TIMEDATAOUTPUT, COMPOSE_DATA.
Savepath=([pwd,'\results\',datestr(now,'yyyy-mm-dd')]);
mkdir(Savepath)

switch class(dataset)
    case 'struct' 
        typeIdentifier = 'Struct';
    case 'containers.Map'
        typeIdentifier = 'Map';
    otherwise
        typeIdentifier = '';
end

iter=1;
while isfile([Savepath '\Simulation-' date '-' typeIdentifier '-' postfix '-v' num2str(iter) '.mat'])
      iter=iter+1;
end
save([Savepath '\Simulation-' date '-' typeIdentifier '-' postfix '-v' num2str(iter) '.mat'],'dataset')

end