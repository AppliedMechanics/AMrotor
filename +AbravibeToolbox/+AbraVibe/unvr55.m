function [Nodes,Shape,Header] = unvr55(fid); 
% UNVR55    Read SDRC universal file mode shape record
%
%       [Nodes,Shape,Header] = unvr55(fid); 
%
% This function reads one dataset, type 55 (Mode shape data).
% 
% Output:	
%		Nodes contains a list of the node numbers of the shape
%		Shape contains shape data in column
%		Header is a struct containing all header information

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

%---------------------------------------------------------------------------------		
% 
% Record 1 - 5, ID lines 
%-----------------------------------------------------------------------------------------------
Header.Title=fgetl(fid);			% ID line 1
if length(Header.Title) == 0
   Header.title=fgetl(fid);         % Sometimes fscanf() in unvread leaves a <CR>
elseif (isspace(Header.Title))
   Header.Title=fgetl(fid);         % If 55 in Function ID was followed by blanks
end
Header.Title2=fgetl(fid);      		% Ditto 2
Header.Date=fgetl(fid);             % ID line 3, normally date and time
Header.Title3=fgetl(fid);			% ...
Header.Title4=fgetl(fid);
	
% Record 6 - Data definition parameters
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
Header.ModelType=sscanf(L(1:10),'%i');          % Model Type
Header.AnalysisType=sscanf(L(11:20),'%i');      % Analysis Type
Header.DataChar=sscanf(L(21:30),'%i');          % Data Characteristic
Header.SpecDataType=sscanf(L(31:40),'%i');      % Specific Data Type
Header.DataType=sscanf(L(41:50),'%i');          % Data Type (2=real, 5=complex)
Header.NumValuesPerNode=sscanf(L(51:60),'%i');	% Number of Data Values Per Node

% Record 7 and 8 are data specific, hence has to be tested here
%-----------------------------------------------------------------------------------------------
L=fgetl(fid);
if Header.AnalysisType == 0                         % Unknown
    Header.NumIntDataValues=sscanf(L(1:10),'%i');	% Number of Integer Data Values
    Header.NumRealDataValues=sscanf(L(11:20),'%i');	% Number of Real Data Values
    Header.IDNumber=sscanf(L(21:30),'%i');          % ID Number
%	Record 8
    L=fgetl(fid);
elseif Header.AnalysisType == 1                     % Static
    Header.NumIntDataValues=sscanf(L(1:10),'%i');	% Number of Integer Data Values
    Header.NumRealDataValues=sscanf(L(11:20),'%i');	% Number of Real Data Values
    Header.LoadCase=sscanf(L(21:30),'%i');          % Load case
%	Record 8
    L=fgetl(fid);
elseif Header.AnalysisType == 2                     % Normal Mode
    Header.NumIntDataValues=sscanf(L(1:10),'%i');	% Number of Integer Data Values
    Header.NumRealDataValues=sscanf(L(11:20),'%i');	% Number of Real Data Values
    Header.LoadCase=sscanf(L(21:30),'%i');          % Load Case
    Header.ModeNumber=sscanf(L(31:40),'%i');        % Mode number
%	Record 8
    L=fgetl(fid);
	Header.Frequency=sscanf(L(1:13),'%g');          % Frequency
	Header.ModalMass=sscanf(L(14:26),'%g');         % Modal Mass
	Header.ViscousDampingRatio=sscanf(L(27:39),'%g');	% Modal Viscous Damping Ratio
	Header.HystereticDampingRatio=sscanf(L(40:52),'%g');	% Modal Hysteretic Damping Ratio
elseif Header.AnalysisType == 3                     % Complex Eigenvalue
    Header.NumIntDataValues=sscanf(L(1:10),'%i');	% =2
    Header.NumRealDataValues=sscanf(L(11:20),'%i');	% =6
    Header.LoadCase=sscanf(L(21:30),'%i');          % Load Case
    Header.ModeNumber=sscanf(L(31:40),'%i');        % Mode number
