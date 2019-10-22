function label = make_amplitude_label(obj,type,unit,amplitudeMeasure)
HStr = ['G_{',type,'}'];

unitStr = unit;

switch amplitudeMeasure
    case 'dB'
        dimStr = ' dB';
    otherwise
        dimStr = '';
end
    

label = ['$|',HStr,'|\big/ \big(\mathrm{',unitStr,dimStr,'}\big)$'];
ylabel(label,'Interpreter','latex')
end