function check_for_non_integrable_components(self)
% Checks if the integrationProblemFlag is active
%
%    :return: Call of an error message function, if flag is active

% The CompLUTMCK object has this flag as property. The default is true.
% The flag can be set to false in the config script.
% This flag is not checked for system analyses. Only if a time 
% integration is desired, the flag is checked and 
% shows the user a short reminder.

% Licensed under GPL-3.0-or-later, check attached LICENSE file

flag = 'integrationProblemFlag';

for comp = self.rotor
    if isprop(comp,flag)
        if comp.(flag)
            comp.warn_for_non_integrable_component;
        end
    end
end

for comp = self.components
    if isprop(comp,flag)
        if comp.(flag)
            comp.warn_for_non_integrable_component;
        end
    end
end

for comp = self.sensors
    if isprop(comp,flag)
        if comp.(flag)
            comp.warn_for_non_integrable_component;
        end
    end
end

for comp = self.loads
    if isprop(comp,flag)
        if comp.(flag)
            comp.warn_for_non_integrable_component;
        end
    end
end

end

