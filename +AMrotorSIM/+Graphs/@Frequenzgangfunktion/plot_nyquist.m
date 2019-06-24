function plot_nyquist(obj,f,frf,paramPlot)

type = obj.experimentFRF.type;
figure


k=0;
for i=1:length(paramPlot.inLocDof)
    for j = 1:length(paramPlot.outLocDof)
        k=k+1;
        realFRF = real(frf(:,j,i));
        imagFRF = imag(frf(:,j,i));
        Color = obj.ColorHandler.getColor(k);
        LineStyle = '-';
        LineWidth = 0.5;
        DisplayName = obj.make_display_name(paramPlot.inLocDof(i),paramPlot.outLocDof(j));
        
        hold on
        plot3(realFRF,imagFRF,f,'LineWidth',LineWidth,'DisplayName',DisplayName,'Color',Color,'LineStyle',LineStyle)
        
    end
    
end
view(2)

obj.make_figure_title();
obj.make_real_label(type);
obj.make_imag_label(type);

legend('show')

end