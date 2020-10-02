% Licensed under GPL-3.0-or-later, check attached LICENSE file

function save_data(self,dataset, postfix)
% Saves the dataset (struct or containers.Map) to a mat-file
%
%    :param dataset: Dataset to save
%    :type dataset: struct/containers.Map
%    :param postfix: Descriptive name
%    :type postfix: string
%    :return: Saved mat-file in results folder in simulation directory

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