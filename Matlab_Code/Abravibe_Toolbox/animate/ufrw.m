function [ufOut,dsnID] = ufrw(action,varargin);
%
%   UFRW.M - Read/write universal file format.
%   Supports DSN : 15,18,55,58,58b,82,151,164
%
%   [uf,dsnID]=ufrw(''load'',fileName)
%     uf       : universal file data in a structured array.
%     dsnID    : column vector of DSN
%     fileName : location of universal file to load
%
%   ufrw(''save'',fileName,uff,type)
%     uff      : universal file data in a structured array
%     fileName : location to save universal file
%     type     : ['ascii' | {'binary'}]
%
%  06-July-2005\n

switch action
    case 'load'  % LOAD =====================================================================
        fileName    = varargin{1};
        
        % Check for valid file
        if exist(fileName)~=2
            error('File does not exist. Exiting.')
            ufOut   = [];
            return
        end
        
        % Load UF
        [uf,info]=readuff(fileName);
        
        % Check for UF data
        if isempty(uf)
            error('No UFF data found. Exiting.')
            ufOut   = [];
            return
        end
        
        % Parse UF dataset
        for ii=1:length(uf)
            ufOut{ii,1}     = parseData(uf{ii});
            ufOut{ii,1}.UID = ii;
        end
        if nargout>1
            for rec=1:length(ufOut)
                dsnID(rec,1)    = [ufOut{rec}.DSN];
            end
        end
        
        
    case 'save'  % SAVE =====================================================================
        if nargin<3
            error('??? Not enought input arguments.');
            return
        end
        fileName    = varargin{1};
        uf          = varargin{2};
        
        if nargin>3
            type = varargin{end};
            if strcmp(type,'ascii')
                binary  = 0;
            elseif strcmp(type,'binary')
                binary = 1;
            else
                warning('Unrecognized UFF format.  Defaulting to "binary".')
            end
        else
            % Unspecified defaults to binary
            binary  = 1;
        end

        
        for ii=1:length(uf)
            ufOut{ii,1}     = unparseData(uf{ii},binary);
            if ufOut{ii,1}.dsType==151
                ufOut{ii,1}.dateSaved   = datestr(now,1);
                ufOut{ii,1}.timeSaved   = datestr(now,13);
            end
        end
        
        info    = writeuff(fileName,ufOut,'replace');
        ufOut   = 1;
        dsnID   = 1;
        
end

function ud = unparseData(U,binary); % UNPARSE =====================================================
switch U.DSN
    case 15 % NODES
        ud.dsType   = U.DSN;
        for n=1:length(U.Node)
            ud.nodeN(n,1)           = U.Node(n,1).Label;
            ud.defCS(n,1)           = U.Node(n,1).defCS;
            ud.dispCS(n,1)          = U.Node(n,1).dispCS;
            ud.color(n,1)           = U.Node(n,1).Color;
            ud.x(n,1)               = U.Node(n,1).Crd(1);
            ud.y(n,1)               = U.Node(n,1).Crd(2);
            ud.z(n,1)               = U.Node(n,1).Crd(3);
        end
        ud.binary               = binary;
        
    case 18 % COORDINATE SYSTEM
        ud  = U;
        ud.binary   = binary;
        
    case 55 % NODAL DATA
        ud.dsType           = U.DSN;
        ud.modelType        = U.modelType;
        ud.analysisType     = U.analysisType;
        ud.dataCharacter    = U.dataChar; 
        ud.responseType     = U.specificType;
        switch ud.analysisType
            case 2  % NORMAL MODES
                %ud.modeNum          = U.Int(2);
                %ud.modeFreq
                %ud.modeMass
                %ud.mode_v_damping_ratio
                %ud.mode_h_damping_ratio
                
            case {3,7} % COMPLEX MODES
                ud.modeNum          = U.Int(2);
                ud.eigVal           = U.Real(1)+U.Real(2)*j;
                ud.modalA           = U.Real(3)+U.Real(4)*j;
                ud.modalB           = U.Real(5)+U.Real(6)*j;
                
            case 5  % FREQUENCY RESPONSE
                %ud.freqNum
                %ud.freq
        end
        for n=1:length(U.Node);
            ud.nodeNum(n,1) = U.Node(n).Num;
            ud.r1(n,1)      = U.Node(n).Data(1);
            ud.r2(n,1)      = U.Node(n).Data(2);
            ud.r3(n,1)      = U.Node(n).Data(3);
            %ud.r4(n,1)      = 0;
            %ud.r5(n,1)      = 0;
            %ud.r6(n,1)      = 0;
        end
        ud.ID_1     = U.ID{1};
        ud.ID_2     = U.ID{2};
        ud.ID_3     = U.ID{3};
        ud.ID_4     = U.ID{4};
        ud.ID_5     = U.ID{5};
        ud.binary   = binary;
        
    case 58 % MEASUREMENT
        ud.dsType           = U.DSN;
        ud.functionType     = U.Type;
        ud.number           = U.Number;
        ud.version          = U.Version;
        ud.loadCaseId       = U.LoadCase;
        ud.rspEntName       = U.Response.Name;
        ud.rspNode          = U.Response.Node;
        ud.rspDir           = U.Response.Dir;
        ud.refEntName       = U.Reference.Name;
        ud.refNode          = U.Reference.Node;
        ud.refDir           = U.Reference.Dir;
        ud.xmin             = U.AbscissaMinimum;
        ud.dx               = U.AbscissaIncrement;
        ud.Abscissa         = U.Abscissa;
        ud.OrdinateNumer    = U.OrdinateNumer;
        ud.OrdinateDenom    = U.OrdinateDenom;
        ud.Zaxis            = U.Zaxis;
        ud.measData         = U.DataValues.';
        ud.x                = U.AbscissaValues;
        ud.ID_1             = U.ID{1};
        ud.ID_2             = U.ID{2};
        ud.ID_3             = U.ID{3};
        ud.ID_4             = U.ID{4};
        ud.ID_5             = U.ID{5};
        ud.binary   = binary;
        
    case 82 % TRACELINES
        ud.dsType   = U.DSN;
        ud.ID       = U.ID;
        ud.traceNum = U.TraceNum;
        ud.color    = U.Color;
        ud.lines    = U.Trace.';
        ud.binary   = binary;
        
    case 151 % HEADER
        ud.dsType       = U.DSN;
        ud.modelName    = U.ModelFileName;
        ud.description  = U.ModelFileDescription;
        ud.dbApp        = U.ProgramDB;
        ud.dateCreated  = U.DateCreated;
        ud.timeCreated  = U.TimeCreated;
        ud.dbVersion1   = U.Version1;
        ud.dbVersion2   = U.Version2;
        ud.fileType     = U.FileType;
        ud.dateSaved    = U.DateSaved;
        ud.timeSaved    = U.TimeSaved;
        ud.uffApp       = U.ProgramUF;
        ud.binary       = binary;
        
    case 164 % UNITS
        ud.dsType           = U.DSN;
        ud.unitsCode        = U.UnitsCode;
        ud.unitsDescription = U.UnitsDescription;
        ud.tempMode         = U.TempMode;
        ud.facLength        = U.Length;
        ud.facForce         = U.Force;
        ud.facTemp          = U.Temperature;
        ud.facTempOffset    = U.TemperatureOffset;
        ud.binary           = binary;
        
end

function ud = parseData(U); % PARSE =========================================================

