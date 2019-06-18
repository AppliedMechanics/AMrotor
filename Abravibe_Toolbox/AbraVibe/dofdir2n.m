function    nDof = dofdir2n(Dof,Dir)
% DOFDIR2N  Convert dof number and dir string to numeric format
%
%           nDof = dofdir2n(DofDir);
%           nDof = dofdir2n(Dof,Dir)
%
%           nDof        Numeric dof/dir number, where last number is
%                       direction and sign(nDof) is the sign of dir
%
%           DofDir      Combined dof and dir string, can be a cell array if
%                       length(DofDir)>1
%           Dof         Point number, can be a vector; if only input        
%           Dir         Direction string, e.g. 'X+' or '+X', can be a cell
%                       array same length as Dof, IF length(Dof)>1
%
% Examples:
% dofdir2n('13Y-') returns -132
% dofdir2n(13,'Y-') returns -132
% dofdir2n({'22y+','234Z-'}) returns the vector [222   -2343]
%
% see also n2dofdir headpstr dir2nbr nbr2dir

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2014-07-15 Added support for input strings of form 'NNX+' etc.
% This file is part of ABRAVIBE Toolbox for NVA

if nargin == 2
    for n = 1:length(Dof)
        a=dir2nbr(Dir{n});
        nDof(n)=sign(a)*(10*Dof(n)+abs(a));         % Dof 13Z- is now -133
    end
elseif nargin == 1
    if ~iscell(Dof)    % Only one input
        % Split into number and dof string
        n=1;
        while ~isempty(str2num(Dof(1:n))) & n < length(Dof)
            n=n+1;
        end
        n=n-1;
        a=dir2nbr(Dof(n+1:end));                    % String part of Dof
        Dof=str2num(Dof(1:n));                      % Numeric part of Dof
        nDof=sign(a)*(10*Dof+abs(a));               % Dof 13Z- is now -133
    else   % Dof is a cell array, thus several 
        SaveDof=Dof;
        for m=1:length(SaveDof)
            Dof=SaveDof{m};
            if ~iscell(Dof)
                % Split into number and dof string
                n=1;
                while ~isempty(str2num(Dof(1:n))) & n < length(Dof)
                    n=n+1;
                end
                n=n-1;
                a=dir2nbr(Dof(n+1:end));                    % String part of Dof
                Dof=str2num(Dof(1:n));                      % Numeric part of Dof
                nDof(m)=sign(a)*(10*Dof+abs(a));         % Dof 13Z- is now -133
            end
        end
    end
end