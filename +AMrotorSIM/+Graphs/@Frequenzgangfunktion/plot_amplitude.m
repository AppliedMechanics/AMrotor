function plot_amplitude(obj,f,frf,paramPlot)

amplitudeMeasure = paramPlot.amplitudeMeasure;
type = obj.experimentFRF.type;
figure
k=0;

for i=1:length(paramPlot.inLocDof)
    for j = 1:length(paramPlot.outLocDof)
        k=k+1;
        absFRF = abs(frf(:,j,i));
        Color = obj.ColorHandler.getColor(k);
        LineStyle = '-';
        LineWidth = 0.5;
        DisplayName = obj.make_display_name(paramPlot.inLocDof(i),paramPlot.outLocDof(j));
        hold on
        
        switch amplitudeMeasure
            case 'lin'
                plot(f,absFRF,'LineWidth',LineWidth,'DisplayName',DisplayName,'Color',Color,'LineStyle',LineStyle)
            case 'log'
                plot(f,absFRF,'LineWidth',LineWidth,'DisplayName',DisplayName,'Color',Color,'LineStyle',LineStyle)
                ax=gca;
                ax.YScale = 'log';
            case 'dB'
                plot(f,db20(absFRF),'LineWidth',LineWidth,'DisplayName',DisplayName,'Color',Color,'LineStyle',LineStyle)
        end
    end
    
end

obj.make_figure_title();
obj.make_amplitude_label(type,amplitudeMeasure);
xlabel('$f$/Hz','Interpreter','latex')
legend('show')

end