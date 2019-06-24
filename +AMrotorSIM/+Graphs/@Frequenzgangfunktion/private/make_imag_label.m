function label = make_imag_label(obj,type)
HStr = ['Im(G_',type];

% unit aus container
unitStrContainer = {'\frac{m}{N}','\frac{m}{Ns}','\frac{m}{Ns^2}'};
types = {'d','v','a'};
unitContainer = containers.Map(types,unitStrContainer);
unitStr = unitContainer(type);
    

label = ['$',HStr,') \big/ \big(\mathrm{',unitStr,'}\big)$'];
ylabel(label,'Interpreter','latex')
end