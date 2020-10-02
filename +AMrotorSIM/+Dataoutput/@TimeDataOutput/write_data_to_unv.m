% Licensed under GPL-3.0-or-later, check attached LICENSE file

function write_data_to_unv(self, postfix)
% Writes the sensor data to unv-files
%
%    :param postfix: Descriptive name
%    :type postfix: string
%    :return: Saved unv-file in results folder in simulation directory

% AMrotorSIM.Dataoutput.TimeDataOutput/write_data_to_universal_file_format
%   write_data_to_unv(self, postfix)
% 
%   See also TIMEDATAOUTPUT, SAVE_DATA, COMPOSE_DATA, COMPOSE_DATA_SENSOR_WISE.
    disp(' --- Write Timesignal to UNV --- ')

    Savepath=([pwd,'\results\',datestr(now,'yyyy-mm-dd')]);
    mkdir(Savepath)
    iter=1;
    while isfile([Savepath '\Simulation-' date '-' postfix '-v' num2str(iter) '.unv'])
        iter=iter+1;
    end
    OutFileName = [Savepath '\Simulation-' date '-' postfix '-v' num2str(iter) '.unv'];
	fid=fopen(OutFileName,'w'); 
    for drehzahl = self.experiment.drehzahlen   

        for sensor = self.rotorsystem.sensors
            [x_val,y_val,z_val]=...
            sensor.read_values(self.experiment);
            
            % x direction
            dx = self.experiment.time;
            Data = x_val(drehzahl);
            FuncType = 1; % TimeData
            Header = makehead(FuncType,Data,dx);
            Header.Unit = sensor.unit;
            Header.Dir = 'X+';
            Header.Title = ['TimeData AMrotor'];
            Header.Title2 = [sensor.name,'_x'];
            Header.Title3 = ['rpm',num2str(drehzahl)];
            Header.xUnit = 's';
            Header.Label = Header.Unit;
            Header.RespId = [num2str(sensor.position),' m (MeshNode: ',num2str(sensor.position),' m)'];
            
            unvw58(fid,0,Data,Header);
            
            % y direction
            Data = y_val(drehzahl);
            Header.Dir = 'Y+';
            Header.Title2 = [sensor.name,'_y'];
            
            % z direction
            Data = z_val(drehzahl);
            Header.Dir = 'Z+';
            Header.Title2 = [sensor.name,'_Z'];
            
            unvw58(fid,0,Data,Header);


        end

    end
    
    fclose(fid);
    
end