function label = make_real_label(obj,type,unit)
HStr = ['Re(G_',type];

unitStr = unit;
    

label = ['$',HStr,') \big/ \big(\mathrm{',unitStr,'}\big)$'];
xlabel(label,'Interpreter','latex')
end