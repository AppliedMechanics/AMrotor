function write_data_to_unv(self, postfix)
% write_data_to_unv writes the sensor data to unv-files
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

    for drehzahl = self.experiment.drehzahlen 
        fid=fopen(OutFileName,'w');        

        for sensor = self.rotorsystem.sensors
            [x_val,~,y_val,~]=...
            sensor.read_values(self.experiment);
            
            fid=fopen(OutFileName,'a');
            
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
            Header.RespId = [num2str(sensor.Position),' m'];
            
            unvw58(fid,0,Data,Header);
            
            fclose(fid);
            fid=fopen(OutFileName,'a'); 
            
            % y direction
            Data = y_val(drehzahl);
            Header.Dir = 'Y+';
            Header.Title2 = [sensor.name,'_y'];
            
            unvw58(fid,0,Data,Header);
            
            fclose(fid);
            fid=fopen(OutFileName,'a');

        end

    end
    
    fclose(fid);
    
end