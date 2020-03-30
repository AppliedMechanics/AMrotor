classdef Frequenzgangfunktion < handle
% Frequenzgangfunktion Class for visualisation of the frequency response
% function
% See also AMrotorSIM.Experiments.Frequenzgangfunktion
    properties
        Name = 'Visualisierung Frequenzgangfunktion';
        % See also AMrotorSIM.Experiments.Frequenzgangfunktion
        experimentFRF;
        % See also AMrotorTools.PlotColors
        ColorHandler
        paramPlot % parameters for the visualisation
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
        
        function set_plots(obj,Selection,varargin)
        % main method for user
        % set_plots(obj,Selection,inputDirection,outputDirection,varargin)
        % 
        % INPUTS
        % Selection: 'nyquist', 'Bode', 'Amplitude', 'Phase'
        % inputDirection: 
        %   string: 'u_x', 'u_y', 'u_z', 'psi_x', 'psi_y', 'psi_z'
        %   cell array including strings, for example {'u_x','psi_x'}
        %   number 1,2,3,4,5,6 for u_x, u_y, ..., psi_z
        %   vector of numbers
        % outputDirection: similar to inputDirection
        % 
        % OPTIONAL ADDITIONAL INPUTS (in arbitrary order)
        % amplitudeMeasure: 'lin', 'log', 'dB'
        % angleMeasure: 'rad', 'deg'
        % coherence-selection: 'coh'
        % 
        % examples of use:
        %    visufrf.set_plots('amplitude',1,1,'db')
        %    visufrf.set_plots('phase',{'u_x','u_y'},'u_x','db')
        %    visufrf.set_plots('bode',[1,4],[1,2,3],'log','deg')
        %    visufrf.set_plots('nyquist','u_y','u_y')
        
            obj.set_color_number();
            paramPlot.angleMeasure = obj.set_angle_measure(varargin);
            paramPlot.amplitudeMeasure = obj.set_amplitude_measure(varargin);
            paramPlot.flagCoh = obj.get_coherence_selection(varargin);
            
            [f,frf,C] = obj.experimentFRF.get_frf();% get f, frf
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
            
            if paramPlot.flagCoh
                obj.plot_coherence(f,C)
            end
        end
        
    end
    
    
    methods (Access = private)
        
        function set_color_number(obj)
            obj.ColorHandler = AMrotorTools.PlotColors();
            num = size(obj.experimentFRF.H,2)*size(obj.experimentFRF.H,3);
            obj.ColorHandler.set_up(num);
        end
        
    end
    
end