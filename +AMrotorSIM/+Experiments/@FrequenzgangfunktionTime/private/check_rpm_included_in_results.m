function check_rpm_included_in_results(obj,rpm)
% check if the desired rpm-step exists in the soultion
% check_rpm_included_in_results(obj,rpm)
rpm_sol = obj.experiment.drehzahlen;
flagDimension = length(rpm)~=1;
flagNotIncluded = any(rpm~=rpm_sol);

if flagDimension
    error('The rpm input must be a scalar.')
end

if flagNotIncluded
    error('Desired rpm does not exist in the solution')
end

end