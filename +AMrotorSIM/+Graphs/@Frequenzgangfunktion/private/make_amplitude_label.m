function label = make_amplitude_label(obj,type,unit,amplitudeMeasure)
% Assembles the label for the amplitude of the FRF
%
%    :param type: Type of the FRF ('d' for displacement,....)
%    :type type: char
%    :param unit: Unit of the FRF
%    :type unit: char
%    :param amplitudeMeasure: Representation type (default='lin')
%    :type amplitudeMeasure: char
%    :return: Labels for the amplitude plot

% Licensed under GPL-3.0-or-later, check attached LICENSE file

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