switch U.dsType
    case 151 % HEADER
        ud.DSN                  = U.dsType;
        ud.UID                  = 0;
        ud.EXT                  = [];
        ud.ModelFileName        = U.modelName;
        ud.ModelFileDescription = U.description;
        ud.ProgramDB            = U.dbApp;
        ud.DateCreated          = U.dateCreated;
        ud.TimeCreated          = U.timeCreated;
        ud.Version1             = U.dbVersion1;
        ud.Version2             = U.dbVersion2;
        ud.FileType             = U.fileType;
        ud.DateSaved            = U.dateSaved;
        ud.TimeSaved            = U.timeSaved;
        ud.ProgramUF            = U.uffApp;
        ud.DateWritten          = U.dateSaved;      % DNE
        ud.TimeWritten          = U.timeSaved;      % DNE
        
    case 164  % UNITS
        ud.DSN                  = U.dsType;
        ud.UID                  = 0;
        ud.EXT                  = [];
        ud.UnitsCode            = U.unitsCode;
        ud.UnitsDescription     = U.unitsDescription;
        ud.TempMode             = U.tempMode;
        ud.Length               = U.facLength;
        ud.Force                = U.facForce;
        ud.Temperature          = U.facTemp;
        ud.TemperatureOffset    = U.facTempOffset;

    case 15 % NODES
        ud.DSN                  = U.dsType;
        ud.UID                  = 0;
        ud.EXT                  = [];
        for n=1:length(U.nodeN)
            ud.Node(n,1).Label  = U.nodeN(n,1);
            ud.Node(n,1).defCS  = U.defCS(n,1);
            ud.Node(n,1).dispCS = U.dispCS(n,1);
            ud.Node(n,1).Color  = U.color(n,1);
            ud.Node(n,1).Crd    = [U.x(n,1) U.y(n,1) U.z(n,1)];
        end
        
    case 82 % TRACELINES
        ud.DSN      = U.dsType;
        ud.UID      = 0;
        ud.EXT      = [];
        ud.ID       = U.ID;
        ud.TraceNum = U.traceNum;
        ud.Color    = U.color;
        ud.Trace    = U.lines.';

    case 58 % DATA
        ud.DSN                  = U.dsType;
        ud.UID                  = 0;
        ud.EXT                  = [];
        ud.ID{1,1}              = U.ID_1;
        ud.ID{1,2}              = U.ID_2;
        ud.ID{1,3}              = U.ID_3;
        ud.ID{1,4}              = U.ID_4;
        ud.ID{1,5}              = U.ID_5;
        ud.Type                 = U.functionType;
        ud.Number               = U.number;
        ud.Version              = U.version;
        ud.LoadCase             = U.loadCaseId;
        ud.Response.Name        = U.rspEntName;
        ud.Response.Node        = U.rspNode;
        ud.Response.Dir         = U.rspDir;
        ud.Reference.Name       = U.refEntName;
        ud.Reference.Node       = U.refNode;
        ud.Reference.Dir        = U.refDir;
        ud.AbscissaMinimum      = U.xmin;
        ud.AbscissaIncrement    = U.dx;
        ud.ZaxisValue           = 0;
        ud.Abscissa             = U.Abscissa;
        ud.OrdinateNumer        = U.OrdinateNumer;
        ud.OrdinateDenom        = U.OrdinateDenom;
        ud.Zaxis                = U.Zaxis;
        ud.DataValues           = U.measData.';
        ud.AbscissaValues       = U.x;
        
    case 18 % COORDINATE SYSTEM DATA
        ud.DSN  = U.dsType;
        ud.UID  = 0;
        ud.EXT  = [];
        ud.CS   = U.CS;
        
        
    case 55 % NODAL DATA
        ud.DSN          = U.dsType;
        ud.UID          = 0;
        ud.EXT          = [];
        ud.ID{1,1}      = U.ID_1;
        ud.ID{2,1}      = U.ID_2;
        ud.ID{3,1}      = U.ID_3;
        ud.ID{4,1}      = U.ID_4;
        ud.ID{5,1}      = U.ID_5;
        ud.modelType    = U.modelType;
        ud.analysisType = U.analysisType;
        ud.dataChar     = U.dataCharacter; 
        ud.specificType = U.responseType; % REC 6
        ud.Int          = [1 U.modeNum];
        ud.Real         = [real(U.eigVal) imag(U.eigVal) real(U.modalA) imag(U.modalA) real(U.modalB) imag(U.modalB)];
        for n=1:length(U.nodeNum);
            ud.Node(n).Num  = U.nodeNum(n);
            ud.Node(n).Data = [U.r1(n) U.r2(n) U.r3(n)];
        end
end


%==========================================================================
%========================     READUFF      ================================
%==========================================================================
function [UffDataSets,Info,errmsg] = readuff(fileName)

UffDataSets = [];
Info.errcode = [];
Info.nDataSets = 0;
Info.dsTypes = [];
Info.binary = [];
Info.errmsg = [];
Info.nErrors = 0;
errmsg = [];

%--------------
% Some variables
%--------------
errN = 0;               % current global error number (data-set number independant)

try
    fid = fopen(fileName,'r');
    if fid == -1,
        errN = errN + 1;
        errmsg{errN,1} = ['could not open file: ' fileName];
        disp(errmsg{errN});
        return
    end
    FILE_DATA = (fread(fid,'char=>char')).';
catch
    errN = errN + 1;
    errmsg{errN,1} = ['error reading file contents: ' lasterr];
    disp(errmsg{errN});
    % Close the file
    fclose(fid);
    return
end
% Close the file
err = fclose(fid);
if err == -1
    errN = errN + 1;
    errmsg{errN,1} = 'error while closing file';
    disp(errmsg{errN});
end

ind = strfind(FILE_DATA,'    -1');
nBlocks = floor(length(ind)/2);
if nBlocks < 1
    errN = errN + 1;
    errmsg{errN,1} = 'No valid blocks found';
    disp(errmsg{errN});
    return
end
blocks = zeros(nBlocks,2);
blocks(:,1) = ind(1:2:end).';
blocks(:,2) = ind(2:2:end).'-1;

dataSetN = 0;       % counts VALID data-sets (including non-supported ones)
try
    for ii=1:nBlocks
        
        [data_set_type,DataSetProp,blockLines,errMessage] = get_block_prop(blocks(ii,1),blocks(ii,2),FILE_DATA);
        if ~isempty(errMessage)
            errN = errN + 1;
            errmsg{errN,1} = errMessage;
            continue
        end
        
        dataSetN = dataSetN + 1;
        if data_set_type == 58      % Function at nodal dof
            [ds_data,ds_errmsg] = extract58(fileName,FILE_DATA,blockLines,DataSetProp);
        elseif data_set_type == 15  % Coordinate data
            [ds_data,ds_errmsg] = extract15(FILE_DATA,blockLines);
        elseif data_set_type == 151 % Header data
            [ds_data,ds_errmsg] = extract151(FILE_DATA,blockLines);
        elseif data_set_type == 164 % Units data
            [ds_data,ds_errmsg] = extract164(FILE_DATA,blockLines);
        elseif data_set_type == 82  % Display Sequence data
            [ds_data,ds_errmsg] = extract82(FILE_DATA,blockLines);
        elseif data_set_type == 55  % Modal data file
            [ds_data,ds_errmsg] = extract55(FILE_DATA,blockLines);
        elseif data_set_type == 18  % Coord Sys data
            [ds_data,ds_errmsg] = extract18(fileName,FILE_DATA,blockLines,DataSetProp);
        else
            ds_data = [];
            ds_errmsg = ['unknown data-set (' num2str(data_set_type)  ') found in ' num2str(ii) '-th data-set '];
        end
        
        UffDataSets{dataSetN,1} = ds_data;
        UffDataSets{dataSetN,1}.dsType = data_set_type;
        UffDataSets{dataSetN,1}.binary = DataSetProp.binary;
        Info.errmsg{dataSetN,1} = ds_errmsg;
        Info.dsTypes(dataSetN,1) = data_set_type;
        Info.binary(dataSetN,1) = DataSetProp.binary;
        if isempty(ds_errmsg)
            Info.errcode(dataSetN,1) = 0;
        else
            Info.errcode(dataSetN,1) = 1;
        end
    end
    
