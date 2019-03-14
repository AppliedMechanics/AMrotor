% ABRACHECK     Check ABRAVIBE TOOLBOX COMMANDS
%
% This mfile finds all verification scripts in the current directory (same
% as that where abracheck.m is located), and executes each script. This
% script should be located in a directory directly under the directory
% where the toolbox commands are located. If, for example, ABRAVIBE is
% located in 
% c:\matlab\toolbox\abravibe
% then the verification directory should be 
% c:\matlab\toolbox\abravibe\abratest
% Inside abracheck.m you can specify a file name to log output to.
% If you do not, the output of all tests is printed to screen

% Copyright 2009-2012, Anders Brandt
% Email: abra@iti.sdu.dk
% Revision: 1.1   2012-01-14  Revised to work better with Octave.

% If you want to log outputs of this program to a file, specify a file name
% by entering it in the string FileName
LogFileName='';
if ~isempty(LogFileName)
    fid=fopen(LogFileName,'w');
    fprintf(1,'Output from ABRACHECK.m on %s\n\n',datestr(now));
else
    fid=1;
end

if strcmp(checksw,'MATLAB')
	help abracheck
	fprintf('Press <RETURN> to start...\n')
	pause
elseif strcmp(checksw,'OCTAVE')
	fprintf(1,'Checking selected ABRAVIBE toolbox commands...\n')
	fflush(1);
end

% Find all m files in the current directory
S=dir('*.m');

for n=1:length(S)
    FileName=S(n).name;
    if ~strcmp(FileName,'abracheck.m')
        FileName=FileName(1:end-2);         % Remove .m for run to work
        run(FileName);
        fprintf(fid,'\n');
		if strcmp(checksw,'OCTAVE')
			fflush(1);						% Force output so execution does not seem to hang
		end
    end
end
