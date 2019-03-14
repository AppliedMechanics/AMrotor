function h = plotreim(f,H,col,Type);
%PLOTREIM Plot real and imaginary part of complex function
%
%           h = plotreim(f,H,col,Type);
%
%           h       Handle to figure
%
%           f       Frequency axis as column vector
%           H       Complex function(s) (usually frequency response) in columns
%           col     Color string, see PLOT
%           Type    If 'stem', filled stem plots are produced instead of ordinary plots
%
% h=plotreim(f,H)   returns the handle in variable h
% plotreim(f,H)     returns no handle
%
% H must be maximum two dimensions. Also note this function creates a new
% figure object.
% Plot and stem line widths are easily changed in code.
%
% See also PLOTMAGPH


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2012-01-15 Modified to work with Octave if stem and color
% This file is part of ABRAVIBE Toolbox for NVA


if nargout == 0
    figure
else
    h=figure;
end

PlotLineWidth=1;
StemLineWidth=1;

if nargin == 1
    H=f;
    f=1:length(H(:,1));
    subplot(2,1,1)
    plot(f,real(H),'LineWidth',PlotLineWidth);
    ylabel('Real');
    subplot(2,1,2);
    plot(f,imag(H),'LineWidth',PlotLineWidth);
    ylabel('Imaginary');
elseif nargin == 2
    subplot(2,1,1);
    plot(f,real(H),'LineWidth',PlotLineWidth);
    ylabel('Real');
    subplot(2,1,2);
    plot(f,imag(H),'LineWidth',PlotLineWidth);
    ylabel('Imaginary');
elseif nargin == 3
    subplot(2,1,1);
    plot(f,real(H),col,'LineWidth',PlotLineWidth);
    ylabel('Real');
    subplot(2,1,2);
    plot(f,imag(H),col,'LineWidth',PlotLineWidth);
    ylabel('Imaginary');
elseif nargin == 4
    subplot(2,1,1);
    if strcmp(upper(Type),'STEM')
        if strcmp(checksw,'MATLAB')
            stem(f,real(H),col,'filled','LineWidth',StemLineWidth)
        else
            h=stem(f,real(H),'filled','LineWidth',StemLineWidth);
            set(h,'color',col);
        end
    else
        plot(f,real(H),col,'LineWidth',PlotLineWidth);
    end
    ylabel('Real');
    subplot(2,1,2);
    if strcmp(upper(Type),'STEM')
        if strcmp(checksw,'MATLAB')
            stem(f,imag(H),col,'filled','LineWidth',StemLineWidth)
        else
            h=stem(f,imag(H),'filled','LineWidth',StemLineWidth);
            set(h,'color',col);
        end
    else
        plot(f,imag(H),col,'LineWidth',PlotLineWidth);
    end
    ylabel('Imaginary');
else
    error('Wrong number of input parameters!')
end
