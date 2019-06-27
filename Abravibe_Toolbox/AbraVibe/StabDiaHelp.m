D=which('sdiagramGUI.m');
idx=findstr(D,filesep);    % Clear file path from filename
ImpactGuiPath=D(1:idx(end)-1);;

open(fullfile(ImpactGuiPath,'StabDiaHelp.htm'))