function label = make_amplitude_label(obj,type,amplitudeMeasure)
HStr = ['G_',type];

% unit aus container
unitStrContainer = {'\frac{m}{N}','\frac{m}{Ns}','\frac{m}{Ns^2}'};
types = {'d','v','a'};
unitContainer = containers.Map(types,unitStrContainer);
unitStr = unitContainer(type);

switch amplitudeMeasure
    case 'dB'
        dimStr = ' dB';
    otherwise
        dimStr = '';
end
    

label = ['$|',HStr,'|\big/ \big(\mathrm{',unitStr,dimStr,'}\big)$'];
ylabel(label,'Interpreter','latex')
end