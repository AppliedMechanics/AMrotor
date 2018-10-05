function status = odeOutputFcn_plotBeam(t,y,flag,varargin)

switch flag 
    case 'init'
        disp(' -> odeFcn init ->           ')
        figure()
        status=0;
    case 'done'
        disp(' -> done           ')
        status=0;
        close
    case ''
%         plot(y(1:6:end/2,end)); % plot Auslenkung in x
        plot(sqrt(y(1:6:end/2,end).^2+y(2:6:end/2,end).^2)); %plot den Betrag der Auslenkung
        ylim([-1 1]*5e-5);
        drawnow
        status=0;
end

end