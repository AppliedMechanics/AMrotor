function  [y,H,f] = timefresp(varargin);
% TIMEFRESP     Time domain forced response
%
% This function can be called several different ways:
%
% y = timefresp(x,fs,p,V,indof,outdof,OutType) calculates the output
% based on known poles and mode shapes.
%
% y = timefresp(x,fs,M,C,K,indof,outdof,OutType) calculates the output
% based on known mass, damping, and stiffness matrices, if C is a matrix.
%
% y = timefresp(x,fs,M,z,K,indof,outdof,OutType) calculates the output
% based on known mass, and stiffness matrices, and modal (viscous) damping
% if z is a vector. (ONLY works for more than one DOF, see below).
%
%       y           Output(s) in columns, N-by-D (a little shorter than 
%                   N if OutType is 'v' or 'a', see text below)
%
%       x           Input force(s) in columns [Newton], length(x) = N
%       fs          Sampling frequency for x (no oversampling required!)
%       p           Vector with poles
%       V           Mode shape matrix with mode shapes in columns
%       indof       Vector with dofs for the columns in x
%       outdof      Vector with dofs for the columns in y, length(outdof)=D
%       OutType     'd', 'v', 'a' for displacement, velocity, acceleration
%       M           Mass matrix
%       C, z        Damping matrix, or relative damping coefficients. Note
%                   that z is only valid when the number of DOFs is > 1
%                   For SDOF systems, you MUST use m, c, k
%       K           Stiffness matrix
%
% Note! All input parameters MUST be given to this function.
%
% This function upsamples data by a factor 5, and downsamples again after
% the simulation is finished, so no extra oversampling, in addition to the
% 'normal' factors 2 to 2.5, is needed for the input data x.
% See inside file for reference.
% If output type is 'v' or 'a', one or two differentiating filters is/are
% applied. This will reduce the length by 20, or 40 samples, respectively,
% see TIMEDIFF with option 'remez'.

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23  
%          1.1 2011-08-11  Simplified oversampling expressions
%          1.2 2012-01-15  Modified to work for 'v' and 'a' in Octave
%          1.3 2018-03-09  Modified so H, f only computed if asked for
% This file is part of ABRAVIBE Toolbox for NVA

% References:
% Ahlin, K., Magnevall, M. & Josefsson, A., "Simulation of forced response 
% in linear and nonlinear mechanical systems using digital filters,", ISMA, 
% International Conference on Noise and Vibration Engineering, Catholic 
% University, Leuven, 2006. Ramp invariant transform is used here.
% 
% Brandt, A., "Noise and Vibration Analysis: Signal Analysis and
% Experimental Procedures," John Wiley and Sons., 2011, Section 6.5.

% Set simulation parameter for oversampling
OS=5;              % Data are resampled to newfs=OS*fs

% Parse inputs
if nargin == 7      % based on modal model
    x=varargin{1};
    fs=varargin{2};
    p=varargin{3};
    V=varargin{4};
    indof=varargin{5};
    outdof=varargin{6};
    OutType=varargin{7};
elseif nargin == 8  % Based on M, C, K or M, z, K
    x=varargin{1};
    fs=varargin{2};
    M=varargin{3};
    C=varargin{4};
    [m,n]=size(C);
    if m ~= n
        z=C;
        clear C
    end
    K=varargin{5};
    indof=varargin{6};
    outdof=varargin{7};
    OutType=varargin{8};
end
OutType=upper(OutType);

%=======================================================================
% Upsample input data OS times
[N,R]=size(x);
D=length(outdof);
xn=zeros(OS*N,R);
for r = 1:R
    xn(:,r)=resample(x(:,r),OS,1);
end
x=xn;
clear xn
fs=OS*fs;
    
%=======================================================================
% Calculate output(s) depending on damping type
if exist('C','var')
    [p,V]=mck2modal(M,C,K);
elseif exist('z','var')
    [p,V]=mkz2modal(M,K,z);
end

% Compute outputs depending on call
if nargout > 1
    [y,H,f] = fresppv(x,fs,p,V,indof,outdof);
else
    [y] = fresppv(x,fs,p,V,indof,outdof);
end

% Downsample output data
yold=y;
y=zeros(N,D);
for d = 1:D
    y=resample(yold,fs/(OS),fs);
end
fs=fs/(OS);

% Check if differentiation is necessary and apply
% Bug fix: 2012-01-15 changed 'remez' to 'maxflat' differentiation if run
% from Octave, since it seems there is a problem with remez in Octave.
% Fix 2012-11-06: Changed to maxflat for both platforms, as there were
% problems with remez in MATLAB.
difftype='maxflat';
if strcmp(OutType,'V')
    y=timediff(y,fs,difftype);
    if nargout > 1
        H=fdiff(H,f,'lin',1);
    end
elseif strcmp(OutType,'A')
    yt=timediff(y,fs,difftype);
    y=timediff(yt,fs,difftype);
    if nargout > 1
        H=fdiff(H,f,'lin',2);
    end
end
