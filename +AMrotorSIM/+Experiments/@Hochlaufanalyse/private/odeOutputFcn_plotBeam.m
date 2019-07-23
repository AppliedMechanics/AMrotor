function status = odeOutputFcn_plotBeam(t,y,flag,varargin)

switch flag 
    case 'init'
        disp('odeFcn init ->           ')
        figure()
        status=0;
    case 'done'
        disp(' -> done           ')
        status=0;
        close
    case ''
        plot(y(1:6:end/2,end)); % plot Auslenkung in x
        ylim([-1.1 1.1]*(max(abs(y(1:6:end/2,end)))+1e-12));
%         plot(sqrt(y(1:6:end/2,end).^2+y(2:6:end/2,end).^2)); %plot den Betrag der Auslenkung
%         ylim([-1 1]*5e-5);
        drawnow
        status=0;
        
        %Zeit ausgeben
        fprintf(repmat('\b', 1, 11)); % Zeit ausgeben und wieder loeschen, sodass Uebersichtlichkeit erhalten bleibt
        fprintf('t = %04.0f',t(end)*1000)
        fprintf(' ms')

        
end

end