function check_for_non_integrable_components(self)
%CHECK_FOR_NON_INTEGRABLE_COMPNENTS Summary of this function goes here
%   Input of class Rotorsystem

flag = 'integrationProblemFlag';

for comp = self.rotor
    if isprop(comp,flag)
        if comp.(flag)
            comp.warn_for_non_integrable_component;
        end
    end
end

for comp = self.discs
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

for comp = self.bearings
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

for comp = self.seals
    if isprop(comp,flag)
        if comp.(flag)
            comp.warn_for_non_integrable_component;
        end
    end
end

for comp = self.CompLUTMCK
    if isprop(comp,flag)
        if comp.(flag)
            comp.warn_for_non_integrable_component;
        end
    end
end

end

