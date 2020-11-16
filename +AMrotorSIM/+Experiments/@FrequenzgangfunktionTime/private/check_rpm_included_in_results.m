function check_rpm_included_in_results(obj,rpm)
% Checks if the desired rpm-step exists in the solution
%
%    :param rpm: Rotation speed
%    :type rpm: double
%    :return: If necessary, error message

% Licensed under GPL-3.0-or-later, check attached LICENSE file

% check_rpm_included_in_results(obj,rpm)
rpm_sol = obj.experiment.drehzahlen;
flagDimension = length(rpm)~=1;
%flagNotIncluded = any(rpm~=rpm_sol);
flagNotIncluded = all(rpm~=rpm_sol);


if flagDimension
    error('The rpm input must be a scalar.')
end

if flagNotIncluded
    error('Desired rpm does not exist in the solution')
end

end