% Licensed under GPL-3.0-or-later, check attached LICENSE file

function label = make_real_label(obj,type,unit)
% Assembles the label for the real part of the FRF
%
%    :param type: Type of the FRF ('d' for displacement,....)
%    :type type: char
%    :param unit: Unit of the FRF
%    :type unit: char
%    :return: Labels for the real part plot

HStr = ['Re(G_{',type,'})'];

unitStr = unit;
    

label = ['$',HStr,') \big/ \big(\mathrm{',unitStr,'}\big)$'];
xlabel(label,'Interpreter','latex')
end