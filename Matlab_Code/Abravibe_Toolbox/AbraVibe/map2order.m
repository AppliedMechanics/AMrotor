function Orders = map2order(S,F,R,OrderList,Method,FilterL)
% MAP2ORDER   Extract orders from RPM map, fix fs or synchronuous sampling
%
%       Orders = map2order(S,F,R,OrderList,Method,FilterL)
%
%       Orders      Matrix with requested orders in columns
%
%       S           RPM map from RPMMAP
%       F           Frequency axis for S
%       R           RPM axis for S
%       OrderList   Vector with orders to compute (can be decimal numbers)
%                   0 (zero) means overall level (total RMS in frequency).
%                   If Method='peak', or 'Synch', a flattop window is 
%                   assumed to have been used for the spectrum analysis 
%                   when calculating the overall level. The first 4 freq.
%                   lines are not included in the overall level.
%       Method      'Peak' picks the values at each frequency, or 
%                   'Hann5' sums RMS values from 5 spectral lines centered
%                   on the order in OrderList and if S is complex, averages
%                   the phase values. The latter method requires that
%                   RPMMAP was called with a Hanning window, otherwise it
%                   produces wrong results! Default is 'Hann5'
%                   'Synch' tells this function that the map is from a
%                   synchronuously sampled map, where the F axis is in
%                   orders. Simple peak picking is used, as there should be
%                   no smearing after the synchronuous sampling.
%       FilterL     If given, each order is smoothed with a filter of
%                   length FilterL to produce less variance in Orders
%
% The recommended procedure is to use a Hanning window for RPMMAP and using
% the (default) option Method='Hann5'. This method is much less sensitive
% to smearing errors.
%
%   See also RPMMAP RPMMAPS PLOTORDERS SMOOTHFILT
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargin < 5
    Method='Hann5';
end

Orders=zeros(length(R),length(OrderList));
for n = 1:length(OrderList);
    for r = 1:length(R)
        OrderF=OrderList(n)*R(r)/60;
        if OrderF ~= 0
            [dum,fidx]=min(abs(F-OrderF));
            if strcmp(upper(Method),'HANN5')
                Orders(r,n)=sqrt(sum(S(fidx-2:fidx+2,r).^2)/1.5);
                if ~isreal(S)
                    Phase=mean(angle(S(fidx-2:fidx+2,r)));
                    Orders(r,n)=Orders(r,n)*exp(j*Phase);
                end
            elseif strcmp(upper(Method),'PEAK')
                Orders(r,n)=S(fidx,r);
            elseif strcmp(upper(Method),'SYNCH')
                [dum,fidx]=min(abs(F-OrderList(n)));
                Orders(r,n)=S(fidx,r);
            end
        else            % Compute overall level
            if strcmp(upper(Method),'HANN5')
                enbw=winenbw(ahann(128));
            else
                enbw=winenbw(aflattop(128));
            end
            Orders(r,n)=sqrt(sum(S(5:end,r).^2)/enbw);
        end
    end
end

% If requested, smooth to obtain more stable values
if nargin == 6
    for n = 1:length(Orders(1,:))
        Orders(:,n)=smoothfilt(Orders(:,n),FilterL);
    end
end


