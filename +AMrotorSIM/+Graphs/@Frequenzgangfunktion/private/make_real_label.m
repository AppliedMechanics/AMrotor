function label = make_real_label(obj,type)
HStr = ['Re(G_',type];

% unit aus container
unitStrContainer = {'\frac{m}{N}','\frac{m}{Ns}','\frac{m}{Ns^2}'};
types = {'d','v','a'};
unitContainer = containers.Map(types,unitStrContainer);
unitStr = unitContainer(type);
    

label = ['$',HStr,') \big/ \big(\mathrm{',unitStr,'}\big)$'];
xlabel(label,'Interpreter','latex')
end