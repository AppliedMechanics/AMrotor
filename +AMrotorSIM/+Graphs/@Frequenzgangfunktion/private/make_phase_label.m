function label = make_phase_label(obj,type,angleMeasure)
% Assembles the label for the phase of the FRF
%
%    :param type: Type of the FRF ('d' for displacement,....)
%    :type type: char
%    :param unit: Unit of the FRF
%    :type unit: char
%    :return: Labels for the phase plot

% Licensed under GPL-3.0-or-later, check attached LICENSE file

HStr = ['G_{',type,'}'];

% unit aus container
unitStrContainer = {'{}^\circ','rad'};
types = {'deg','rad'};
unitContainer = containers.Map(types,unitStrContainer);
angleStr = unitContainer(angleMeasure);

    

label = ['$\angle ',HStr,'\big/ \big(\mathrm{',angleStr,'}\big)$'];
ylabel(label,'Interpreter','latex')
end