function set_plot_labels_damping_ratio( ax, Name )
%SET_PLOT_LABELS_DELTAS Summary of this function goes here
%   Detailed explanation goes here

title(ax,Name)
xlabel(ax,'$\Omega$ in 1/min','Interpreter','latex')
ylabel(ax,'$D_{i}$','Interpreter','latex')

end

