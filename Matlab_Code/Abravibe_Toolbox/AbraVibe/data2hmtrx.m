function [H,f,RespDof,RespDir,RefDof,RefDir,FillMtrx] = data2hmtrx(Prefix,StartNo,StopNo,FuncType)
% DATA2HMTRX      Import Abravibe FRF data into H matrix
%
%       [H,f,RespDof,RespDir,RefDof,RefDir,FillMtrx] = data2hmtrx(Prefix,StartNo,StopNo,FuncType)
%
%       H               FRF matrix, N-by-D-by-R
%       RespDof         Row vector with response dofs in 2nd dim in H
%       RespDir         Numeric direction identifier for RespDof (+/- 1,2,3)
%       RefDof          Row vector with Ref dofs in 3rd dim in H
%       RefDir          Numeric direction identifier for RefDof
%       FillMtrx        D-by-R matrix with ones in positions where H is filled
%
%       Prefix          File prefix for Abravibe files
%       StartNo         File number for first file in series
%       StopNo          File number for last file in series
%       FuncType        Optional vector. Only specified FuncType(s) (numeric) are imported
%
% The series of file names from StartNo to StopNo does not need to be
% complete, only existing files are loaded.
%
% NOTE! If impact data with roving Ref are detected (number of refs >
% number of responses), H is automatically transposed and RespDof and
% RefDof are reversed. This means that the code for processing of H
% matrices for curve fitting etc. do not need to take into account whether
% the test was a shaker test or an impact test.
%
% NOTE! For some applications you may need to read both auto and
% cross-spectra or correlation functions; then specify a vector for
% FuncType. For example for (correlation based) OMA, specify function
% types 7 and 8.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23
%          1.1 2012-04-23 Added functionality for filtering single function
%                         type, and to ignore non-Abravibe files
%          1.2 2013-11-28 Fixed sorting also if negative directions measured
%          1.3 2015-12-06 Added functionality for several function types
% This file is part of ABRAVIBE Toolbox for NVA

Count=1;
h=waitbar(0,'Importing functions');
for n=StartNo:StopNo
    waitbar(n/(StopNo-StartNo),h)
    FileName=strcat(Prefix,int2str(n));
    if exist(strcat(FileName,'.mat'),'file') == 2
        % Check if file is an abravibe file, i.e. it contains a variable
        % "Header"
        s=whos('-file',FileName,'Header');
        if isempty(s)
            % ignore file, it is not an abravibe file
        else
            % Check if FuncType is specified, if so only read file if
            % correponding header type
            LoadFile=false;
            if exist('FuncType','var')
                load(FileName,'Header')
                if ismember(Header.FunctionType,FuncType)
                    LoadFile=true;
                end
            else
                LoadFile=true;      % FuncType is not specified, so read regardless of what it is
            end
            if LoadFile
%                 fprintf('loading %s...\n',FileName)
                load(FileName)
                RespDof(Count)=Header.Dof;
                RespDir{Count}=Header.Dir;
                if isfield(Header,'RefDof')
                    RefDof(Count)=Header.RefDof;
                    RefDir{Count}=Header.RefDir;
                elseif isfield(Header,'ForceDof')
                    RefDof(Count)=Header.ForceDof;
                    RefDir{Count}=Header.ForceDir;
                end
                Htemp(:,Count)=Data;
                Count=Count+1;
            end
        end
    end
end
close(h)

% Check that at least some file was found, else quit
if Count == 1
    error('No file was found!')
end

% Combine Dof and Dir info into unique numbers by adding a digit at end of
% Dof info.
% The direction number is +/-1 to +/- 3, so we use last (least significant)
% integer plus the sign to indicate direction
Rdd=dofdir2n(RespDof,RespDir);
Fdd=dofdir2n(RefDof,RefDir);
% Count unique ref and response dofs
NoRefs=length(unique(Fdd));
NoResps=length(unique(Rdd));
N=length(Data);

% Sort into 3D H matrix N-by-D-by-R, freqs, responses, by Refs
H=zeros(N,NoResps,NoRefs);              % Data matrix
FillMtrx=zeros(NoResps,NoRefs);         % Filled when FRF found, to check availability of all Dofs
% 2013-11-28: Fixed sort algorithm to give ascending dof number also if
% negative directions
a=unique(Fdd);
[dum,I]=sort(abs(a));
UniqueRefs=a(I);                        % List of unique combined Ref dof/dir
%                                       % These are indexes into 3rd dim in H
a=unique(Rdd);
[dum,I]=sort(abs(a));
UniqueResps=a(I);                       % Index into 2nd dim in H
for n = 1:length(Rdd)
    Refidx=find(UniqueRefs == Fdd(n));
    respidx=find(UniqueResps == Rdd(n));
    if isequal(H(:,respidx,Refidx),zeros(N,1))
        H(:,respidx,Refidx)=Htemp(:,n);
        FillMtrx(respidx,Refidx)=1;
    else
        warning(['Duplicate FRF found for resp=' int2str(Rdd(n)) ', Ref=' int2str(Fdd(n)) '. Ignored.']);
    end
end
% Fill numeric response and Ref dof vectors
[RespDof,RespDir]=n2dofdir(UniqueResps);
[RefDof,RefDir]=n2dofdir(UniqueRefs);

% Detect if impact test with roving Ref: if so, the matrix is permuted
% to 'shaker format' using reciprocity, and Resp and Ref variables swapped
if NoResps < NoRefs
    H=permute(H,[1 3 2]);
    a=RefDof;
    b=RefDir;
    RefDof=RespDof;
    RefDir=RespDir;
    RespDof=a;
    RespDir=b;
    FillMtrx=FillMtrx';
end

if ~isequal(FillMtrx, ones(size(FillMtrx)))
    warning('Missing Dofs in H matrix! Check output in FillMtrx.')
end

% Create f axis
f=makexaxis(H(:,1,1),Header.xIncrement);