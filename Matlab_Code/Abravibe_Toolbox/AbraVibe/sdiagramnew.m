function [p,N] = sdiagram(varargin);
%SDIAGRAM Stability diagram, used for all methods (internal function)
%
% p = sdiagram(f,Poles,NoPoles,MIF) produces a stabilization diagram for a single
% reference and allows poles to be selected
%
% [p,SelOrder] = sdiagram(f,Poles,NoPoles,MIF,NoPairChk) produces a stabilization diagram for a single
% reference and allows poles to be selected, and outputs the selected order
% of each pole in cell array SelOrder.
%
% NoPairChk set to 0 means no check is made that poles come in complex
% conjugate pairs (as some methods do not necessarily produce such pairs).

% This is an internal function used by pole estimation functions.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23
%          1.1 2012-03-22 Changed NoModes to NoPoles to allow easier use
%                         with Polyreference time domain
%          1.2 2012-10-23 Fixed bugs with PTD
%          1.3 2014-12-01 Fixed scaling for power mif type
%          1.4 2018-03-09 Introduce GUI version if run from MATLAB
% This file is part of ABRAVIBE Toolbox for NVA


%=======================================================================
% Hardcode parameters
fLim=0.001;             % pole is 'frequency stable' if relative diff less than fLim
zLim=0.05;              % pole is stable if relative difference in damping less than zLim AND
                        % fLim is also fulfilled
nSign='ro';             % Marker for new poles is red circle
fSign='bd';             % Marker for stable frequency is blue diamond
sSign='g+';             % Marker for stable pole is green plus sign
MarkerSize=4;           % Size of markers

% Parse input parameters
if nargin == 4 | nargin == 5
    f=varargin{1};
    Poles=varargin{2};
    NoPoles=varargin{3};
    MIF=varargin{4};
    if nargin == 5
        NoPairChk=varargin{5};
    end
end
if nargin == 4
    NoPairChk=false;
end
fOffset=0;

% Normalize plotfunction  to max=1 if not a MIF
if max(MIF(:,1)) ~= 1
    MifMax=max(max(MIF));
    MIF=MIF/MifMax;
end

if length(f) ~= length(MIF)
    fmif = f(end-length(MIF)+1:end);
else
    fmif=f;
end

% Read out the step between two orders (some algorithms go in pairs of
% poles, but e.g. PTD goes in step of R)
OrderStep=NoPoles(2)-NoPoles(1);
%=======================================================================
% Clean up the poles list for non-physical poles
% Remove real poles
for on=1:length(Poles)                  % Order number
    pidx=1;
    for n=1:length(Poles{on})
        if ~isreal(Poles{on}(n))
            np{on}(pidx)=Poles{on}(n);          % np is new pole vector
            pidx=pidx+1;
        end
    end
end
% Remove poles with positive real part
for on=1:length(np)
    idx=find(real(np{on}) < 0);
    np{on}=np{on}(idx);
end

% Now find complex conjugate pairs and save only positive frequencies
if NoPairChk == false
    clear Poles
    for on=1:length(np)
        pidx=1;
        for n=2:length(np{on})
            % Check distance between all higher poles with this model order and
            % the conjugate of current pole (current = n-1). If this distance
            % is small there is a complex conjugate, so save the positive pole
            dist=abs((np{on}(n:end)-conj(np{on}(n-1))));
            if ~isempty(find(dist < 1e-4))
%                 fprintf('found complex pole %f\n',imag(np{on}(n-1)))
                Poles{on}(pidx)=real(np{on}(n-1))+j*abs(imag(np{on}(n-1)));
                pidx=pidx+1;
            end
        end
    end
else
    Poles=np;
end
% Remove empty vectors from Poles
pidx=1;
for n=1:length(Poles)
    if ~isempty(Poles{n})
        np{pidx}=Poles{n};
        pidx=pidx+1;
    end
end
Poles=np;
clear np

%=======================================================================
% Plot starts here!
% From ver. w.0, GUI if run from MATLAB
%=======================================================================
sw=checksw;
if strcmp(upper(sw),'OCTAVE')
    % Plot MIF function and hold plot for poles to be plotted
    h=figure;
    plot(fmif,MIF*max(NoPoles));
    axis([min(fmif) max(fmif) 0 max(NoPoles)])
    xlabel('Frequency [Hz]')
    ylabel('Number of Poles')
    title('Stabilization Diagram, green=stable; blue=stable freq.; red=unstable')
    hold on
    
    % Check stability and plot symbols accordingly
    NPoles=NoPoles(1);
    LastRow=Poles{1};               % First row stored
    wp=abs(LastRow);                % Previous freqs
    zp=-real(LastRow)./abs(LastRow);
    plot(wp/2/pi+fOffset,NPoles,nSign,'MarkerSize',MarkerSize)
    for n = 2:length(NoPoles)                % Each row (model order) in diagram
        NPoles=NoPoles(n);
        for m = 1:length(Poles{n})   % Each pole m from order n
            wr=abs(Poles{n}(m));
            zr=-real(Poles{n}(m))/abs(Poles{n}(m));
            % See if the pole is within limits of a pole in last row
            fDist=abs(wr-wp)./abs(wp);
            zDist=abs(zr-zp)./abs(zp);
            if min(fDist) < fLim & min(zDist) < zLim    % Stable pole
                plot(wr/2/pi+fOffset,NPoles,sSign,'MarkerSize',MarkerSize)
            elseif min(abs(wr-wp)/abs(wp)) < fLim       % Stable frequency
                plot(wr/2/pi+fOffset,NPoles,fSign,'MarkerSize',MarkerSize)
            else
                plot(wr/2/pi+fOffset,NPoles,nSign,'MarkerSize',MarkerSize)       % New pole
            end
        end
        LastRow=Poles{n};               % First row stored
        wp=abs(LastRow);     % Previous freqs
        zp=-real(LastRow)./abs(LastRow);
    end
    
    %=======================================================================
    % Now have user select poles by clicking in vicinity of markers on plot
    text(0.7*f(end),NoPoles(2),'Select poles!')
    text(0.7*f(end),NoPoles(1),'Then <RETURN>')
    [xx,yy]=ginput;
    pidx=1;
    for n = 1:length(xx)
        [dum,PoleIdx]=min(abs(yy(n)-NoPoles));
        [dum,idx]=min(abs(imag(Poles{PoleIdx})-2*pi*xx(n)));
        p(pidx)=Poles{PoleIdx}(idx);
        pidx=pidx+1;
        if nargout > 1
            N{n}=NoPoles(PoleIdx);
        end
    end
else    % If run from MATLAB: GUI
    [p,N]=sdiagramGUI(fmif,MIF,NoPoles,nSign,Poles,fOffset);
end


% Sort and force poles to a column
p=sort(p);              % Does not matter which order poles were selected
p=p(:);


