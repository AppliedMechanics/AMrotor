% Licensed under GPL-3.0-or-later, check attached LICENSE file

function plot_phase(obj,f,frf,paramPlot)
% Plots the phase of the FRF
%
%    :param f: Frequency
%    :type f: vector
%    :param frf: Frequency response function
%    :type frf: vector
%    :param paramPlot: Additional parameters for visualization (type of amplitude, …)
%    :type paramPlot: struct
%    :return: Figure with phase of the FRF

angleMeasure = paramPlot.angleMeasure;
type = obj.experimentFRF.type;
unit = obj.experimentFRF.unit;
figure
k=0;

for i=1:size(frf,3)
    for j = 1:size(frf,2)
        k=k+1;
        phaseFRF = angle(frf(:,j,i));
        Color = obj.ColorHandler.getColor(k);
        LineStyle = '-';
        LineWidth = 0.5;
        DisplayName = obj.experimentFRF.descriptionsH{j,i};
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