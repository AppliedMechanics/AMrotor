function n = unv_skip(fid);
% function n = unv_skip(fid);
% 
% Reads records from a universal file without action. Returns to main program 
% when a line starting with -1 is encountered, or when EOF is reached.
% The parameter n contains number of lines which are skipped.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

r=fgetl(fid);
n=1;
while (isempty(findstr(r(1:min(6,length(r))),'-1'))) & ~feof(fid)
   r=fgetl(fid);
   n=n+1;
end