function [x,y] = read_signal(self,sensors,rpm)

for sensor = sensors
    
    [x_val,~,y_val,~]=...
        sensor.read_values(self.experiment);
    x = x_val(rpm);
    y = y_val(rpm);
end

end