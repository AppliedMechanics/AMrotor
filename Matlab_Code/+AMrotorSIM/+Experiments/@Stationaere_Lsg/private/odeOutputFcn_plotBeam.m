function status = odeOutputFcn_plotBeam(t,y,flag,varargin)

switch flag 
    case 'init'
        disp('odeFcn init')
        figure()
        status=0;
    case 'done'
        disp('done')
        status=0;
    case ''
        plot(y(1:6:end/2));
        drawnow
        status=0;
end

end