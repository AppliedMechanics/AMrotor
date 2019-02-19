function unvwrite(varargin)
%UNVWRITE Write a universal file
%
% To write test data (measurement functions), the data must first
% be stored in standard ABRAVIBE files named with a prefix and a number. 
% Then use the syntax unvwrite(Prefix,FirstNo,LastNo,OutFileName), to 
% write the functions to a common universal file. All files in the 
% sequence do not have to exist.
%
% To export modal data, the variables GEOMETRY, MODAL, and (optionally)
% MHEADER, must be in the current workspace. Then export the data to a
% universal file by the syntax unvwrite(GEOMETRY,MODAL,OutFileName), or
% unvwrite(GEOMETRY,MODAL,MHEADER,OutFileName). To create a modal header,
% the command makemhead can be used.
%
% See also MAKEMHEAD

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

% Check type of data, TEST or MODAL
if isstr(varargin{1})   % First syntax
    Prefix=varargin{1};
    FirstNo=varargin{2};
    LastNo=varargin{3};
    OutFileName=varargin{4};
    Type='TestData';
else 
    GEOMETRY=varargin{1};
    MODAL=varargin{2};
    if nargin == 3      % Second syntax: make a default header
        for n = 1:length(MODAL)
            MHEADER(n)=makemhead('Default modal header',MODAL(n));
        end
        OutFileName=varargin{3};
    else
        MHEADER=varargin{3};
        OutFileName=varargin{4};
    end
%    OutFileName=varargin{4};
    Type='ModalData';
end

if strcmp(Type,'TestData')  % Save as dataset 58
    fid=fopen(OutFileName,'w');
    for n = FirstNo:LastNo
        InFileName=strcat(Prefix,int2str(n));
        if exist(strcat(InFileName,'.mat'),'file') == 2
            load(InFileName);
            if exist('Data','var') & exist('Header','var')
                if exist('xAxis','var')
                    unvw58(fid,xAxis,Data,Header);
                else
                    unvw58(fid,0,Data,Header);
                end
            end
        end
    end
else
    fid=fopen(OutFileName,'w');
    if fid > 0
        Status=unvw15(fid,GEOMETRY);
        Status=unvw82(fid,GEOMETRY);
        for n = 1:length(MODAL)
            Status=unvw55(fid,MODAL(n),MHEADER(n));
        end
    end
end
fclose(fid);
