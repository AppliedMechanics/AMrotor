function plot_bode(obj,f,frf,paramPlot)

amplitudeMeasure = paramPlot.amplitudeMeasure;
angleMeasure = paramPlot.angleMeasure;
type = obj.experimentFRF.type;
figure

% amplitude
subplot(2,1,1)
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
                plot(f,log(absFRF),'LineWidth',LineWidth,'DisplayName',DisplayName,'Color',Color,'LineStyle',LineStyle)
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

% phase
subplot(2,1,2)
k=0;
for i=1:length(paramPlot.inLocDof)
    for j = 1:length(paramPlot.outLocDof)
        k=k+1;
        phaseFRF = angle(frf(:,j,i));
        Color = obj.ColorHandler.getColor(k);
        LineStyle = '-';
        LineWidth = 0.5;
        DisplayName = obj.make_display_name(paramPlot.inLocDof(i),paramPlot.outLocDof(j));
        hold on
        
        %switch type % unterscheide nach interssierendem Bereich: z.B. 'd'
        %-> 0 bis -360deg
        %            case 'a'
        %
        %            case 'v'
        %
        %            case 'd'
        %end
        
        switch angleMeasure
            case 'deg'
                phaseFRF = phaseFRF/pi*180;
                yticks(-360:90:360)
            case 'rad'
                yticks(-2*pi:pi/2:2*pi)
                yticklabels({'-2\pi','-1.5\pi','-\pi','-0.5\pi',...
                    '0','0.5\pi','\pi','1.5\pi','2\pi'})
        end
        plot(f,phaseFRF,'LineWidth',LineWidth,'DisplayName',DisplayName,'Color',Color,'LineStyle',LineStyle)
    end
end

obj.make_figure_title();
obj.make_phase_label(type,angleMeasure);
xlabel('$f$/Hz','Interpreter','latex')
legend('show')

end