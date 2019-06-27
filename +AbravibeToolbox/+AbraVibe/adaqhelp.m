%ADAQHELP Print some helpful info about data acquisition with ABRAVIBE
% 
% ABRAVIBE Data acquisition information
%
% There is some, limited, support for data acquisition in ABRAVIBE,
% provided that you have MATLAB Data Acquisition Toolbox. Type 
% >>help abravibe
% and look for the Data acquisition section, to find the available
% functions.
%
% You can use either the PC soundcard, or some hardware from National
% Instruments (NI). The files are hardcoded for NI, but include some lines
% that can be edited if you would prefer to get data from the soundcard.
%
% Data format
% The ABRAVIBE data format consists of two parts:
% Data
%       The data vector is either a variable 'Data', where data is in a
%       column vector, or
%       a wave file with one channel of data. This format is suitable for
%       very long files, for which the data would fill the memory of
%       MATLAB. If this format is used, the 'Data' variable contains a
%       RELATIVE file name path to the wave file. This format is ONLY
%       supported for time data.
% Header
%       The header information is stored in a structure named Header and
%       with self explanatory fields for header values. In case the wave
%       file format is used for data, the Header applies to the data in the
%       wave file.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

help adaqhelp
