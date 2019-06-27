function listpoles(p1,p2,str1,str2)
% LISTPOLES     List undamped natural frequencies and damping factors
%
%       listpoles(p1,p2,str1,str2)
%
%       p1      First set of poles
%       p2      Second (optional) set of poles
%       str1    Optional. String with text for frequency and damping first columns
%       str2    Optional. String with text for frequency and damping second columns
%
% If two sets of poles, a comparison table is produced

% Copyright (c) 2009-2012 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2012-11-23
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 1
    [fr,zr]=poles2fz(p1);
    fprintf('List of Undamped frequencies and damping \n');
    fprintf('Natural Freq. [Hz]    Damping [%%]\n')
    fprintf('---------------------------------\n')
    for n = 1:length(fr)
        fprintf('%10.3f \t\t %12.3f\n',fr(n),100*zr(n));
    end
elseif nargin == 2 | nargin == 4
    [fr1,zr1]=poles2fz(p1);
    [fr2,zr2]=poles2fz(p2);
    if isreal(j*p1)
        fprintf('List of Undamped frequencies\n');
        fprintf('%20s%20s\n','Natural Frequencies [Hz]','Difference [%]');
        if nargin == 2
        elseif nargin == 4
            fprintf('%10s \t%10s \n',str1,str2)
        end
        fprintf('----------------------------------------------------------\n')
        fd=100*(fr1 - fr2)./fr1;
        for n = 1:length(fr1)
            fprintf('%10.3f \t%10.3f \t\t\t %8.2f \n',fr1(n),fr2(n),fd(n));
        end
    else
        fprintf('List of Undamped frequencies and damping \n');
        fprintf('%20s%20s%20s\n','Natural Frequencies [Hz]','Damping [%]','Difference [%]');
        if nargin == 2
            fprintf('%50s%10s%10s\n',' ','Frequency','Damping')
        elseif nargin == 4
            fprintf('%10s \t%10s \t\t\t %5s\t %5s\t %10s%10s\n',str1,str2,str1,str2,'Frequency','Damping')
        end
        fprintf('----------------------------------------------------------\n')
        fd=100*(fr1 - fr2)./fr1;
        zd=100*(zr1 - zr2)./zr1;
        for n = 1:length(fr1)
            fprintf('%10.3f \t%10.3f \t\t\t %5.2f\t %5.2f \t %8.2f %8.2f\n',fr1(n),fr2(n),100*zr1(n),100*zr2(n),fd(n),zd(n));
        end
    end
end
    