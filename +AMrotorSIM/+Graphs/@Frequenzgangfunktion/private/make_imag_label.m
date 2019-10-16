function label = make_imag_label(obj,type,unit)
HStr = ['Im(G_',type];

unitStr = unit;
    

label = ['$',HStr,') \big/ \big(\mathrm{',unitStr,'}\big)$'];
ylabel(label,'Interpreter','latex')
end