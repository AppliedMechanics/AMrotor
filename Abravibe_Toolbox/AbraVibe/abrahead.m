function status = abrahead(Header)
% ABRAHEAD  Check if header structure is a valid ABRAVIBE header
%
%       status = abrahead(Header)
%
%       status      Logical output (1 if Header IS an ABRAVIBE header)
%
%       Header      Structure
%
% This is an internal function used by abrabrowse

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2012-01-10  
% This file is part of ABRAVIBE Toolbox for NVA

if ~isstruct(Header)
    status=false;
else
    if ~isfield(Header,'FunctionType') | ~isfield(Header,'NoValues') |...
            ~isfield(Header,'xStart') | ~isfield(Header,'xIncrement') |...
            ~isfield(Header,'Unit') | ~isfield(Header,'Dof') |...
            ~isfield(Header,'Dir') | ~isfield(Header,'Label') |...
            ~isfield(Header,'Title') 
        status=false;
    else
        status=true;
    end
end