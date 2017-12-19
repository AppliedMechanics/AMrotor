function setPlotLabels( ax, Name )
%SETPLOTLABELS Summary of this function goes here
%   Detailed explanation goes here

title(ax,Name)
xlabel(ax,'$\Omega$ in $[\frac{1}{min}]$','Interpreter','latex')
ylabel(ax,'$\omega_{i}$ in $[$Hz$]$','Interpreter','latex')

end

