function Status = unvw55(fid,GEOMETRY); 
% UNVR55    Write SDRC universal file trace line record
%
%       Nodes = unvr82(fid,GEOMETRY); 
%
% This function writes one dataset, type 82 to opened file fid.
% 

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

SetStartStr='    -1';
TraceLine=1;
NumberValues=length(GEOMETRY.conn);
C=8;
ID='Geometry';
I='%10i';
S='%-80s';

%-----------------------------------------------------------------------------------------------
% Records are repeated for each node
fprintf(fid,'%-80s\n',SetStartStr);
fprintf(fid,'%6i\n',82);
fprintf(fid,[I I I '\n'],TraceLine,NumberValues,C);
fprintf(fid,[S '\n'],ID);
GEOMETRY.conn(find(isnan(GEOMETRY.conn)))=0;
Rest= mod(length(GEOMETRY.conn),8);
if Rest ~= 0
    GEOMETRY.conn=[GEOMETRY.conn zeros(1,8-Rest)];
end
for n=1:ceil(NumberValues/8)
    L=sprintf([I I I I I I I I],GEOMETRY.conn((n-1)*8+1:n*8));
    fprintf(fid,[S '\n'],L);
end        
s=fprintf(fid,'%-80s\n',SetStartStr);
%-----------------------------------------------------------------------------------------------
if s > 0
    Status=1;
else
    Status=-1;
end