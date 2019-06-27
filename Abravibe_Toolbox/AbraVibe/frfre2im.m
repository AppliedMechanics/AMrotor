function H = frfre2im(Hin);
% FRFRE2IM  Create FRF with imaginary part from Hilbert transform of real part
%
%           H = frfre2im(Hin);
%
%           H       "Causal" FRF with imaginary part being the Hilbert transform of real(Hin)
%
%           Hin     Input FRF, only real part is used if complex
%
% Note:     Hin is assumed to contain frequencies from 0 Hz
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

Hin=real(Hin);
H=Hin-j*imag(hilbert(Hin)); 
