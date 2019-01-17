function plot(self,sensors)
disp(self.name)
j = 1;

for sensor = sensors
    
    [x_val,~,y_val,~]=sensor.read_values(self.experiment);
    for rpm = self.experiment.drehzahlen
        t = self.experiment.time;
        input_datax=x_val(rpm);
        input_datay=y_val(rpm);
        rplus=input_datax+1i*input_datay;
        rminus=input_datax-1i*input_datay;
        [f,Rplus(j,:)]=DPS_FFT_C(rplus,t);
        [f,Rminus(j,:)]=DPS_FFT_C(rminus,t);
        
        rpm_vec(j)=self.experiment.drehzahlen(j);
        j=j+1;
    end
    % Umformatierung
    amp_Rplus=abs(Rplus(:,2:end));%*1000;
    amp_Rminus=abs(Rminus(:,2:end));%*1000;
    f=f(2:end);
    % Plot
    figure('name',[sensor.name, ' at position ',num2str(sensor.Position), '; Waterfall'], 'NumberTitle', 'off');
    ffull=[flip(-f(:,1:end/4)) f(:,1:end/4)];
    ampfull=[flip(amp_Rminus(:,1:1:end/4),2) amp_Rplus(:,1:1:end/4)];
    waterfall(ffull,rpm_vec./60,ampfull)
    xlabel('Frequenz [Hz]')
    ylabel('Drehzahl [U/s]')
    zlabel(['Amplitude [', sensor.unit,']'])
    title ('Two Sided Waterfalldiagram')
    colormap( [ 0 0 0 ] )
    axis tight
    %xlim([-300 300]);
    view([12.74 41.52]);
    set(gca,'fontsize',16)
    
end

end