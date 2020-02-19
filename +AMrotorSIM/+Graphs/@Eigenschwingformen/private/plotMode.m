function plotMode( axFigure, x, V, D , color)
%PLOTMODE 
% plotMode( axFigure, x, V, D , color)

plot(axFigure,x,V,...
            'DisplayName',sprintf('%1.2f Hz',D/(2*pi)),...
            'Color',color)
xlabel('position')
ylabel('amplitude')

end

