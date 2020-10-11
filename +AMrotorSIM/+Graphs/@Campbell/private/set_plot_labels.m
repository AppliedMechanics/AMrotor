% Licensed under GPL-3.0-or-later, check attached LICENSE file

function set_plot_labels(ax,Name)
% Assigns the labels to the plots (for Campbell with angular eigenfrequency omega)
%
%    :parameter ax: Axes properties control of the figure
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter Name: Name of the title of the subplot
%    :type Name: char
%    :return: Named axes of the subplot

title(ax,Name)
xlabel(ax,'$\Omega$ in $[\frac{1}{min}]$','Interpreter','latex')
ylabel(ax,'$\omega_{i}$ in $[$Hz$]$','Interpreter','latex')

end

