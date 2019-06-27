function [Pdf, XAx, G, mu, sigma] = apdf(x, N, NPlot);
% APDF      Calculate and plot probability density function, PDF
%
%           [Pdf, XAx, G, mu, sigma] = apdf(x, N, NPlot);
%
%           Pdf         Probability density function of x
%           XAx         Amplitude (x-) axis for Pdf
%           G           Gaussian distribution with same mu and sigma as x
%           mu          mean of x
%           sigma       Standard deviation of x
%
%           x           Time data, in column vector
%           N           Number bins in histogram (number bars in Pdf)
%           NPlot       If = 0, no plot is produced
%                       If = 1, a (lin-lin) plot with G is produced,
%                       If = 2, a semilogy plot with G is produced,
%                       which is often better for classification
%                       purposes (to check if x is Gaussian or not)
%
% Calculates and plots the PDF of x using N bins, and if NPlot=1 or NPlot=2
% also plots the "theoretical" Gauss curve using mean and standard 
% deviation of x. The scaling is so that the surface under Pdf = 1.
%
% With no input parameters, apdf() plots a theoretical Gauss curve for a 
% normalized variable with zero mean and standard deviation of unity,
% z=(x-mu)/sigma.
%
% [Pdf, Xax, G]=apdf(x,N) returns the histogram in Pdf and
% the gauss curve at the center values of Pdf, in G and x axis in XAx.
% If N is not given, a default of 30 bins is used.
%------------------------------------------------------


% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

if nargout == 0
   z=(-5:0.01:5)';
   pz=exp(-z.^2/2)/sqrt(2*pi);
   plot(z,pz)
   ylabel('p(z)')
   xlabel('standardized variable z')
elseif nargout >= 2			% at least Pdf and XAx requested
    if nargin == 1
        N=30;
        NPlot=0;
    elseif nargin == 2
        NPlot=0;
    elseif nargin ~= 3
        error('Too many input parameters!')
    end
    mu=mean(x);
    sigma=std(x);
    XMax=max(x);
    XMin=min(x);
    XMax=max(abs([XMax XMin]));
    XAx=(-XMax:XMax*2/N:XMax)';
    dx=XAx(2)-XAx(1);
    Pdf=hist(x,XAx);
    Pdf=Pdf(:)/length(x)/dx;               % Force to column and 
    G=1./(sqrt(2*pi)*sigma).*exp(-0.5*((XAx-mu)./sigma).^2);
    if NPlot == 1
        figure
        bar(XAx,Pdf);
        if NPlot == 1
            hold on
            G=G;
            plot(XAx,G,'r:')
            hold off
        end
        xlabel('Units of x')
        ylabel('Probability Density')
    elseif NPlot == 2
        figure
        semilogy(XAx,[Pdf G])
        xlabel('Units of x')
        ylabel('Probability Density')
    end
end
