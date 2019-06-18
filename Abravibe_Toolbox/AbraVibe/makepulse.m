function p = makepulse(N,fs,tp,pt);
% MAKEPULSE     Calculate a Gaussian or halfsine pulse
%
%       p = makepulse(N,fs,tp,pt);
%
%       p           Pulse, N samples in column vector
%
%       N           Blocksize
%       fs          Sampling frequency
%       tp          Pulse width in seconds
%       pt          Pulse type string, 'Gaussian' (default) or 'Halfsine'
%       

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA

t=(0:1/fs:(N-1)/fs);                % Time axis
n_zero=round(tp*fs+1);              % End bin of pulse
if n_zero > N
   n_zero=N;
   disp('Warning! Pulse length does not fit within window.')
elseif rem(n_zero,2) == 1
   n_zero=n_zero-1;
end
	
if strcmp(upper(pt),'HALFSINE')
	p(1:n_zero)=sin(2*pi/(2*tp)*t(1:n_zero));
	p(n_zero+1:N)=zeros(size(n_zero+1:N));
elseif strcmp(upper(pt),'GAUSSIAN')
	p(1:n_zero)=exp(-((t(1:n_zero)-t(n_zero/2))/(t(n_zero/2)/3)).^2/2);
	%p(1:n_zero)=exp(-((t(1:n_zero)-.05)/.01).^2/2);
	p(1:n_zero)=p(1:n_zero)-min(p(1:n_zero));
	p(n_zero+1:N)=zeros(size(n_zero+1:N));
else
end

p=p';
p=p./sqrt(p'*p);
