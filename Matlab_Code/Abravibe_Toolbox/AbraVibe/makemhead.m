function MHEADER = makemhead(Title,MODAL,ModeNumber)
% MAKEMHEAD     Make a default MODAL header
%
%       MHEADER = makemhead(Title,MODAL,ModeNumber)
%
%       MHEADER         Output header record
%
%       Title           Up to 80 character string
%       MODAL           Modal structure, see animate
%       ModeNumber      Integer number
%
% Note! MODAL should contain only ONE record

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

N=length(MODAL);

for n=1:N
    MHEADER(n).Title=sprintf('%-80s',Title);
    MHEADER(n).Title2=sprintf('%-80s','None');
    MHEADER(n).Date=sprintf('%-80s',datestr(now));
    MHEADER(n).Title3=sprintf('%-80s','None');
    MHEADER(n).Title4=sprintf('%-80s','None');
    
    MHEADER(n).ModelType=1;
    if isreal(MODAL(n).X) & isreal(MODAL(n).Y) & isreal(MODAL(n).Z)
        MHEADER(n).AnalysisType=2;     % Normal Mode
        MHEADER(n).DataType=2;         % Real data type
    else
        MHEADER(n).AnalysisType=3;     % Complex Mode
        MHEADER(n).DataType=5;         % Real data type
    end
    MHEADER(n).DataChar=2;             % 3DOF global translation
    MHEADER(n).SpecDataType=8;           % Displacement
    MHEADER(n).NumValuesPerNode=3;
    MHEADER(n).NumIntDataValues=2;
    MHEADER(n).NumRealDataValues=6;
    MHEADER(n).LoadCase=1;
    MHEADER(n).ModeNumber=n;
    MHEADER(n).Eigenvalue=2*pi*MODAL(n).Freq;
    MHEADER(n).ModalA=1;
    MHEADER(n).ModalB=-MHEADER(n).Eigenvalue;
end
