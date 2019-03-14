function sw = checksw
% CHECKSW  Check if running MATLAB or GNU/Octave
%
%       sw = checksw
%
%       sw      'MATLAB' or 'OCTAVE' depending on what software checksw is
%               called from. 0 is returned if neither MATLAB or Octave was
%               found (unexpected).
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2018-03-09 Changed procedure as very slow befor
% This file is part of ABRAVIBE Toolbox for NVA

% The platform is now established once and for all during the installation
% by running 'abrainst'

if exist('Platform.mat','file') == 2
    load('Platform')
else
    error('You have not installed ABRAVIBE. Please run the script ''abrainst'' in the Abravibe_Toolbox directory!')
end




