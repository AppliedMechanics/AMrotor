function status = odeOutputFcnController(t,y,flag,varargin)
% Provides output function of integration and displays progress in Command Window
%
%    :param t: Time steps of integration
%    :type t: vector (double)
%    :param y: Output function
%    :type y: function
%    :param flag: Imports status of integration (check MATLAB odeset)
%    :type flag: char
%    :param varargin: Variable input argument (check function)
%    :type varargin:
%    :return: Printing and plotting of the integration status

% Licensed under GPL-3.0-or-later, check attached LICENSE file

%rpm_span = varargin{1};
%t_span = varargin{2};
rotorsystem = varargin{3};
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
%         plot(sqrt(y(1:6:end/2,end).^2+y(2:6:end/20,end).^2)); %plot den Betrag der Auslenkung
%         ylim([-1 1]*5e-5);
        drawnow
        status=0;
        
        %Zeit ausgeben
        fprintf(repmat('\b', 1, 11)); % Zeit ausgeben und wieder loeschen, sodass Uebersichtlichkeit erhalten bleibt
        fprintf('t = %04.0f',t(end)*1000)
        fprintf(' ms')

        % set the new controller force
        for cntr = rotorsystem.pidControllers
            [displacementCntrNode, ~] = rotorsystem.find_state_vector(cntr.position, y);
            cntr.get_controller_force(t(end),displacementCntrNode); 
        end
        
end

end