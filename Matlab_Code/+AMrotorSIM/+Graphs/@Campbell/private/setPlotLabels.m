function setPlotLabels( ax, Name )
%SETPLOTLABELS Summary of this function goes here
%   Detailed explanation goes here

title(ax,Name)
xlabel(ax,'$\Omega$','Interpreter','latex')
ylabel(ax,'$\omega_{i}$','Interpreter','latex')

end

