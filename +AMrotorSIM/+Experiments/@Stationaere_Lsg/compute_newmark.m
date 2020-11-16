function compute_newmark(obj,options)
% Carries out an integration of type newmark
%
%    :param options: Additional options like adaptivity, tolerances,... (check function)
%    :type option: struct
%    :return: Integration results in results field of object

% compute_newmark Time integration by newmark scheme
% using constant average acceleration (beta = 1/4, gamma = 1/2)
% See for example lecture script: Rixen, Structural Dynamics
% See Schweitzerhof 2004 for adaptive time stepping
%
% compute_newmark(obj,options)
%   options.adapt = [ true | false ] chose adaptive step size control
%   options.locTolUpper Upper tol for local error, required for adapt
%   options.locTolLower Lower tol for local error, required for adapt
%   options.globTol Global tol, required for adapt, can restart the whole
%       integration process
%
%   notes:
%     - changing the step size requires a factorization of the problem
%       -> do not change the step size too often
%       locTolLower = locTolUpper/2...10
%     - do not chose globTol too small, as the time integration is
%       restarted with new local tolerances if globError>GlobTol
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

obj.rotorsystem.check_for_non_integrable_components;
tic
obj.clear_time_result()
obj.result = containers.Map('KeyType','double','ValueType','any');

% check the options struct
if ~exist('options','var')
    flagAdapt = false;
elseif isstruct(options)
    if ~isfield(options,'adapt')
        flagAdapt = false;
    else
        flagAdapt = options.adapt;
    end
end

if flagAdapt
    if ~isfield(options,'locTolUpper')
        error('options-struct must contain field ''locTolUpper''!')
    end
    if ~isfield(options,'locTolLower')
        error('options-struct must contain field ''locTolLower''!')
    end
    if ~isfield(options,'globTol')
        error('options-struct must contain field ''globTol''!')
    end
end


for drehzahl = obj.drehzahlen
    omega = drehzahl /60 *2*pi;
    [M,C,G,K] = obj.rotorsystem.assemble_system_matrices(drehzahl);
    D = C + omega*G;
    
    x0 = zeros(length(M),1);
    dotx0=zeros(length(M),1);
    dotx0(6:6:end) = omega;
    t=obj.time;
    
    if flagAdapt
        [t,x,dotx,ddotx] = obj.newmark_integration_with_adaptive_step_size(M,D,K,@get_force_newmark,t,x0,dotx0,options);
        % resample results
        if length(t)>2
            %interp1
            % no: respampling in the function, call odeOutputFcnController
            % inside the integration at the time steps specified in obj.time
            xResampled = zeros(size(x,1),length(obj.time));
            dotxResampled = xResampled;
            ddotxResampled = xResampled;
            for i=1:size(x,1)
                xResampled(i,:) = interp1(t,x(i,:),obj.time);
                dotxResampled(i,:) = interp1(t,dotx(i,:),obj.time);
                ddotxResampled(i,:) = interp1(t,ddotx(i,:),obj.time);
            end
            x = xResampled;
            dotx = dotxResampled;
            ddotx = ddotxResampled;
        end
    else
        [t,x,dotx,ddotx] = obj.newmark_integration_without_adaptive_step_size(M,D,K,@get_force_newmark,t,x0,dotx0);
    end
    
    
    
    res.X = x(1:end,:);
    res.X_d = dotx(1:end,:);
    res.X_dd = ddotx(1:end,:);
    res.F = obj.rotorsystem.calculate_force_load_post_sensor(obj.time,res.X,res.X_d);
    res.FBearing = obj.rotorsystem.calculate_bearing_force(obj.time,res.X,res.X_d);
    res.Fcontroller = obj.rotorsystem.calculate_controller_force(obj.time,res.X,res.X_d);
    
    obj.result(drehzahl)=res;
    
    toc
end

end