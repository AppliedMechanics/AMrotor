function plateanim(V,p,plateratio,platemap,Amp);
%PLATEANIM Animate mode shapes on plate structures (1D mode shapes)
%
%       plateanim(V,p,plateratio,platemap,Amp)
%
%       V           Mode shape matrix, modes in columns
%       p           Vector with poles
%       plateratio  Number describing length(y)/length(x) for plate
%                   coordinates, where x is the 'long' length of the plate,
%                   if not quadratic. plategeo=1 for a quadratic plate.
%       platemap    Geometry matrix. Has to be a rectangular matrix with
%                   elements equal to +/- a number, where the number points
%                   to the corresponding element in V(:,modeno) where the
%                   mode shape coefficient for that point is located.
%                   For the simplest case, where the points are numbered
%                   row wise on the structure, then platemap is for a
%                   2-by-4 plate:
%                   [1 5
%                    2 6
%                    3 7
%                    4 8] 
%       Amp         Amplitude for animation, approx 0.1 to 0.4 
%
% The limitation of this function is that only mode shapes for rectangular 
% plates, measured in one direction can be animated.
%
% See also  ANIMATE

% This function is loosely based on the demo script vibes.m in standard
% MATLAB.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 5
    Amp=0.3;
end

[n,m]=size(platemap);

% Set graphics parameters.
fig = figure;
%set(fig,'color','k')
x = 2*(1:n)/n; x=x-mean(x);
y = 2*plateratio*(1:m)/m; y=y-mean(y);
h = surf(y,x,20*zeros(size((platemap))));
[a,e] = view; view(a+270,e);
axis([-1 1 -1 1 -1 1]);
% caxis(26.9*[-1.5 1]);
colormap(hot);
axis off

% Buttons
uicontrol('pos',[20 20 80 20],'string','done','fontsize',12, ...
   'callback','close(gcbf)');
uicontrol('pos',[20 40 80 20],'string','next mode','fontsize',12, ...
   'callback','set(gcbf,''userdata'',1+get(gcbf,''userdata''))');
uicontrol('pos',[20 60 80 20],'string','prev mode','fontsize',12, ...
   'callback','set(gcbf,''userdata'',-1+get(gcbf,''userdata''))');

% Run
tn = 1;
NumberFrames=20;
dt=1/NumberFrames;
t=(0:NumberFrames-1)/NumberFrames*2*pi;
modeno=1;
set(fig,'userdata',modeno)
while ishandle(fig)
    % check button for next/previous mode
    modeno = get(fig,'userdata');
%     S=(['Animating mode ' int2str(modeno)]);
%     title(S)
%     AA=axis
%     htext=text(0.1,0.2,0.8,'                                      ');
%     htext=text(0.1,0.2,0.8,S);
    % Pick out mode shape vector and 'map' onto geometry
    Ap=V(:,modeno);
    modeshape=Ap(platemap);

    if tn == NumberFrames
        tn = 1;
    else
        tn=tn+1;
    end
    A=Amp/max(max(modeshape))*modeshape*sin(t(tn));

    % Velocity
    Vv = zeros(size(modeshape));
%     for k = 1:12
%       V = V + s(k)*L{k};
%     end
%    V(16:31,1:15) = NaN;
    % Surface plot of height, colored by velocity.
    set(h,'zdata',A,'cdata',Vv);
    drawnow
    pause(dt)
end;


