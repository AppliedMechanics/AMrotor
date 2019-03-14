function [TLine,THeader] = unvr82(fid)
% UNVR55    Read SDRC universal file trace line record
%
%       Nodes = unvr82(fid); 
%
% This function reads one dataset, type 82 (trace lines).
% 
% Output:	
%		TLine       Vector with nodes, 0 means "pen up"
%       THeader     Trace line header, structure with
%       .Number     Trace line no
%       .Label      Trace line label
%       .Color      Trace line color
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

%-----------------------------------------------------------------------------------------------
% Records are repeated for each node
%L=fgetl(fid);                       % Until last -1 of dataset is read
L=fgetl(fid);
THeader.Number=sscanf(L(1:10),'%i');
NumberValues=sscanf(L(11:20),'%i');
THeader.Color=sscanf(L(21:30),'%i');
L=fgetl(fid);
THeader.Label=sscanf(L,'%s');
TLineIdx=1;
for n=1:ceil(NumberValues/8)
    L=fgetl(fid);
    for m = 1:8
        if (n-1)*8+m <= NumberValues
            TLine(TLineIdx)=sscanf(L((m-1)*10+1:m*10),'%i');
            TLineIdx=TLineIdx+1;
        end
    end
end  
L=fgetl(fid);       % Read last -1 of this dataset
%-----------------------------------------------------------------------------------------------

