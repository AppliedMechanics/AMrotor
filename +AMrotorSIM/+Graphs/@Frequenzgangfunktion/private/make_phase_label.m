function label = make_phase_label(obj,type,angleMeasure)
HStr = ['G_{',type,'}'];

% unit aus container
unitStrContainer = {'{}^\circ','rad'};
types = {'deg','rad'};
unitContainer = containers.Map(types,unitStrContainer);
angleStr = unitContainer(angleMeasure);

    

label = ['$\angle ',HStr,'\big/ \big(\mathrm{',angleStr,'}\big)$'];
ylabel(label,'Interpreter','latex')
end