catch
    errN = errN + 1;
    errmsg{errN,1} = lasterr;      
end

Info.nErrors = length(find(Info.errcode));
Info.nDataSets = dataSetN;
Info.errorMsgs = Info.errmsg(find(Info.errcode));

if ~isempty(errmsg)
    for ii=1:length(errmsg)
        disp(errmsg{ii});
    end
end


%--------------------------------------------------------------------------
function [dataSet,DataSetProp,blockLines,errMessage] = get_block_prop(so,eo,FILE_DATA)
errMessage = [];
try
    blockData = FILE_DATA(so:eo);
    dataLen = length(blockData);
    lineBreaks = find(blockData==10 | blockData==13);

    fromInd = ones(length(lineBreaks),1);
    toInd = ones(length(lineBreaks),1);
    for ii=2:length(toInd)
        if (lineBreaks(ii)-1) == lineBreaks(ii-1)
            toInd(ii) = 0;
        end
        if (lineBreaks(ii-1)+1) == lineBreaks(ii)
            fromInd(ii-1) = 0;
        end
    end
    from = ([1 lineBreaks(find(fromInd))+1])';
    to = (lineBreaks(find(toInd))-1)';
    if from(end) >= dataLen
        from(end) = [];
    end
    if (dataLen > to(end)+1) & (lineBreaks(end)~=dataLen)
        to = [to ; dataLen];
    end
    
    if length(to)>length(from)
        to  = to(1:length(from));
    else
        from    = from(1:length(to));
    end
    
    % Local blockLines
    blockLines = [from to];

    dataSetLine = blockData(blockLines(2,1):blockLines(2,2));
    dataSet = sscanf(dataSetLine(1:6),'%i',1);
    if isempty(dataSet)
        errMessage = ['invalid data-set type specification found'];
        return
    end
    
    if length(dataSetLine) < 7
        format = '';
    else
        format = sscanf(dataSetLine(7),'%c',1);
    end
    
    if strcmpi(format,'b')
        DataSetProp.binary = 1;
        DataSetProp.byteOrdering = sscanf(dataSetLine(8:13),'%i',1);
        DataSetProp.fpFormat = sscanf(dataSetLine(14:19),'%i',1);
        DataSetProp.nAsciiLines = sscanf(dataSetLine(20:31),'%i',1);
        DataSetProp.nBytes = sscanf(dataSetLine(32:43),'%i',1);
        if length(dataSetLine)>=68
            DataSetProp.d1 = sscanf(dataSetLine(44:49),'%i',1);
            DataSetProp.d2 = sscanf(dataSetLine(50:55),'%i',1);
            DataSetProp.d3 = sscanf(dataSetLine(56:67),'%i',1);
            DataSetProp.d4 = sscanf(dataSetLine(68:end),'%i',1);
        else
            DataSetProp.d1 = [];
            DataSetProp.d2 = [];
            DataSetProp.d3 = [];
            DataSetProp.d4 = [];
        end
    else
        DataSetProp.binary = 0;
    end
    
    % Global blockLines (with respect to FILE_DATA)
    blockLines = blockLines(3:end,:) + so - 1;
    if size(blockLines,1) < 2
        errMessage = ['empty data block found'];
        return
    end
    
catch
    errMessage = ['error reading data-set properties: ' lasterr];
    return
end




%--------------------------------------------------------------------------
function [UFF,errMessage] = extract18(fileName,DATA,blockLines,DataSetProp)
% #18 - Extract coordinate system data
UFF = [];
errMessage = [];
lineN = 1;
nLines = size(blockLines,1);

