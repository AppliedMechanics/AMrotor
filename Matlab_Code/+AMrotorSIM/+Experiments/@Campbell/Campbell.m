classdef Campbell < handle
    %CAMPELL Summary of this class goes here
    % This class calculates the needed matrices for the calculation of the
    % campell diagramm and does also the sorting regarding forward/backward
    % whirl
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties (Access = private)
        name = 'Campell Analysis';
        rotorSystem;
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
        function obj = Campbell(rotorSystem)
            if nargin == 0
                disp('Without a rotor-system a Campell analaysis is not possible')
            else
                obj.rotorSystem = rotorSystem;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setUp(obj,omega,nModes)
            obj.omega = omega*pi/30;
            obj.setNumberOfModes(nModes);
            obj.setNumberOfRevolutions();
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function calculate(obj)
            for w = obj.omega
                [mat.A,mat.B] = obj.getStateSpaceMatrices(w);
                [V,tmp] = obj.performEigenAnalysis(mat);
                Vpos = obj.getPositionEntries(V);
                D = getPositiveEntries(tmp);
                if w == 0
                    EW_for = D(1:2:end);
                    EW_back = D(2:2:end);
                else
                    [ ~,EW_for,~,EW_back, ~, ~, ~, ~ ] = ...
                        obj.getSeparationEigenVectors(Vpos,D);
                end
                obj.EWf(:,end+1) = EW_for;
                obj.EWb(:,end+1) = EW_back;

            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [num] = getNumberOfEigenValues(obj)
            s = size(obj.EWf);
            num.forward = s(1);
            s = size(obj.EWb);
            num.backward = s(1);
            num.all = num.forward + num.backward;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function nModes = getNumberOfModes(obj)
            s = size(obj.EWf);
            nModes = s(2);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function EW = getEigenValues(obj)
            EW.forward = obj.EWf;
            EW.backward = obj.EWb;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function omega = getOmega(obj)
            omega = obj.omega;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods (Access = private)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setNumberOfRevolutions(obj)
            obj.num.omega = length(obj.omega);
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function setNumberOfModes(obj,nModes)
            if mod(nModes,2)
                obj.num.modes = nModes + 1;
                disp('The number of modes is increased by one so it is an even number')
            else
                obj.num.modes = nModes;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % function declarations; definitions are in the 'private' folder
        [A,B] = getStateSpaceMatrices(obj,omega)
        [V,D] = performEigenAnalysis(obj,mat)
        Vpos = getPositionEntries(obj,V);
        [ EV_for,EW_for,...
          EV_back,EW_back,...
          EV_0, EW_0,...
          Phase_xy, Phase_xy_mean ] = getSeparationEigenVectors(obj,EV,EW );
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end