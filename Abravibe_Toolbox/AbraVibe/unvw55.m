function Status = unvw55(fid,MODAL,MHEADER);
% UNVR55    Write SDRC universal file nodes record
%
%       Nodes = unvw55(fid,MODAL,MHEADER);
%
% This function writes one dataset, type 55 (Mode shapes) to an opened
% universal file.
%
% Currently no header info is written out (to simplify export).

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


SetStartStr='    -1';
fprintf(fid,'%-80s\n',SetStartStr);
fprintf(fid,'%6i\n',55);
C=8;        % Color
I='%10i';
E='%13.5E';

%-----------------------------------------------------------------------------------------------
% Records 1 - 5: ID lines (third is date and time)
fprintf(fid,'%-80s\n',MHEADER.Title);
fprintf(fid,'%-80s\n',MHEADER.Title2);
fprintf(fid,'%-80s\n',MHEADER.Date);
fprintf(fid,'%-80s\n',MHEADER.Title3);
fprintf(fid,'%-80s\n',MHEADER.Title4);


%-----------------------------------------------------------------------------------------------
% Record 6
Rec6.Field1=1;      % Always structural!
Rec6.Field2=MHEADER.AnalysisType;
Rec6.Field3=MHEADER.DataChar;      
Rec6.Field4=MHEADER.SpecDataType;  
Rec6.Field5=MHEADER.DataType;  % Real data type
Rec6.Field6=MHEADER.NumValuesPerNode;      % NDV, Number of data values per node
fprintf(fid,[I I I I I I '\n'],Rec6.Field1,Rec6.Field2,Rec6.Field3,Rec6.Field4,Rec6.Field5,Rec6.Field6);

%-----------------------------------------------------------------------------------------------
% Records 7 and 8 are analysis type dependant
if Rec6.Field2 == 2     % Normal mode (real mode shapes)
    Rec7.Field1=2;
    Rec7.Field2=4;
    Rec7.Field3=MHEADER.LoadCase;      % Load case number
    Rec7.Field4=MHEADER.ModeNumber;
    fprintf(fid,[I I I I '\n'],Rec7.Field1,Rec7.Field2,Rec7.Field3,Rec7.Field4);
    Rec8.Field1=2*pi*real(MODAL.Freq);
    Rec8.Field2=1;      % Unity Modal mass!
    Rec8.Field3=-real(MODAL.Freq)/(abs(MODAL.Freq));
    Rec8.Field4=0;
    fprintf(fid,[E E E E E E '\n'],Rec8.Field1,Rec8.Field2,Rec8.Field3,Rec8.Field4,0,0);
    for m = 1:length(MODAL.Node)
        fprintf(fid,[I '\n'],MODAL.Node(m));
        fprintf(fid,[E E E '\n'],MODAL.X(m),MODAL.Y(m),MODAL.Z(m));
    end
elseif Rec6.Field2 == 3 % Complex mode
    Rec7.Field1=2;
    Rec7.Field2=6;
    Rec7.Field3=MHEADER.LoadCase;      % Load case number
    Rec7.Field4=MHEADER.ModeNumber;
    fprintf(fid,[I I I I '\n'],Rec7.Field1,Rec7.Field2,Rec7.Field3,Rec7.Field4);
    Rec8.Field1=2*pi*real(MODAL.Freq);
    Rec8.Field2=2*pi*imag(MODAL.Freq);
    Rec8.Field3=real(MHEADER.ModalA);          % Unity modal A!
    Rec8.Field4=imag(MHEADER.ModalA);
    Rec8.Field5=real(MHEADER.ModalB);
    Rec8.Field6=imag(MHEADER.ModalB);
    fprintf(fid,[E E E E E E '\n'],Rec8.Field1,Rec8.Field2,Rec8.Field3,Rec8.Field4,Rec8.Field5,Rec8.Field6);
    for m = 1:length(MODAL.Node)
        fprintf(fid,[I '\n'],MODAL.Node(m));
        fprintf(fid,[E E E E E E '\n'],real(MODAL.X(m)),imag(MODAL.X(m)),real(MODAL.Y(m)),imag(MODAL.Y(m)),real(MODAL.Z(m)),imag(MODAL.Z(m)));
    end
end
%-----------------------------------------------------------------------------------------------
fprintf(fid,'%-80s\n',SetStartStr);
Status=1;