try
    % Line 1
    tmpLine = DATA(blockLines(1,1):blockLines(1,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    UFF.CS.Number       = sscanf(tmpLine(1:10),'%i',1);      % Field 1
    UFF.CS.Type         = sscanf(tmpLine(11:20),'%i',1);     % Field 2
    UFF.CS.refNumber    = sscanf(tmpLine(21:30),'%i',1);    % field 3
    UFF.CS.Color        = sscanf(tmpLine(31:40),'%i',1);    % Field 4
    UFF.CS.defMethod    = sscanf(tmpLine(41:50),'%i',1);    % Field 4
    lineN = lineN + 1;

    % Line 2
    tmpLine     = DATA(blockLines(1,1):blockLines(1,2));
    tmpLine     = [tmpLine repmat(' ',1,80-length(tmpLine))];
    UFF.Name    = sscanf(tmpLine(1:20),'%s',1);
    lineN = lineN + 1;

    % Line 3
    tmpLine         = DATA(blockLines(3,1):blockLines(3,2));
    tmpLine         = [tmpLine repmat(' ',1,80-length(tmpLine))];
    tmp             = sscanf(tmpLine,'%g',6);
    UFF.CS.Origin   = tmp(1:3).';
    UFF.CS.Xaxis    = tmp(4:6).';
    
    % Line 4
    tmpLine         = DATA(blockLines(4,1):blockLines(4,2));
    tmpLine         = [tmpLine repmat(' ',1,80-length(tmpLine))];
    tmp             = sscanf(tmpLine,'%g',3);
    UFF.CS.XZplane  = tmp(1:3).';
    
    
catch
    errMessage = ['error reading header data at line ' num2str(lineN) ' relatively to current data-set'];
    return
end


%--------------------------------------------------------------------------
function [UFF,errMessage] = extract58(fileName,DATA,blockLines,DataSetProp)
% #58 - Extract data-set type 58 data

UFF = [];
UFF.measData = [];
errMessage = [];
lineN = 1;
nLines = size(blockLines,1);

try
    UFF.ID_1 = sscanf(DATA(blockLines(1,1):blockLines(1,2)),'%c',80);    lineN = lineN + 1;
    UFF.ID_2 = sscanf(DATA(blockLines(2,1):blockLines(2,2)),'%c',80);    lineN = lineN + 1;
    UFF.ID_3 = sscanf(DATA(blockLines(3,1):blockLines(3,2)),'%c',80);    lineN = lineN + 1;
    UFF.ID_4 = sscanf(DATA(blockLines(4,1):blockLines(4,2)),'%c',80);    lineN = lineN + 1;
    UFF.ID_5 = sscanf(DATA(blockLines(5,1):blockLines(5,2)),'%c',80);    lineN = lineN + 1;

    % Line 6
    tmpLine = DATA(blockLines(6,1):blockLines(6,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    UFF.functionType    = sscanf(tmpLine(1:5),'%i',1);      % Field 1
    UFF.number          = sscanf(tmpLine(6:15),'%i',1);     % Field 2
    UFF.version         = sscanf(tmpLine(16:20),'%i',1);    % field 3
    UFF.loadCaseId      = sscanf(tmpLine(21:30),'%i',1);    % Field 4
    if UFF.loadCaseId ~= 0,
        errMessage = ['need single point excitation at: ' num2str(lineN)];
        return
    end
    UFF.rspEntName = sscanf(tmpLine(32:41),'%s',1);
    UFF.rspNode = sscanf(tmpLine(42:51),'%i',1);
    UFF.rspDir = sscanf(tmpLine(52:55),'%i',1);
    UFF.refEntName = sscanf(tmpLine(57:66),'%s',1);
    UFF.refNode = sscanf(tmpLine(67:76),'%i',1);
    UFF.refDir = sscanf(tmpLine(77:80),'%i',1);
    lineN = lineN + 1;

    % Line 7; data form
    tmpLine = DATA(blockLines(7,1):blockLines(7,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    ordDataType = sscanf(tmpLine(1:10),'%i',1);
    numpt = sscanf(tmpLine(11:20),'%i',1);
    spacingType = sscanf(tmpLine(21:30),'%i',1);
    if spacingType ~= 1,
        errMessage = ['need evenly spaced frequency/time at:' num2str(lineN)];
        return
    end
    UFF.xmin = sscanf(tmpLine(31:43),'%g',1);
    UFF.dx = sscanf(tmpLine(44:56),'%g',1);
    zValue = sscanf(tmpLine(57:69),'%g',1);
    lineN = lineN + 1;

    % Line 8; abscissa data characteristics
    tmpLine = DATA(blockLines(8,1):blockLines(8,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    abDataType = sscanf(tmpLine(1:10),'%i',1);
    if ~(abDataType == 18 | abDataType == 17 | abDataType),  % Frequency, time, or unknown
        errMessage = ['need frequency, time, or unknown data on abcissa at:' num2str(lineN)];
        return
    end
    UFF.Abscissa.Type           = abDataType;
    UFF.Abscissa.LengthUnitsExp = sscanf(tmpLine(11:15),'%i',1);
    UFF.Abscissa.ForceUnitsExp  = sscanf(tmpLine(16:20),'%i',1);
    UFF.Abscissa.TempUnitsExp   = sscanf(tmpLine(21:25),'%i',1);
    UFF.Abscissa.Label          = sscanf(tmpLine(27:46),'%s',1);
    UFF.Abscissa.UnitsLabel     = sscanf(tmpLine(48:end),'%s',1);
    lineN = lineN + 1;

    % Line 9; Ordinate (or ordinate numerator) Data Characteristics
    tmpLine = DATA(blockLines(9,1):blockLines(9,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    ordNumeratorDataType = sscanf(tmpLine(1:10),'%i',1);
    UFF.OrdinateNumer.Type          = ordNumeratorDataType;
    UFF.OrdinateNumer.LengthUnitsExp= sscanf(tmpLine(11:15),'%i',1);
    UFF.OrdinateNumer.ForceUnitsExp = sscanf(tmpLine(16:20),'%i',1);
    UFF.OrdinateNumer.TempUnitsExp  = sscanf(tmpLine(21:25),'%i',1);
    UFF.OrdinateNumer.Label         = sscanf(tmpLine(27:46),'%s',1);
    UFF.OrdinateNumer.UnitsLabel    = sscanf(tmpLine(48:end),'%s',1);
    lineN = lineN + 1;

    % Line 10; Ordinate Denominator Data Characteristics
    tmpLine = DATA(blockLines(10,1):blockLines(10,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    ordDenominatorDataType = sscanf(tmpLine(1:10),'%i',1);
    UFF.OrdinateDenom.Type          = ordDenominatorDataType;
    UFF.OrdinateDenom.LengthUnitsExp= sscanf(tmpLine(11:15),'%i',1);
    UFF.OrdinateDenom.ForceUnitsExp = sscanf(tmpLine(16:20),'%i',1);
    UFF.OrdinateDenom.TempUnitsExp  = sscanf(tmpLine(21:25),'%i',1);
    UFF.OrdinateDenom.Label         = sscanf(tmpLine(27:46),'%s',1);
    UFF.OrdinateDenom.UnitsLabel    = sscanf(tmpLine(48:end),'%s',1);
    lineN = lineN + 1;

    % Line 11; Z-axis Data Characteristics
    tmpLine = DATA(blockLines(11,1):blockLines(11,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    UFF.Zaxis.Type          = sscanf(tmpLine(1:10),'%i',1);
    UFF.Zaxis.LengthUnitsExp= sscanf(tmpLine(11:15),'%i',1);
    UFF.Zaxis.ForceUnitsExp = sscanf(tmpLine(16:20),'%i',1);
    UFF.Zaxis.TempUnitsExp  = sscanf(tmpLine(21:25),'%i',1);
    UFF.Zaxis.Label         = sscanf(tmpLine(27:46),'%s',1);
    UFF.Zaxis.UnitsLabel    = sscanf(tmpLine(48:end),'%s',1);
    lineN = lineN + 1;

    % Line 12 ...; Data Values
    if DataSetProp.binary
        if DataSetProp.byteOrdering == 1; format = 'l'; else; format = 'b'; end;
        if (ordDataType==2 | ordDataType==5);
            prec = 'float32';
            numLen = 4;
        else
            prec = 'double';
            numLen = 8;
        end
        fid = fopen(fileName,'r',format);
        if fid == -1
            errMessage = ['could not reopen file for binary data reading: ' fileName];
            return
        end
        status = fseek(fid, blockLines(12,1)-1, 'bof');
        if status
            errMessage = ['could not start reading binary data from ' fileName];
            return
        end
        values = fread(fid, round(DataSetProp.nBytes/numLen), prec);
        fclose(fid);
    else
        values = sscanf(DATA(blockLines(12,1):blockLines(end,2)),'%g');
    end
    
    % In all cases, even abscissa is assumed
    if (ordDataType == 2 | ordDataType == 4)        % real, single or double precision
        UFF.measData = values;
    elseif (ordDataType == 5 | ordDataType == 6)    % complex, single or double precision
        UFF.measData = values(1:2:end-1) + j*values(2:2:end);
    else
        errMessage = ['error reading measurement data at:' num2str(lineN)];
        return
    end
    nVal = length(UFF.measData);
    % Abscissa
    UFF.x = [ UFF.xmin : UFF.dx : (nVal-1)*UFF.dx ];
catch
    errMessage = ['error reading measurement data: ' lasterr];
    return
end


%--------------------------------------------------------------------------
function [UFF,errMessage] = extract151(DATA,blockLines)
% #151 - Extract data-set type 151 data

UFF = [];
errMessage = [];
lineN = 1;
nLines = size(blockLines,1);

try
    UFF.modelName = sscanf(DATA(blockLines(1,1):blockLines(1,2)),'%c',80);    lineN = lineN + 1;
    UFF.description = sscanf(DATA(blockLines(2,1):blockLines(2,2)),'%c',80);    lineN = lineN + 1;
    UFF.dbApp = sscanf(DATA(blockLines(3,1):blockLines(3,2)),'%c',80);    lineN = lineN + 1;
    tmpLine = DATA(blockLines(4,1):blockLines(4,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    UFF.dateCreated = sscanf(tmpLine(1:10),'%s',10);
    UFF.timeCreated = sscanf(tmpLine(11:20),'%s',10);
    UFF.dbVersion1  = sscanf(tmpLine(21:30),'%i',10);
    UFF.dbVersion2  = sscanf(tmpLine(31:40),'%i',10);
    UFF.fileType    = sscanf(tmpLine(41:50),'%i',10);
    lineN = lineN + 1;       
    % Line 5
    tmpLine = DATA(blockLines(5,1):blockLines(5,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    UFF.dateSaved = sscanf(tmpLine(1:10),'%s',10);
    UFF.timeSaved = sscanf(tmpLine(11:20),'%s',10);
    lineN = lineN + 1;       
    % Line 6
    UFF.uffApp = sscanf(DATA(blockLines(6,1):blockLines(6,2)),'%c',80);
catch
    errMessage = ['error reading header data at line ' num2str(lineN) ' relatively to current data-set'];
    return
end


%--------------------------------------------------------------------------
function [UFF,errMessage] = extract164(DATA,blockLines)
% #164 - Extract data-set type 164 data
UFF = [];
errMessage = [];
lineN = 1;
nLines = size(blockLines,1);
try
    % Line 1
    tmpLine = DATA(blockLines(1,1):blockLines(1,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    UFF.unitsCode = sscanf(tmpLine(1:10),'%i');    
    UFF.unitsDescription = sscanf(tmpLine(11:31),'%c');
    UFF.tempMode = sscanf(tmpLine(32:41),'%i');
    lineN = lineN + 1;
    % Line 2
    tmpLine = DATA(blockLines(2,1):blockLines(2,2));
    tmpLine = lower([tmpLine repmat(' ',1,80-length(tmpLine))]);
    tmpLine = strrep(tmpLine,'d-','e-');
    tmpLine = strrep(tmpLine,'d+','e+');
    UFF.facLength = sscanf(tmpLine(1:25),'%f');
    UFF.facForce = sscanf(tmpLine(26:50),'%f');
    UFF.facTemp = sscanf(tmpLine(51:75),'%f');
    lineN = lineN + 1;
    % Line 3
    tmpLine = DATA(blockLines(3,1):blockLines(3,2));
    tmpLine = lower([tmpLine repmat(' ',1,80-length(tmpLine))]);
    tmpLine = strrep(tmpLine,'d-','e-');
    tmpLine = strrep(tmpLine,'d+','e+');
    UFF.facTempOffset = sscanf(tmpLine(1:25),'%f');
catch
    errMessage = ['error reading units data at line' num2str(lineN) ' relatively to current data-set: ' lasterr];
    return
end



%--------------------------------------------------------------------------
function [UFF,errMessage] = extract15(DATA,blockLines)
% #15 - Extract data-set type 15 data

UFF = [];
errMessage = [];
nLines = size(blockLines,1);

try
    values = sscanf(DATA(blockLines(1,1):blockLines(end,2)),'%g');
    nVals = length(values);
    nNodes = round(nVals/7);
    values = reshape(values,7,nNodes).';
    %
    UFF.nodeN = round(values(:,1));
    UFF.defCS = round(values(:,2));
    UFF.dispCS = round(values(:,3));
    UFF.color = round(values(:,4));
    UFF.x = values(:,5);
    UFF.y = values(:,6);
    UFF.z = values(:,7);
catch
    errMessage = ['error reading coordinate data: ' lasterr];
    return
end



%--------------------------------------------------------------------------
function [UFF,errMessage] = extract82(DATA,blockLines)
% #82 - Extract display sequence data-set type 82 data

UFF = [];
errMessage = [];
lineN = 1;
nLines = size(blockLines,1);
try
    % Line 1
    tmpLine = DATA(blockLines(1,1):blockLines(1,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    UFF.traceNum = sscanf(tmpLine(1:10),'%i',1);
    UFF.nNodes = sscanf(tmpLine(11:20),'%i',1);
    UFF.color = sscanf(tmpLine(21:30),'%i',1);    lineN = lineN + 1;
    UFF.ID = sscanf(DATA(blockLines(2,1):blockLines(2,2)),'%c');    lineN = lineN + 1;
    UFF.lines = sscanf(DATA(blockLines(3,1):blockLines(end,2)),'%g');
catch
    errMessage = ['error reading trace-line data at line' num2str(lineN) ' relatively to current data-set: ' lasterr];
    return
end



%--------------------------------------------------------------------------
function [UFF,errMessage] = extract55(DATA,blockLines)
% #55 - Extract modal data-set type 55 data

UFF = [];
errMessage = [];
lineN = 1;
nLines = size(blockLines,1);
errN = 0;

try
    UFF.ID_1 = sscanf(DATA(blockLines(1,1):blockLines(1,2)),'%c',80);    lineN = lineN + 1;
    UFF.ID_2 = sscanf(DATA(blockLines(2,1):blockLines(2,2)),'%c',80);    lineN = lineN + 1;
    UFF.ID_3 = sscanf(DATA(blockLines(3,1):blockLines(3,2)),'%c',80);    lineN = lineN + 1;
    UFF.ID_4 = sscanf(DATA(blockLines(4,1):blockLines(4,2)),'%c',80);
    UFF.ID_5 = sscanf(DATA(blockLines(5,1):blockLines(5,2)),'%s',1);
    lineN = lineN + 1;
    tmpLine = DATA(blockLines(6,1):blockLines(6,2));
    tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
    UFF.modelType = sscanf(tmpLine(1:10),'%i',1);
    lineN = lineN + 1;
    if UFF.modelType ~=1,
        errMessage = ['not structural model type (line: ' num2str(lineN) ' relatively to current data-set)'];
        return
    end
    UFF.analysisType = sscanf(tmpLine(11:20),'%i',1);
    UFF.dataCharacter = sscanf(tmpLine(21:30),'%i',1);
    UFF.responseType = sscanf(tmpLine(31:40),'%i',1);
    UFF.dataType = sscanf(tmpLine(41:50),'%i',1);
    num_data_per_pt = sscanf(tmpLine(51:60),'%s',1);

    % Read records 7 and 8 which are analysis-type dependant
    if UFF.analysisType == 2  % Normal Mode
        % Line 7
        tmpLine = DATA(blockLines(7,1):blockLines(7,2));
        tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
        two = sscanf(tmpLine(1:10),'%i',1);
        lineN = lineN + 1;
        if two ~= 2,
            errMessage = ['unexpected value at line ' num2str(lineN) ' relatively to current data-set'];
            return
        end
        four = sscanf(tmpLine(11:20),'%i',1);
        if four ~= 4,
            errMessage = ['unexpected value at line: ' num2str(lineN) ' relatively to current data-set'];
            return
        end
        tmp = sscanf(tmpLine(21:30),'%i',1);
        UFF.modeNum = sscanf(tmpLine(31:40),'%i',1);
        % Line 8
        tmpLine = DATA(blockLines(8,1):blockLines(8,2));
        tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
        lineN = lineN + 1;
        UFF.modeFreq = sscanf(tmpLine(1:13),'%g',1);
        UFF.modeMass = sscanf(tmpLine(14:26),'%g',1);
        UFF.mode_v_damping_ratio = sscanf(tmpLine(27:39),'%g',1);
        UFF.mode_h_damping_ratio = sscanf(tmpLine(40:52),'%g',1);

    elseif UFF.analysisType == 3, % Complex Eigenvalue, First Order (Displacement)
        % Line 7
        tmpLine = DATA(blockLines(7,1):blockLines(7,2));
        tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
        lineN = lineN + 1;
        two = sscanf(tmpLine(1:10),'%i',1);
        if two ~= 2,
            errMessage = ['unexpected value at line ' num2str(lineN) ' relatively to current data-set'];
            return
        end
        six = sscanf(tmpLine(11:20),'%i',1);
        if six ~= 6,
            errMessage = ['unexpected value at line: ' num2str(lineN) ' relatively to current data-set'];
            return
        end
        tmp = sscanf(tmpLine(21:30),'%i',1);
        UFF.modeNum = sscanf(tmpLine(31:40),'%i',1);

        % Line 8
        tmpLine = DATA(blockLines(8,1):blockLines(8,2));
        tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
        lineN = lineN + 1;
        real_part = sscanf(tmpLine(1:13),'%g',1);
        imaginary_part = sscanf(tmpLine(14:26),'%g',1);
        UFF.eigVal = real_part + j * imaginary_part;
        real_part = sscanf(tmpLine(27:39),'%g',1);
        imaginary_part = sscanf(tmpLine(40:52),'%g',1);
        UFF.modalA = real_part + j * imaginary_part;
        real_part = sscanf(tmpLine(53:65),'%g',1);
        imaginary_part = sscanf(tmpLine(66:78),'%g',1);
        UFF.modalB = real_part + j * imaginary_part;

    elseif UFF.analysisType == 5, % Frequency Response
        % Line 7
        tmpLine = DATA(blockLines(7,1):blockLines(7,2));
        tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
        lineN = lineN + 1;
        two = sscanf(tmpLine(1:10),'%i',1);
        if two ~= 2,
            errMessage = ['unexpected value at line ' num2str(lineN) ' relatively to current data-set'];
            return
        end
        one = sscanf(tmpLine(11:20),'%i',1);
        if one ~= 1,            
            errMessage = ['unexpected value at line ' num2str(lineN) ' relatively to current data-set'];
            return
        end
        tmp = sscanf(tmpLine(21:30),'%i',1);
        UFF.freqNum = sscanf(tmpLine(31:40),'%i',1);

        % Line 8
        tmpLine = DATA(blockLines(8,1):blockLines(8,2));
        tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
        lineN = lineN + 1;
        UFF.freq = sscanf(tmpLine(1:13),'%g',1);    % in Hz

    elseif UFF.analysisType == 7  % Complex Eigenvalue, Second Order (Velocity)
        % Line 7
        tmpLine = DATA(blockLines(7,1):blockLines(7,2));
        tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
        lineN = lineN + 1;
        two = sscanf(tmpLine(1:10),'%i',1);
        if two ~= 2,
            errMessage = ['unexpected value at line ' num2str(lineN) ' relatively to current data-set'];
            return
        end
        six = sscanf(tmpLine(11:20),'%i',1);
        if six ~= 6,
            errMessage = ['unexpected value at line ' num2str(lineN) ' relatively to current data-set'];
            return
        end
        tmp = sscanf(tmpLine(21:30),'%i',1);
        UFF.modeNum = sscanf(tmpLine(31:40),'%i',1);

        % Line 8
        tmpLine = DATA(blockLines(8,1):blockLines(8,2));
        tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
        lineN = lineN + 1;
        real_part = sscanf(tmpLine(1:13),'%g',1);
        imaginary_part = sscanf(tmpLine(14:26),'%g',1);
        UFF.eigVal = real_part + j * imaginary_part;
        real_part = sscanf(tmpLine(27:39),'%g',1);
        imaginary_part = sscanf(tmpLine(40:52),'%g',1);
        UFF.modalA = real_part + j * imaginary_part;
        real_part = sscanf(tmpLine(53:65),'%g',1);
        imaginary_part = sscanf(tmpLine(66:78),'%g',1);
        UFF.modalB = real_part + j * imaginary_part;

    else
        errMessage = ['analysis type is not supported at line ' num2str(lineN) ' relatively to current data-set'];
        return
    end

    % Read response data by x,y,...components into r1..r6
    ii = 0;
    nnodes = floor((nLines-9)/2)+1;
    r1 = zeros(nnodes,1);
    r2 = r1;
    r3 = r1;
    r4 = r1;
    r5 = r1;
    r6 = r1;
    nodeNum = r1;
    for lne = 9:2:nLines-1,
        ii = ii + 1;
        %========
        %    line = 9; % line 9 type of line
        %========
        lineRead = lne;
        tmpLine = DATA(blockLines(lineRead,1):blockLines(lineRead,2));
        nodeNum(ii) = sscanf(tmpLine(1:10),'%i',1);
        lineN = lineN + 1;

        %========
        %    line = 10; % line 9 type of line
        %========
        lineRead = lne + 1;
        lineN = lineN + 1;
        tmpLine = DATA(blockLines(lineRead,1):blockLines(lineRead,2));
%         tmpLine = [tmpLine repmat(' ',1,80-length(tmpLine))];
        if UFF.dataType == 2,       % real data
            r1(ii) = sscanf(tmpLine(1:13),'%g',1);
            r2(ii) = sscanf(tmpLine(14:26),'%g',1);
            r3(ii) = sscanf(tmpLine(27:39),'%g',1);
            if num_data_per_pt == 6,
                r4(ii) = sscanf(tmpLine(40:52),'%g',1);
                r5(ii) = sscanf(tmpLine(53:65),'%g',1);
                r6(ii) = sscanf(tmpLine(66:78),'%g',1);
            end
        elseif UFF.dataType == 5,   % complex data
            p1 = sscanf(tmpLine(1:13),'%g',1);
            p2 = sscanf(tmpLine(14:26),'%g',1);
            r1(ii) = p1 + j * p2;
            p3 = sscanf(tmpLine(27:39),'%g',1);
            p4 = sscanf(tmpLine(40:52),'%g',1);
            r2(ii) = p3 + j * p4;
            p5 = sscanf(tmpLine(53:65),'%g',1);
            p6 = sscanf(tmpLine(66:78),'%g',1);
            r3(ii) = p5 + j * p6;
            if num_data_per_pt == 6,
                errMessage = ['not setup to handle six coordinate of complex data at line ' num2str(lineN) ' relatively to current data-set'];
                return
            end
        else
            errMessage = ['what kind of data type was that at line ' num2str(lineN) ' relatively to current data-set?'];
            return
        end
    end
    UFF.r1 = r1;
    UFF.r2 = r2;
    UFF.r3 = r3;
    UFF.r4 = r4;
    UFF.r5 = r5;
    UFF.r6 = r6;
    UFF.nodeNum = nodeNum;
catch
    errMessage = ['error reading modal data: ' lasterr];
    return
end


%==========================================================================
%=======================     WRITEUFF      ================================
%==========================================================================
function Info = writeuff(fileName,UffDataSets,action)
error(nargchk(2,3,nargin));
if nargin < 3 || isempty(action)
    action = 'add';
end
if ~iscell(UffDataSets)
    error('UffDataSets must be given as a cell array of structures');
end

%--------------
% Open the file for writing
%--------------
if strcmpi(action,'replace')
    [fid,ermesage] = fopen(fileName,'w');
else
    [fid,ermesage] = fopen(fileName,'a');
end
if fid == -1,
    error(['could not open file: ' fileName]);
end

%--------------
% Go through all the data sets and write each data set according to its type
%--------------
nDataSets = length(UffDataSets);

Info.errcode = zeros(nDataSets,1);
Info.errmsg = cell(nDataSets,1);
Info.nErrors = 0;

for ii=1:nDataSets
    try
        %
        switch UffDataSets{ii}.dsType
            case {15,82,55,58,151,164}
                fprintf(fid,'%6i%s',-1,char(10));
                switch UffDataSets{ii}.dsType
                    case 15
                        Info.errmsg{ii} = write15(fid,UffDataSets{ii});
                    case 18
                        Info.errmsg{ii} = write18(fid,UffDataSets{ii});
                    case 82
                        Info.errmsg{ii} = write82(fid,UffDataSets{ii});
                    case 55
                        Info.errmsg{ii} = write55(fid,UffDataSets{ii});
                    case 58
                        Info.errmsg{ii} = write58(fid,UffDataSets{ii});
                    case 151
                        Info.errmsg{ii} = write151(fid,UffDataSets{ii});
                    case 164
                        Info.errmsg{ii} = write164(fid,UffDataSets{ii});
                end
                fprintf(fid,'%6i%s',-1,char(10));
            otherwise
                Info.errmsg{ii} = ['Unsupported data set: ' num2str(UffDataSets{ii}.dsType)];
        end
        %
    catch
        fclose(fid);
        error(['Error writing uff file: ' fileName ': ' lasterr]);
    end
end
fclose(fid);

for ii=1:nDataSets
    if ~isempty(Info.errmsg{ii})
        Info.errcode(ii) = 1;
    end
end
Info.nErrors = length(find(Info.errcode));
Info.errorMsgs = Info.errmsg(find(Info.errcode));

%--------------------------------------------------------------------------
function errMessage = write15(fid,UFF)
% #15 - Write data-set type 15 data
errMessage = [];
if ispc
    F_13 = '%13.4E';
else
    F_13 = '%13.5E';
end
try
    n = length(UFF.nodeN);
    if ~isfield(UFF,'defCS');   UFF.defCS = zeros(n,1);  end;
    if ~isfield(UFF,'dispCS');  UFF.dispCS = zeros(n,1); end;
    if ~isfield(UFF,'color');   UFF.color = zeros(n,1);  end;
    fprintf(fid,'%6i%s',15,char(10));
    for ii=1:n
        fprintf(fid,['%10i%10i%10i%10i' F_13 F_13 F_13 '%s'],UFF.nodeN(ii),UFF.defCS(ii),UFF.dispCS(ii),UFF.color(ii), ...
            UFF.x(ii),UFF.y(ii),UFF.z(ii),char(10));
    end
catch
    errMessage = ['error writing coordinate data: ' lasterr];
end
%-----------------------------------------------------------------

%--------------------------------------------------------------------------
function errMessage = write82(fid,UFF)
% #82 - Write data-set type 82 data
errMessage = [];
try
    if ~isfield(UFF,'ID');      UFF.ID = 'NONE'; end;
    if ~isfield(UFF,'color');   UFF.color = 0;  end;
    fprintf(fid,'%6i%s',82,char(10));
    fprintf(fid,'%10i%10i%10i%s',UFF.traceNum,length(UFF.lines),UFF.color,char(10));  % line 1
    fprintf(fid,'%-s%s',UFF.ID,char(10)); % line 2
    fprintf(fid,'%10i%10i%10i%10i%10i%10i%10i%10i\n',UFF.lines); % line 3
    if rem(length(UFF.lines),8)~=0,
        fprintf(fid,'%s',char(10));
    end
catch
    errMessage = ['error writing display-sequence data: ' lasterr];
end
%-----------------------------------------------------------------


%--------------------------------------------------------------------------
function errMessage = write55(fid,UFF)
% #55 - Write data-set type 55 data
if ispc
    F_13 = '%13.4e';
else
    F_13 = '%13.5e';
end
errMessage = [];
try
    if isfield(UFF,'r4') & isfield(UFF,'r5') & isfield(UFF,'r6')
        num_data_per_pt = 6;
    else
        num_data_per_pt = 3;
    end

    fprintf(fid,'%6i%s',55,char(10));
    fprintf(fid,'%-s%s',UFF.ID_1,char(10)); %line 1
    fprintf(fid,'%-s%s',UFF.ID_2,char(10)); %line 2
    fprintf(fid,'%-s%s',UFF.ID_3,char(10)); %line 3
    fprintf(fid,'%-s%s',UFF.ID_4,char(10)); %line 4
    fprintf(fid,'%-s%s',UFF.ID_5,char(10)); %line 5
    % ASSUME ALWAYS COMPLEX
    %if imag(UFF.r1)~=0 & imag(UFF.r2)~=0 & imag(UFF.r3)~=0,
    %    data_type = 2;
    %else,
        data_type = 5;
    %end
    fprintf(fid,'%10i%10i%10i%10i%10i%10i%s',1,UFF.analysisType,UFF.dataCharacter, ...
        UFF.responseType,data_type,num_data_per_pt,char(10)); %line 6
    if UFF.analysisType == 2,                               % Normal modes
        fprintf(fid,'%10i%10i%10i%10i%s',2,4,0,UFF.modeNum,char(10)); %line 7
        fprintf(fid,[F_13 F_13 F_13 F_13 '%s'], ...
            UFF.modeFreq,UFF.modeMass,UFF.mode_v_damping,UFF.mode_h_damping,char(10)); %line 8
    elseif UFF.analysisType == 5,                           % Frequency Response
        fprintf(fid,'%10i%10i%10i%10i%s',2,1,0,UFF.freqNum,char(10)); %line 7
        fprintf(fid,'%13.4e%s', UFF.freq,char(10)); %line 8
    elseif UFF.analysisType == 3 | UFF.analysisType == 7,   % Complex modes
        fprintf(fid,'%10i%10i%10i%10i%s',2,6,0,UFF.modeNum,char(10)); %line 7
        fprintf(fid,[F_13 F_13 F_13 F_13 F_13 F_13 '%s'], ...
            real(UFF.eigVal),imag(UFF.eigVal),real(UFF.modalA),imag(UFF.modalA), ...
            real(UFF.modalB),imag(UFF.modalB),char(10)); %line 8
    else
        errMessage = ['Unsupported analysis type: ' num2str(UFF.analysisType)];
        return
    end
    if data_type == 2,  % real data
        if num_data_per_pt == 3,
            for k=1:length(UFF.nodeNum);
                fprintf(fid,'%10i%s',UFF.nodeNum(k),char(10));
                fprintf(fid,[F_13 F_13 F_13 '%s'],UFF.r1(k),UFF.r2(k),UFF.r3(k),char(10));
            end
        else,
            for k=1:length(UFF.nodeNum);
                fprintf(fid,'%10i%s',UFF.nodeNum(k),char(10));
                fprintf(fid,[F_13 F_13 F_13 F_13 F_13 F_13 '%s'], ...
                    UFF.r1(k),UFF.r2(k),UFF.r3(k),UFF.r4(k),UFF.r5(k),UFF.r6(k),char(10));
            end
        end
    else,               % complex data
        for k=1:length(UFF.nodeNum);
            fprintf(fid,'%10i%s',UFF.nodeNum(k),char(10));
            fprintf(fid,[F_13 F_13 F_13 F_13 F_13 F_13 '%s'], ...
                real(UFF.r1(k)),imag(UFF.r1(k)), real(UFF.r2(k)),imag(UFF.r2(k)), ...
                real(UFF.r3(k)),imag(UFF.r3(k)),char(10));
        end
    end

catch
    errMessage = ['error writing modal data: ' lasterr];
end
%-----------------------------------------------------------------


%--------------------------------------------------------------------------
function errMessage = write58(fid,UFF)
% #58 - Write data-set type 58 data
if ispc
    F_13 = '%13.4e';
    F_20 = '%20.11e';
else
    F_13 = '%13.5e';
    F_20 = '%20.12e';
end
errMessage = [];
try
    if ~find(UFF.functionType == [1 2 3 4 6])
        errMessage = ['Unsupported function type: ' num2str(UFF.functionType)];
        return
    end
    if UFF.binary
        [filename, mode, machineformat] = fopen(fid);
        if strcmpi(machineformat(1:7),'ieee-le')
            byteOrdering = 1;
        else
            byteOrdering = 2;
        end
        if imag(UFF.measData)==0
            nBytes = length(UFF.measData)*8;
        else
            nBytes = length(UFF.measData)*16;
        end
        fprintf(fid,'%6i%1s%6i%6i%12i%12i%6i%6i%12i%12i%s',58,'b',byteOrdering,2,11,nBytes,0,0,0,0,char(10));
    else
        fprintf(fid,'%6i%s',58,char(10));
    end
    if length(UFF.ID_1)<=80,
        fprintf(fid,'%-s%s',UFF.ID_1,char(10));   %  line 1
    else
        fprintf(fid,'%-s%s',UFF.ID_1(1:80),char(10));   %  line 1
    end
    if length(UFF.ID_2)<=80,
        fprintf(fid,'%-s%s',UFF.ID_2,char(10));   %  line 2
    else
        fprintf(fid,'%-s%s',UFF.ID_2(1:80),char(10));   %  line 2
    end
    if length(UFF.ID_3)<=80,
        fprintf(fid,'%-s%s',UFF.ID_3,char(10));   %  line 3
    else
        fprintf(fid,'%-s%s',UFF.ID_3(1:80),char(10));   %  line 3
    end
    if length(UFF.ID_4)<=80,
        fprintf(fid,'%-s%s',UFF.ID_4,char(10));   %  line 4
    else
        fprintf(fid,'%-s%s',UFF.ID_4(1:80),char(10));   %  line 4
    end
    if length(UFF.ID_5)<=80,
        fprintf(fid,'%-s%s',UFF.ID_5,char(10));   %  line 5
    else
        fprintf(fid,'%-s%s',UFF.ID_5(1:80),char(10));   %  line 5
    end
    %
    fprintf(fid,'%5i%10i%5i%10i %-10s%10i%4i %-10s%10i%4i%s',UFF.functionType,UFF.number,UFF.version,UFF.loadCaseId,UFF.rspEntName,...
        UFF.rspNode,UFF.rspDir,UFF.refEntName,UFF.refNode,UFF.refDir,char(10));    % line 6
    numpt = length(UFF.measData);
    if isreal(UFF.measData)
        fprintf(fid,['%10i%10i%10i' F_13 F_13 F_13 '%s'],4,numpt,1,UFF.xmin,UFF.dx,0,char(10));  % line 7
    else,
        fprintf(fid,['%10i%10i%10i' F_13 F_13 F_13 '%s'],6,numpt,1,UFF.xmin,UFF.dx,0,char(10));  % line 7
    end
    % line 8
    fprintf(fid,'%10i%5i%5i%5i %-20s %-20s%s',UFF.Abscissa.Type,UFF.Abscissa.LengthUnitsExp,UFF.Abscissa.ForceUnitsExp,UFF.Abscissa.TempUnitsExp,UFF.Abscissa.Label,UFF.Abscissa.UnitsLabel,char(10));
    % line 9
    fprintf(fid,'%10i%5i%5i%5i %-20s %-20s%s',UFF.OrdinateNumer.Type,UFF.OrdinateNumer.LengthUnitsExp,UFF.OrdinateNumer.ForceUnitsExp,UFF.OrdinateNumer.TempUnitsExp,UFF.OrdinateNumer.Label,UFF.OrdinateNumer.UnitsLabel,char(10));
    % line 10
    fprintf(fid,'%10i%5i%5i%5i %-20s %-20s%s',UFF.OrdinateDenom.Type,UFF.OrdinateDenom.LengthUnitsExp,UFF.OrdinateDenom.ForceUnitsExp,UFF.OrdinateDenom.TempUnitsExp,UFF.OrdinateDenom.Label,UFF.OrdinateDenom.UnitsLabel,char(10));
    % line 11
    fprintf(fid,'%10i%5i%5i%5i %-20s %-20s%s',UFF.Zaxis.Type,UFF.Zaxis.LengthUnitsExp,UFF.Zaxis.ForceUnitsExp,UFF.Zaxis.TempUnitsExp,UFF.Zaxis.Label,UFF.Zaxis.UnitsLabel,char(10));
    % line 12:
    if UFF.binary
        if isreal(UFF.measData)
            fwrite(fid,UFF.measData,'double');
        else
            indxs=2*[1:length(UFF.measData)];
            newdata(indxs)=imag(UFF.measData);
            newdata(indxs-1)=real(UFF.measData);
            fwrite(fid,newdata,'double');
        end
    else
        if isreal(UFF.measData)
            fprintf(fid,[F_20 F_20 F_20 F_20 '%s'],UFF.measData,char(10));
            newdata=UFF.measData;
        else,
            indxs=2*[1:length(UFF.measData)];
            newdata(indxs)=imag(UFF.measData);
            newdata(indxs-1)=real(UFF.measData);
            fprintf(fid,[F_20 F_20 F_20 F_20 '%s'],newdata,char(10));
        end
        if rem(length(newdata),4)~=0,
            fprintf(fid,'%s',char(10));
        end
    end

catch
    errMessage = ['error writing measurement data: ' lasterr];
end
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
function errMessage = write151(fid,UFF)
% #151 - Write data-set type 151 data
errMessage =[];
try
    fprintf(fid,'%6i%s',151,char(10));
    fprintf(fid,'%-s%s',UFF.modelName,char(10)); % line 1
    fprintf(fid,'%-s%s',UFF.description,char(10)); % line 2
    fprintf(fid,'%-s%s',UFF.dbApp,char(10)); % line 3
    d = datestr(now,1);
    d(end-3:end-2) = [];
    fprintf(fid,'%-10s%-10s%10i%10i%10i%s',UFF.dateCreated,UFF.timeCreated,UFF.dbVersion1,UFF.dbVersion2,0,char(10)); % line 4
    fprintf(fid,'%-10s%-10s%s',UFF.dateSaved,UFF.timeSaved,char(10)); % line 5
    fprintf(fid,'%-s%s',UFF.uffApp,char(10)); % line 6
    fprintf(fid,'%-10s%-10s%s',d,datestr(now,13),char(10)); % line 7
catch
    errMessage = ['error writing header data: ' lasterr];
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function errMessage = write164(fid,UFF)
% #164 - Write data-set type 164 data
errMessage = [];
try
    if ~isfield(UFF,'unitsDescription'); UFF.unitsDescription = ' '; end;
    fprintf(fid,'%6i%s',164,char(10));

    fprintf(fid,'%10i%-20s%10i%s',UFF.unitsCode,UFF.unitsDescription,UFF.tempMode,char(10)); % line 1
    str = upper(sprintf('%25.17e%25.17e%25.17e',UFF.facLength,UFF.facForce,UFF.facTemp)); % line 2
    fprintf(fid,'%s%s',str,char(10));
    str = upper(sprintf('%25.17e',UFF.facTempOffset)); % line 3
    fprintf(fid,'%s%s',str,char(10));
catch
    errMessage = ['error writing units data: ' lasterr];
end
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
function errMessage = write18(fid,UFF)
% #18 - Write data-set type 18 data
errMessage = [];
if ispc
    F_13 = '%13.4e';
else
    F_13 = '%13.5e';
end
try
    fprintf(fid,'%6i%s',18,char(10));
    fprintf(fid,'%10i%10i%10i%10i%10i%s', UFF.CS.Number,UFF.CS.Type,UFF.CS.refNumber,UFF.CS.Color,UFF.CS.defMethod,char(10))
    fprintf(fid,'%-20s%s',UFF.CS.Name,char(10));
    fprintf(fid,[F_13 F_13 F_13 F_13 F_13 F_13 '%s'],UFF.CS.Origin,UFF.CS.Xaxis,char(10));
    fprintf(fid,[F_13 F_13 F_13 '%s'],UFF.CS.XZplane,char(10));
catch
    errMessage = ['error writing coordinate system data: ' lasterr];
end
%--------------------------------------------------------------------------
