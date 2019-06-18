function h = anomograph
% ANOMOGRAPH     Plot a displacement, velocity, acceleration nomograph
%
%        h = anomograph
%
%        h          Handle to figure
%
% The nomograph is a log-log plot in which conversion between displacement,
% velocity and acceleration is easily extracted. This type of plot is very
% useful for example in interpreting vibration test specifications for sine
% testing.
%
% The nomograph looks best (on my widescreen computer) if blown up to full
% screen.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


% The velocity and frequency limits are hard coded here. If you change the
% limits below you will have to tweak the labels further below to appear
% right on the plot.
flo=1;
fhi=1e4;
vlo=1e-4;
vhi=10;

% Define parameters
f=[flo fhi]';
v=[vlo vhi]';
d=v./f/2/pi;
a=2*pi*f.*v;
One2Nine=[1:9];                     % Decade steps
% acceleration levels to plot
A=[1e-3 1e-2 1e-1 1 1e1 1e2 1e3 1e4 1e5];
% Displacement levels to plot
D=[1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1];


% Create figure: if called with h as output create handle
if nargout == 1
    h=figure;
else
    figure;
end

% Plot base plot with limits
h2=loglog(f,v,'.k');
xlabel('Frequency [Hz]')
ylabel('Velocity, m/s')
grid on
hold on


% Constant acceleration in m/s^2:
% For each acceleration level to plot, calculate the low and high
% corresponding velocity values and plot (as the plot is a velocity vs.
% frequency plot)
for q = 1:length(A)
    for n = 1:length(One2Nine)
        vplotlo=A(q)*One2Nine(n)/2/pi/flo;
        vplothi=A(q)*One2Nine(n)/2/pi/fhi;
        if n == 1
            loglog([flo fhi],[vplotlo vplothi],'-k')
            if A(q) > .001 & A(q) < 100        % Omitt text for lowest acc. level
                t=text(2,0.7*vplotlo,sprintf('%5.2g m/s^2',A(q)),'Rotation',-25','BackgroundColor','White');
            elseif A(q) > .001
                text(.045*A(q),0.5*vhi,sprintf('%5.2g m/s^2',A(q)),'Rotation',-25','BackgroundColor','White');
            end
        else
            loglog([flo fhi],[vplotlo vplothi],':k')
        end            
    end 
end

% Constant displacement in m, same procedure as for acceleration
for q = 1:length(D)
    for n = 1:length(One2Nine)
        vplotlo=D(q)*One2Nine(n)*2*pi*flo;
        vplothi=D(q)*One2Nine(n)*2*pi*fhi;
        if n == 1
            loglog([flo fhi],[vplotlo vplothi],'-k')
            if D(q) > 1e-7 & D(q) < 0.1          
                text(15,120*D(q),sprintf('%5.2g m',D(q)),'Rotation',+25','BackgroundColor','White');
            elseif D(q) == 1e-7
                text(200,1.7*vlo,sprintf('%5.2g m',D(q)),'Rotation',+25','BackgroundColor','White');
            elseif D(q) == 1e-8
                text(2000,1.7*vlo,sprintf('%5.2g m',D(q)),'Rotation',+25','BackgroundColor','White');
            end
        else
            loglog([flo fhi],[vplotlo vplothi],':k')
        end            
    end 
end

% Delete the first plotted dots for the velocity map
delete(h2(1))
axis([flo fhi vlo vhi])
