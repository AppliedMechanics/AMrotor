classdef Campbell < handle
%CAMPBELL Calculates the eigenvalues needed for a Campbell diagram
% This class calculates the needed matrices for the calculation of the
% campell diagramm and does also the sorting regarding forward/backward
% whirl
% See also AMrotorSIM.Graphs.Campbell
    properties (Access = private)
        name = 'Campell Analysis';
        rotorsystem (1,1) AMrotorSIM.Rotorsystem;
        omega;
        num; % struct which will gather all kind of numbers
        EVf; EVb; % eigenvectors forward&backward
        EWf; EWb; % eigenvalues forward&backward
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = public)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Konstruktor
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function obj = Campbell(rotorsystem)
        % obj = Campbell(rotorsystem)
            if nargin == 0
                disp('Without a rotor-system a Campell analaysis is not possible')
            else
                obj.rotorsystem = rotorsystem;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set_up(obj,omega,nModes)
            obj.omega = omega*pi/30;
            obj.set_number_of_modes(nModes);
            obj.set_number_of_revolutions();
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function calculate(obj)
            for w = obj.omega
                [mat.A,mat.B] = obj.get_state_space_matrices(w);
                [V,D] = obj.perform_eigenanalysis(mat);
                Vpos = obj.get_position_entries(V);  
                if w == 0
                    [Vpos,D]= get_positive_entries(Vpos,D);
                    EW_for = D(1:2:end);
                    EV_for = Vpos(:,1:2:obj.num.modes);
                    EW_back = D(2:2:end);
                    EV_back = Vpos(:,2:2:obj.num.modes);
                    EW_for = EW_for(1:obj.num.modes/2);
                    EW_back = EW_back(1:obj.num.modes/2);
                else
                    [ EV_for, EW_for, EV_back, EW_back, ~, ~, ~, ~ ] = ...
                        obj.get_separation_eigenvectors(Vpos,D);
                end
                obj.EWf(:,end+1) = EW_for;
                obj.EWb(:,end+1) = EW_back;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [num] = get_number_of_eigenvalues(obj)
            s = size(obj.EWf);
            num.forward = s(1);
            s = size(obj.EWb);
            num.backward = s(1);
            num.all = num.forward + num.backward;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function nModes = get_number_of_modes(obj)
            s = size(obj.EWf);
            nModes = s(2);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function EW = get_eigenvalues(obj)
            EW.forward = obj.EWf;
            EW.backward = obj.EWb;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function omega = get_omega(obj)
            omega = obj.omega;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set_number_of_revolutions(obj)
            obj.num.omega = length(obj.omega);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set_number_of_modes(obj,nModes)
            if mod(nModes,2)
                obj.num.modes = nModes + 1;
                disp('The number of modes is increased by one so it is an even number')
            else
                obj.num.modes = nModes;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % function declarations; definitions are in the 'private' folder
        [A,B] = get_state_space_matrices(obj,omega)
        [V,D] = perform_eigenanalysis(obj,mat)
        Vpos = get_position_entries(obj,V);
        [ EV_for,EW_for,...
          EV_back,EW_back,...
          EV_0, EW_0,...
          Phase_xy, Phase_xy_mean ] = get_separation_eigenvectors(obj,EV,EW );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end