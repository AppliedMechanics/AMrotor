function H = frfim2re(Hin);
% FRFRE2IM  Create FRF with Real part from Hilbert transform of imaginary part
%
%           H = frfre2im(Hin);
%
%           H       "Causal" FRF with real part being the Hilbert transform of imag(Hin)
%
%           Hin     Input FRF, only real part is used if complex
%
% Note:     Hin is assumed to contain frequencies from 0 Hz
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Hin=imag(Hin);
H=imag(hilbert(Hin))+j*Hin;
