classdef Fourierdarstellung < handle
% Fourierdarstellung Class for visualisation of the results of the time
% integration as fouier transform
   properties
    unit
    rotorsystem
    name=' ---  Fourierdarstellung  --- '
    abtastrate
    % See also AMrotorSIM.Experiments.Stationaere_Lsg AMrotorSIM.Experiments.Hochlaufanalyse
    experiment
    % See also AMrotorTools.PlotColors
    ColorHandler
   end
  methods
  function self=Fourierdarstellung(a, experiment)  
      self.rotorsystem = a;
      self.abtastrate = 1/(experiment.time(2)-experiment.time(1));
      self.experiment = experiment;
      self.ColorHandler = AMrotorTools.PlotColors();
      self.ColorHandler.set_up(length(experiment.drehzahlen));
  end
  
  function plot(self,sensors,direction)
% main method for the user
% plot(self,sensors,direction)
      disp(self.name)
      if ~exist('direction','var')
          direction = [1,2]; % default x and y-direction
          warning('no direction specified, using default direction x')
      end
      
          for sensor = sensors
       direction = self.rotorsystem.rotor.mesh.elements.set_dof_number(direction);
       nDir = length(direction);
            
            [x_val,y_val,z_val]=sensor.read_values(self.experiment);
            fs = self.abtastrate;
            
            
            figure('name',[sensor.name, ' at position ',num2str(sensor.position),... 
                '(mesh node ', num2str(sensor.positionMesh),') Fourier'],...
                'NumberTitle', 'off');
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
                    v = val{iDir};
                    [f,~,ampl] = FFT_Data_Gesamt (v,fs);            
                    subplot(nDir,1,iDir);
                        hold on
                        plot(f, ampl,...
                             'Color',self.ColorHandler.getColor(tmp.count),...
                             'DisplayName',sprintf('%1.0f 1/min',rpm));
                         hold off
                    legend('show')
                    xlabel('Frequency [Hz]');
                    ylabel(['Amplitude',sensor.unit]);
                    title(['FFT ',sensor.measurementType, ' in ',strDir]);
                end
                tmp.count = tmp.count + 1;
            end
          end
      end
      
   end
      
end

