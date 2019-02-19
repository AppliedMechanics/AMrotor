function h = plotmac(MAC,p1,p2,str1,str2)
% PLOTMAC   Plot Manhattan type MAC matrix plot
%
%       h = plotmac(MAC,p1,p2)
%
%       h       Handle to figure (vector)
%
%       MAC     Mac matrix from amac
%       p1      Poles for first mode shape matrix
%       p2      Poles for second mode shape matrix (if several)
%       str1    String with label for axis of p1
%       str2    String with label for axis of p2
%
% plotmac(MAC)        generates a plot with modes numbered by 1, 2, 3,...
% plotmac(MAC,p)      generates a plot of an Auto-MAC with frequencies as tick marks
% plotmac(MAC,p1,p2)  generates a plot of a Cross-MAC with different frequencies on the x- and y-axes
% plotmac(MAC,p1,p2,str1,str2) as plotmac(MAC,p1,p2) with labels for p1 and p2 
%
% See also AMAC

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2013-03-13 Added support for axis labels
% This file is part of ABRAVIBE Toolbox for NVA

h=bar3(MAC);
[N,M]=size(MAC);
% Color bars after height
for m = 1:M
    zdata = ones(6*N,4);
    k = 1;
    for n = 0:6:(6*N-6)
        zdata(n+1:n+6,:) = MAC(k,m);
        k = k+1;
    end
    set(h(m),'Cdata',zdata);
end
% colormap('default')
colormap('jet');        % Changed 2015-05-19 for MATLAB 2015a compatibility
colorbar

if nargin ==1
    title('Auto MAC matrix')
elseif nargin == 2
    fr1=poles2fz(p1);
    for n=1:length(fr1)
        T{n}=sprintf('%4.1f',fr1(n));
    end
    xticks(gca,1:length(fr1));
    yticks(gca,1:length(fr1));
    set(gca,'XTickLabel',T);
    set(gca,'YTickLabel',T);
    title('Cross MAC matrix');
elseif nargin == 3
    fr1=poles2fz(p1);
    fr2=poles2fz(p2);
    for n=1:length(fr1)
        Tx{n}=sprintf('%4.1f',fr1(n));
    end
    for n=1:length(fr2)
        Ty{n}=sprintf('%4.1f',fr2(n));
    end
    set(gca,'XTickLabel',Ty)
    set(gca,'YTickLabel',Tx)
    title('Cross MAC matrix')
elseif nargin == 5  % Added 2013-03-13
    fr1=poles2fz(p1);
    fr2=poles2fz(p2);
    for n=1:length(fr1)
        Tx{n}=sprintf('%4.1f',fr1(n));
    end
    for n=1:length(fr2)
        Ty{n}=sprintf('%4.1f',fr2(n));
    end
    set(gca,'XTickLabel',Ty)
    set(gca,'YTickLabel',Tx)
    title('Cross MAC matrix')
    xlabel(str1)
    ylabel(str2)
end
axis('tight')