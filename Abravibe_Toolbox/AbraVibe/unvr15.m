function Nodes = unvr55(fid); 
% UNVR55    Read SDRC universal file nodes record
%
%       Nodes = unvr15(fid); 
%
% This function reads one dataset, type 15 (Nodes).
% 
% Output:	
%		Nodes is a struct with the following fields
%		     .Label
%            .X             X coordinate
%            .Y             Y coordinate
%            .Z             Z coordinate
%
% Note! Local coordinate systems are not supported. All nodes are supposed
% to be defined in the same, global coordinate system

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

%-----------------------------------------------------------------------------------------------
% Records are repeated for each node
NodesIdx=1;
L=fgetl(fid);                       % Until last -1 of dataset is read
if strcmp(L,'')
    L=fgetl(fid);                   % Sometimes extra <CR>
end
while isempty(findstr(L,'-1')) | findstr(L,'-1') > 10
    Nodes(NodesIdx).Label=sscanf(L(1:10),'%i');
    Nodes(NodesIdx).X=sscanf(L(41:53),'%g');
    Nodes(NodesIdx).Y=sscanf(L(54:66),'%g');
    Nodes(NodesIdx).Z=sscanf(L(67:79),'%g');
    NodesIdx=NodesIdx+1;
    L=fgetl(fid);                       % Until last -1 of dataset is read
end
%-----------------------------------------------------------------------------------------------

