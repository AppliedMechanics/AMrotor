% IMPACTHELP    Overview help for impact testing
%
% The time data impact testing implemented in the ABRAVIBE toolbox uses
% data stored in files with extension '.imptime', where the force is
% located in the first array in data array Data{1}, and response
% measurements in subsequent arrays in Data{*}.
%
% The impact processing is made in two steps:
% 1) Setup stage, where the processing parameters are determined. This is
% done by the IMPSETUP command, which produces a file <FileName>.impsetup
% in which the FFT parameters to be used are stored in a structure.
% IMPSETUP uses one of the measurement files.
% 2) A processing stage where all files with time data are processed into
% files with frequency response, coherence, and force spectra. This is done
% by the command IMPPROC, which requires a setup file from a run with
% IMPSETUP. IMPPROC can be run either in manual mode, which requires
% interaction for each data file, to choose which impacts are used for the
% processing, or an automatic mode which tries to create the 'best'
% coherence out of the impacts available.
%
% Reference:
% See Chapter 13 in Brandt (2011): Noise and Vibration Analysis: Signal
% Analysis and Experimental Procedures, John Wiley and Sons. ISBN
% 978-0470746448

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

help impacthelp