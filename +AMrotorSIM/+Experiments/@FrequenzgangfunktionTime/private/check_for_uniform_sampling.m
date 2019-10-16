function check_for_uniform_sampling(obj,time)
%CHECK_FOR_UNIFORM_SAMPLING check if the time data is uniformly sampled
% check_for_uniform_sampling(obj,time)

deltaT = time(2:end)-time(1:end-1);

tol = 1e-9*deltaT(1);

flagUniformlySampled = (deltaT<deltaT(1)+tol)&(deltaT>deltaT(1)-tol); 

if ~all(flagUniformlySampled)
    timeError = time(flagUnifomlySampled); % time of first error
    errorMsg = ['Time data must be uniformly sampled! Error at ',num2str(timeError),' seconds'];
    error(errorMsg);
end
end

