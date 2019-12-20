function plot(self,sensors,direction)
% plot(self,sensors,direction)
disp(self.name)
if ~exist('direction','var')
    direction = [1]; % default x-direction
    warning('no direction specified, using default direction x')
end
j = 1;
F_x={}; Y_x={}; AMPL_x={};
Drehzahl = {}; DZ = [];

for sensor = sensors
    figure('name',[sensor.name, ' at position ',num2str(sensor.Position), '; Waterfall'], 'NumberTitle', 'off');
    direction = self.rotorsystem.rotor.mesh.elements.set_dof_number(direction);
    nDir = length(direction);
    
    [x_val,y_val,z_val]=sensor.read_values(self.experiment);
    for iDir=1:nDir
        j=1;
        for rpm = self.experiment.drehzahlen
            val = cell(size(direction));
            currDirection = direction(iDir);
            switch currDirection
                case {1,4}
                    val{iDir} = x_val(rpm);
                    strDir = 'x';
                case {2,5}
                    val{iDir} = y_val(rpm);
                    strDir = 'y';
                case {3,6}
                    val{iDir} = z_val(rpm);
                    strDir = 'z';
            end
            
            fs = self.abtastrate;
            [f_x,y_x,ampl_x] = FFT_Data_Gesamt (val{iDir},fs);
            F_x{j,1}= f_x;
            Y_x{j,1}= y_x;
            AMPL_x{j,1}= ampl_x;
            
            DZ(1,1:size(f_x,2))=self.experiment.drehzahlen(j);
            
            Drehzahl{j,1}= DZ;
            j = j+1;
        end
        % Umformatierung
        F_x_mat= cell2mat(F_x);
        Y_x_mat= cell2mat(Y_x);
        AMPL_x_mat= cell2mat(AMPL_x);
        
        Drehzahl_mat = cell2mat(Drehzahl);
        % Plot
        subplot(nDir,1,iDir);
        mesh(Drehzahl_mat,F_x_mat,AMPL_x_mat)
        ylim([0,150]);
        xlabel('Drehzahl [U/min]')
        ylabel('Frequenz [Hz]')
        ylim([0 150]);
        zlabel(['Amplitude [', sensor.unit,']'])
        title (['Waterfalldiagramm of ',strDir,'-values'])
        
    end
end
end