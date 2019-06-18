function [NewPoles,a_factor] = wincomp(OldPoles,N,fs,EndPercent)
% WINCOMP       Compensate poles due to exponential window from Impact testing
%
%       [NewPoles,a_factor] = wincomp(Oldpoles,N,fs,EndPercent)
%
%       NewPoles            New relative damping factor(s) in column vector
%       a_factor            The factor used from exp. window, w(t) = exp(-a * t)
%
%       OldPoles            Old pole value(s) in column vector
%       N                   Blocksize used for FRF estimate
%       fs                  Sampling frequency of time data 
%       EndPercent          Last value of exponential window in percent
%
% This command compensates poles obtained by experimental modal
% analysis parameter extraction, using FRFs determined by impact testing using
% an exponential window. The exponential window increases the damping, so
% thus the present command is used to obtain the correct damping after the
% parameter extraction.
%
% See also ImpactGui aexpw


a_factor=-fs/N*log(EndPercent/100);
[fr,zr]=poles2fz(OldPoles);
NewZr=zr - a_factor./(2*pi*fr);
NewPoles=fz2poles(fr,NewZr);
