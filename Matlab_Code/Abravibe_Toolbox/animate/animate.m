function animate;
% ANIMATE  Animates wireframe models from universal files or MATLAB structure
%
% Usage: Store geometry and mode shape information either in a universal file, 
% or in a MATLAB file with the following two structures:
% GEOMETRY.node    => Column vector with node labels (double)
% GEOMETRY.x          => Column vector with node X-axis data (double)
% GEOMETRY.y          => Column vector with node Y-axis data (double)
% GEOMETRY.z          => Column vector with node Z-axis data (double)
% GEOMETRY.conn    => Row vector with node labels describing the wireframe.  A line-break (pen-up) can use a NaN, 0, or -1 (double)
%  
% MODAL is a structured array, MODAL(#).xxx with each position defining a single modes data.
% MODAL.Freq          => Complex value for modal frequency in Hz.
% MODAL.Node        => Column vector with node labels (double)
% MODAL.X              => Column vector with node X-axis maximum deflection (double)
% MODAL.Y              => Column vector with node Y-axis maximum deflection (double)
% MODAL.Z              => Column vector with node Z-axis maximum deflection (double)



global SETUP RESIZE UFF UDATA GEOMETRY
SETUP           = [];
GEOMETRY        = [];
MODAL           = [];
UDATA           = [];
UDATA.Handles   = [];
if ishandle(findobj(0,'Tag','ANIMATE'))
    figure(findobj(0,'Tag','ANIMATE'));
    return;
end
% Init Variables
[PATH,FILE,EXT]         = fileparts(which('animate.m'));
SETUP                   = command('initDefaults');
SETUP.RecentFiles.File1 = '';
SETUP.RecentFiles.Type1 = [];
SETUP.RecentFiles.File2 = '';
SETUP.RecentFiles.Type2 = [];
SETUP.RecentFiles.File3 = '';
SETUP.RecentFiles.Type3 = [];
SETUP.RecentFiles.File4 = '';
SETUP.RecentFiles.Type4 = [];

SETUP.Path.Data     = PATH;
SETUP.Path.Root     = PATH;
SETUP.Path.Export   = PATH;
SETUP.Path.Help     = fullfile(PATH,'Help');

if exist(fullfile(PATH,'animate.ini'),'file');
    SETUP   = defaults('readINI',SETUP');
    if ~isempty(SETUP.RecentFiles.File1)
        [p,f,e] = fileparts(SETUP.RecentFiles.File1);
        SETUP.Path.Data = p;
    end
else
    defaults('writeINI',SETUP');
end
flag    = 0;
if ~isdir(SETUP.Path.Root)
    SETUP.Path.Root     = PATH;
    flag    = 1;
end
if ~isdir(SETUP.Path.Data)
    SETUP.Path.Data     = PATH;
    flag    = 1;
end
if ~isdir(SETUP.Path.Export)
    SETUP.Path.Export   = PATH;
    flag    = 1;
end
if ~isdir(SETUP.Path.Help)
    SETUP.Path.Help     = PATH;
    flag    = 1;
end
if max(flag)
    defaults('addPaths',SETUP);
end

flag    = zeros(1,4);
if ~exist(SETUP.RecentFiles.File1,'file')
    flag(1) = 1;
end
if ~exist(SETUP.RecentFiles.File2,'file')
    flag(2) = 1;
end
if ~exist(SETUP.RecentFiles.File3,'file')
    flag(3) = 1;
end
if ~exist(SETUP.RecentFiles.File4,'file')
    flag(4) = 1;
end
SETUP   = updateRecentFiles(SETUP,flag);
if max(flag)
    defaults('addRecentFiles',SETUP);
end
UFF.DATA    = [];
UFF.dsn15   = [];
UFF.dsn18   = [];
UFF.dsn55   = [];
UFF.dsn82   = [];

VER             = version;
ind             = findstr(VER,'R');
SETUP.Release   = str2num(VER(ind+1:ind+2));


% Init GUI
FIG             = guiAnimate(SETUP);
RESIZE.FigPos   = get(FIG,'Position');

function SETUP = updateRecentFiles(SETUP,flag)
ind = find(flag);

if flag(4)
    SETUP.RecentFiles.File4 = '';
    SETUP.RecentFiles.Type4 = [];
end
if flag(3)
    SETUP.RecentFiles.File3 = SETUP.RecentFiles.File4;
    SETUP.RecentFiles.Type3 = SETUP.RecentFiles.Type4;
    SETUP.RecentFiles.File4 = '';
    SETUP.RecentFiles.Type4 = [];
end
if flag(2)
    SETUP.RecentFiles.File2 = SETUP.RecentFiles.File3;
    SETUP.RecentFiles.Type2 = SETUP.RecentFiles.Type3;
    SETUP.RecentFiles.File3 = SETUP.RecentFiles.File4;
    SETUP.RecentFiles.Type3 = SETUP.RecentFiles.Type4;
    SETUP.RecentFiles.File4 = '';
    SETUP.RecentFiles.Type4 = [];
end
if flag(1)
    SETUP.RecentFiles.File1 = SETUP.RecentFiles.File2;
    SETUP.RecentFiles.Type1 = SETUP.RecentFiles.Type2;
    SETUP.RecentFiles.File2 = SETUP.RecentFiles.File3;
    SETUP.RecentFiles.Type2 = SETUP.RecentFiles.Type3;
    SETUP.RecentFiles.File3 = SETUP.RecentFiles.File4;
    SETUP.RecentFiles.Type3 = SETUP.RecentFiles.Type4;
    SETUP.RecentFiles.File4 = '';
    SETUP.RecentFiles.Type4 = [];
end
    