%	Record 8
    L=fgetl(fid);
	R=sscanf(L(1:13),'%g');                         % Real Part Eigenvalue
	I=sscanf(L(14:26),'%g');                        % Imaginary Part Eigenvalue
    Header.Eigenvalue=R+j*I;
	R=sscanf(L(27:39),'%g');                        % Real Part of Modal A
	I=sscanf(L(40:52),'%g');                        % Imaginary Part of Modal A
    Header.ModalA=R+j*I;
	R=sscanf(L(53:65),'%g');                        % Real Part of Modal B
	I=sscanf(L(66:78),'%g');                        % Imaginary Part of Modal B
    Header.ModalB=R+j*I;
elseif Header.AnalysisType == 4                     % Transient
    Header.NumIntDataValues=sscanf(L(1:10),'%i');	% =2
    Header.NumRealDataValues=sscanf(L(11:20),'%i');	% =1
    Header.LoadCase=sscanf(L(21:30),'%i');          % Load Case
    Header.TimeStepNumber=sscanf(L(31:40),'%i');    % Time Step number
%	Record 8
    L=fgetl(fid);
	Header.Time=sscanf(L(1:13),'%g');               % Time (Seconds)
elseif Header.AnalysisType == 5                     % Frequency Response
    Header.NumIntDataValues=sscanf(L(1:10),'%i');	% =2
    Header.NumRealDataValues=sscanf(L(11:20),'%i');	% =1
    Header.LoadCase=sscanf(L(21:30),'%i');          % Load Case
    Header.TimeStepNumber=sscanf(L(31:40),'%i');    % Frequency Step number
%	Record 8
    L=fgetl(fid);
	Header.Frequency=sscanf(L(1:13),'%g');          % Frequency (Hz)
elseif Header.AnalysisType == 6                     % Buckling
    Header.NumIntDataValues=sscanf(L(1:10),'%i');	% =1
    Header.NumRealDataValues=sscanf(L(11:20),'%i');	% =1
    Header.LoadCase=sscanf(L(21:30),'%i');          % Load Case
%	Record 8
    L=fgetl(fid);
	Header.Eigenvalue=sscanf(L(1:13),'%g');         % Eigenvalue
else
   error('Wrong Analysis Type in mode shape record!')
end

%-----------------------------------------------------------------------------------------------
% Records 9 and 10 are now repeated until data are over
% Data values - check for real or complex data
ShapeRow=1;
NodesRow=1;
NDV=Header.NumValuesPerNode;				% Number of values
Shape=[];
Nodes=[];
L=fgetl(fid);                       % Until last -1 of dataset is read
while isempty(findstr(L,'-1'))
    Nodes(NodesRow)=sscanf(L(1:10),'%i');
    NodesRow=NodesRow+1;
    L=fgetl(fid);
    for n = 1:NDV
        if Header.DataType == 2				% Real Modes
            nstart=(n-1)*13+1;
            nstop=n*13;
            Shape(ShapeRow)=sscanf(L(nstart:nstop),'%g')';		% Data in one row
            ShapeRow=ShapeRow+1;
        elseif Header.DataType == 5									% For complex data - handle this
            nstart=(n-1)*26+1;
            nstop=nstart+12;
            R=sscanf(L(nstart:nstop),'%g');
            nstart=(n-1)*26+14;
            nstop=nstart+12;
            I=sscanf(L(nstart:nstop),'%g');
            Shape(ShapeRow)=R+j*I;
            ShapeRow=ShapeRow+1;
        end
    end
    L=fgetl(fid);                           % Until -1 of dataset is read
end
Nodes=Nodes(:);
Shape=Shape(:);								% Convert to column in Shape
% Convert Shape into structure with x, y, and z information separately
tShape=Shape;
clear Shape
Shape.X=tShape(1:3:end);
Shape.Y=tShape(2:3:end);
Shape.Z=tShape(3:3:end);

%-----------------------------------------------------------------------------------------------

