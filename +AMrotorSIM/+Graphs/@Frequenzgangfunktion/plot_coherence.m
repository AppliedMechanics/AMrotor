function plot_coherence(obj,f,C)

figure
k=0;

for i=1:size(C,3)
    for j = 1:size(C,2)
        k=k+1;
        absCoh = abs(C(:,j,i));
        Color = obj.ColorHandler.getColor(k);
        LineStyle = '-';
        LineWidth = 0.5;
        DisplayName = obj.experimentFRF.descriptionsH{j,i};
        hold on
        
        plot(f,absCoh,'LineWidth',LineWidth,'DisplayName',DisplayName,'Color',Color,'LineStyle',LineStyle)

    end
    
end

obj.make_figure_title();
label = 'coherence';
ylabel(label,'Interpreter','latex')
xlabel('$f$/Hz','Interpreter','latex')
legend('show')

% ylim([0 1])

end