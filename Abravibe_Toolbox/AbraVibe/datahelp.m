function datahelp
%DATAHELP Prints documentation for Abravibe data storage (Data and Header variables)
%
% In ABRAVIBE toolbox, data are (normally) stored in mat files or mat+wav 
% files with two variables: 'Header', and 'Data'. The variable 'Data' is
% either a column vector with data (time data, spectrum, FRF) from ONE
% channel, or a string with a pointer to a wav file, with extension. 
% (Wav files are not supported yet.)
%
% Time data from Impact testing are stored in a special format, to keep
% information from one impact position and several accelerometers in one
% file for easy processing. This file includes a similar format as for
% single measurements, but the Data variables is a cell array, and the
% header struct includes several records, one for each cell array in Data.
%
%==========================================================================
% Header
%---------------
% The abravibe Header struct is documenting measurement data with the
% following (mostly self explanatory) fields:
%
% Data from single measurement (time data, spectrum etc.)
% Header.
%           FunctionType    Number indication measurement function, see
%                           help for FUNCTYPE for more information
%           DateStr         String with date and time information
%           Title           String with title
%           Title2,...      Additional (optional) title lines can be
%                           included as Title2, Title3, etc.
%           NumberSamples   Length of Data
%           xStart          First x value for x axis (see MAKEXAXIS)
%           xIncrement      Increment for x axis (dt or df, typically)
%           Unit            String with units of Data
%           Dof             Measurement point number
%           Dir             Direction string, e.g. 'X+', see dir2nbr
%           Label           String with label info
%
% PSDs can (should) have additional fields:
%           Method          'Welch', 'SmoothedPer'
%           NumberAverages  Number averages for spectrum
%           OverlapPerc     Overlap Percentage (if Method is 'Welch')
%           SmoothLength    Smoothing window length (if Method is 'SmoothedPer')
%           SmoothWin       String with smoothing window ('boxcar','ahann'...)
%           ENBW            Equivalent  noise bandwidth of window used (see enwb command)
%
% Other frequency domain functions should have
%           NumberAverages  Number averages for spectrum
%           OverlapPerc     Overlap Percentage (if Method is 'Welch')
%           ENBW            Equivalent  noise bandwidth of window used (see enwb command)
%
% Multipoint data as e.g. FRFs, cross spectra etc. have additional fields
%           RefDof          Dof number of (usually) force location (denominator dof)
%           RefDir          Direction string for force (denominator)

help datahelp       

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA
