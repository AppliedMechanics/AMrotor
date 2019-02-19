function abra2modstr(Prefix,FirstNo,LastNo,OutFileName)
% ABRA2MODSTR   Convert ABRAVIBE modal information files into structure
%
%       abra2modstr(Prefix,FirstNo,LastNo,OutFileName)
%
%       Prefix      String prefix for file names to read
%       FirstNo     Number of first file in list
%       LastNo      Number of last file in list
%       OutFileName File name of output file
%
% The output file contains the two structures
% GEOMETRY and MODAL, see menu help for ANIMATE for details

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

for n = FirstNo:LastNo
    InFileName=strcat(Prefix,int2str(n));
    if exist(strcat(InFileName,'.mat'),'file') == 2
        fprintf('Loading file %s...\n',InFileName)
        load(InFileName)
        % Check if file is a modal info file and process
        if exist('Nodes','var') & ~exist('Shape','var')    % File is a converted unv 15 dataset
            fprintf('Found dataset 15 results...\n')
            for n = 1:length(Nodes)
                GEOMETRY.node(n)=Nodes(n).Label;
                GEOMETRY.x(n)=Nodes(n).X;
                GEOMETRY.y(n)=Nodes(n).Y;
                GEOMETRY.z(n)=Nodes(n).Z;
            end
            clear Nodes
        elseif exist('THeader','var')   % File is a converted unv 82 dataset
            fprintf('Found dataset 82 results...\n')
            if isfield(GEOMETRY,'conn')
                GEOMETRY.conn=[GEOMETRY.conn TLine];
            else
                GEOMETRY.conn=TLine;
            end
            GEOMETRY.conn(find(GEOMETRY.conn == 0))=NaN;
            clear THeader TLine
        elseif exist('Shape','var')
            fprintf('Found dataset 55 results...\n')
            if exist('MODAL','var')
                idx=length(MODAL);
            else
                idx=0;
            end
            MODAL(idx+1).Node=Nodes;
            MODAL(idx+1).X=Shape.X;
            MODAL(idx+1).Y=Shape.Y;
            MODAL(idx+1).Z=Shape.Z;
            MODAL(idx+1).Freq=Header.Eigenvalue/(2*pi);
            MHEADER(idx+1)=Header;
            clear Header Nodes Shape
        end
    end
end

if exist('MODAL','var')
    save(OutFileName,'MODAL','GEOMETRY','MHEADER')
elseif exist('GEOMETRY','var')
        save(OutFileName,'GEOMETRY')
end
            
            