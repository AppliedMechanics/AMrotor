function FuncType = functype(FuncType)
% FUNCTYPE  Convert between numeric and string function type
%
%       FuncType = functype(FuncType)
%
%       FuncType    Function type as specified by universal file 58 format
%
% This function converts a numeric function type to a short string
% abbreviation, and vice versa if input FuncType is a string.
% Uppercase/lowercase is not checked when matching string format.
% See inside file for documentation
% 
%
% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2012-01-10  Added flexibility if FuncType input is not
%                          defined
%          1.2 2013-11-16  Added type 30 for Transient spectrum
% This file is part of ABRAVIBE Toolbox for NVA
%
%------------------------------------------------------------------------
% Universal file format 58 definitions:
%         0 - General or Unknown
%         1 - Time Response
%         2 - Auto Spectrum
%         3 - Cross Spectrum
%         4 - Frequency Response Function
%         5 - Transmissibility
%         6 - Coherence
%         7 - Auto Correlation
%         8 - Cross Correlation
%         9 - Power Spectral Density (PSD)
%         10 - Energy Spectral Density (ESD)
%         11 - Probability Density Function
%         12 - Spectrum
%         13 - Cumulative Frequency Distribution
%         14 - Peaks Valley
%         15 - Stress/Cycles
%         16 - Strain/Cycles
%         17 - Orbit
%         18 - Mode Indicator Function
%         19 - Force Pattern
%         20 - Partial Power
%         21 - Partial Coherence
%         22 - Eigenvalue
%         23 - Eigenvector
%         24 - Shock Response Spectrum
%         25 - Finite Impulse Response Filter
%         26 - Multiple Coherence
%         27 - Order Function
%         28 - Phase Compensation
%         29 - Undefined
%         30 - Transient Spectrum

%------------------------------------------------------------------------
% Define short strings
ShortStrings={'Unknown','Time','AutoSpec','CrossSpec','FRF',...
    'Transmissibility','Coherence','AutoCorr','CrossCorr','PSD',...
    'ESD','PDF','Spectrum','CumFreqDistr','PeaksValley',...
    'Stress/Cycles','Strain/Cycles','Orbit','MIF','ForcePattern',...
    'PartPower','PartCoh','Eigenvalue','Eigenvector','SRS',...
    'FIRFilter','MultCoh','Order','PhaseComp','Undefined','TranSpec'};

%------------------------------------------------------------------------
% Start conversion
if isnumeric(FuncType)
    if FuncType <= length(ShortStrings)     % Added 2012-01-10
        FuncType = ShortStrings{1+FuncType};
    else
        FuncType='Unknown';
    end
else
    idx=0;
    for n=1:31      % Changed to 31 in rev 1.2
        if strcmp(upper(FuncType),upper(ShortStrings{n}))
            idx=n;
        end
    end
    if idx > 0
        FuncType=idx-1;
    else
        FuncType=-1;                    % Added 2012-01-10
    end
end