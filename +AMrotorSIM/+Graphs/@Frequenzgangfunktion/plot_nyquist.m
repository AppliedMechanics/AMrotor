function plot_nyquist(obj,f,frf,paramPlot)

type = obj.experimentFRF.type;
unit = obj.experimentFRF.unit;
figure


k=0;
for i=1:size(frf,3)
    for j = 1:size(frf,2)
        k=k+1;
        realFRF = real(frf(:,j,i));
        imagFRF = imag(frf(:,j,i));
        Color = obj.ColorHandler.getColor(k);
        LineStyle = '-';
        LineWidth = 0.5;
        DisplayName = obj.experimentFRF.descriptionsH{j,i};
        
        hold on
        plot3(realFRF,imagFRF,f,'LineWidth',LineWidth,'DisplayName',DisplayName,'Color',Color,'LineStyle',LineStyle)
        
    end
    
end
view(2)

obj.make_figure_title();
obj.make_real_label(type,unit);
obj.make_imag_label(type,unit);

legend('show')

end