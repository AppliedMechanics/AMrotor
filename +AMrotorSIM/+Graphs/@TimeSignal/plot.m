function plot(self,sensors,direction)
% plot(self,sensors,direction)
  disp(' --- Plot Graph Timesignal  --- ')
  if ~exist('direction','var')
      direction = [1]; % default x-direction
      warning('no direction specified, using default direction x')
  end
     
      for sensor = sensors
       direction = self.rotorsystem.rotor.mesh.elements.set_dof_number(direction);
       nDir = length(direction);
          
        [x_val,y_val,z_val]=sensor.read_values(self.experiment);


        figure('name',[sensor.name, ' at position ',num2str(sensor.Position), '; Timesignal'], 'NumberTitle', 'off');

        tmp.count = 1;
        for rpm = self.experiment.drehzahlen
            val = cell(size(direction));
            for iDir=1:nDir
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
            
            % subplot
            subplot(nDir,1,iDir);
            hold on
            plot( self.time,val{iDir},...
                            'Color',self.ColorHandler.getColor(tmp.count),...
                            'DisplayName',sprintf('%1.0f 1/min',rpm));
                xlabel('time [s]');
                ylabel([sensor.measurementType,' [',sensor.unit,']']);
                title([sensor.measurementType, ' in ',strDir]); 
                legend('show');
                hold off

            end
            % increment counter
            tmp.count = tmp.count + 1;
        end
      end
end