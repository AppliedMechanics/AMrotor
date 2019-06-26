classdef Frequenzgangfunktion < handle
% Frequenzgangfunktion Class for visualisation of the frequency response
% function
    properties
        Name = 'Visualisierung Frequenzgangfunktion';
        experimentFRF;
        ColorHandler
    end
    
    methods (Access = public)
        function self = Frequenzgangfunktion(experimentFRF)
            if nargin == 0
                disp(['Without a frequency response function analysis a '...
                    'visualisation of the frequency response function'...
                    'is not possible'])
            else
                self.experimentFRF = experimentFRF;
            end
        end
        
        function set_plots(obj,Selection,inputDirection,outputDirection,varargin)
            obj.set_color_number();
            paramPlot.angleMeasure = obj.set_angle_measure(varargin);
            paramPlot.amplitudeMeasure = obj.set_amplitude_measure(varargin);
            % inputDirection, outputDirection: 'u_x','u_y','u_z','psi_x','psi_y','psi_z'
            paramPlot.inputDirection = obj.set_dof_number(inputDirection);
            paramPlot.outputDirection = obj.set_dof_number(outputDirection);
            
            [f,frf,paramPlot.inLocDof,paramPlot.outLocDof] = obj.get_frf(paramPlot);% get f, frf for selected in out directions
            switch Selection
                case {'Nyquist','nyquist','N','n'}
                    obj.plot_nyquist(f,frf,paramPlot);
                case {'Bode','bode','b','B'}
                    obj.plot_bode(f,frf,paramPlot);
                case {'Amplitude','amplitude','Amp','amp','A','a'}
                    obj.plot_amplitude(f,frf,paramPlot);
                case {'Phase','phase','Ph','ph','P','p','Angle','angle'}
                    obj.plot_phase(f,frf,paramPlot);
                otherwise
                    error(['The selection for the plot of the frequency '...
                        'response function is not implemented. Valid '...
                        'selections: ''Nyquist'', ''Bode'', '...
                        '''amplitude'', ''phase''']);
            end
        end
        
    end
    
    
    methods (Access = private)
        
        function set_color_number(obj)
            obj.ColorHandler = AMrotorTools.PlotColors();
            num = length(obj.experimentFRF.H);
            obj.ColorHandler.set_up(num);
        end
        
    end
    
end