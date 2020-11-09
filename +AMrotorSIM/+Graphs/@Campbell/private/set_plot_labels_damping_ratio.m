function set_plot_labels_damping_ratio( ax, Name )
% Assigns the labels to the plots (for Campbell with damping ration D)
%
%    :parameter ax: Axes properties control of the figure
%    :type ax: matlab.graphics.axis.Axes object
%    :parameter Name: Name of the title of the subplot
%    :type Name: char
%    :return: Named axes of the subplot 

% Licensed under GPL-3.0-or-later, check attached LICENSE file

title(ax,Name)
xlabel(ax,'$\Omega$ in 1/min','Interpreter','latex')
ylabel(ax,'$D_{i}$','Interpreter','latex')

end

