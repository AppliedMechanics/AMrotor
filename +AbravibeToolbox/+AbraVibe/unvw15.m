function Status = unvw15(fid,GEOMETRY); 
% UNVR55    Write SDRC universal file nodes record
%
%       Nodes = unvr15(fid,Nodes,NodesHeader); 
%
% This function reads one dataset, type 15 (Nodes).
% 
% Output:	
%		GEOMETRY is a struct with the following fields
%		     .node
%            .x             X coordinate
%            .y             Y coordinate
%            .z             Z coordinate
%            .conn          trace line
%
% Note! Local coordinate systems are not supported. All nodes are supposed
% to be defined in the same, global coordinate system

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

SetStartStr='    -1';
fprintf(fid,'%-80s\n',SetStartStr);
fprintf(fid,'%6i\n',15);
C=8;        % Color
I='%10i';
E='%13.5E';

%-----------------------------------------------------------------------------------------------
% Records are repeated for each node
for n=1:length(GEOMETRY.node)
    c=fprintf(fid,[I I I I E E E '\n'],GEOMETRY.node(n),0,0,C,GEOMETRY.x(n),GEOMETRY.y(n),GEOMETRY.z(n));
end
%-----------------------------------------------------------------------------------------------
fprintf(fid,'%-80s\n',SetStartStr);
if c < 0
    Status = c;
else
    Status = 1;
end
