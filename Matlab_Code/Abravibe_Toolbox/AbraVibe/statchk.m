function statchk(x, N, NPlot, FileName);
%STATCHK Create standard statistics for time signal(s) in matrix
%
%           statchk(x, N, NPlot, FileName);
%
%           x           Time data in column(s)
%           N           Number of bins for PDF computation
%           NPlot       If NPlot=1 a plot with the PDF of x is plotted with
%                       the equivalent Gaussian distribution overlaid
%                       If NPlot=2, the same is plotted with logy scale
%                       If NPlot=0 no plot is produced.
%           FileName    If this string is given, the output of statchk is
%                       redirected to a log file FileName.log in the 
%                       current directory (or in the directory indicated in 
%                       the string FileName if a full path is given). 
%                       Also, the actual statistical vectors are stored in 
%                       mat file FileName.mat.
%
% This function performs some standard statistical analysis of time data in 
% the columns of x.
% Also, a histogram is plotted with N bins centered around 0. If Nplot=1 a plot of
% the Gaussian distribution using mean and std of x is overlayed on the histogram.
% If N is not given a default of 30 bins are used for the histogram. After calling
% this function, a number of variables with generic names are logged in text file FileName.
% If no FileName is given the values are listed on the screen.
% 
% WARNING! This command will overwrite an existing log file with the name
% in FileName!
%
% See also STATCHKF FRAMESTAT TESTSTAT

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
% This file is part of ABRAVIBE Toolbox for NVA


if nargin == 2
   NPlot=0;
   fid=1;
elseif nargin == 1
   NPlot=0;
   N=30;
   fid=1;
elseif nargin == 3
       fid=1;
elseif nargin == 4
    fid=fopen(strcat(FileName,'.log'),'w');
elseif nargin > 4
   error('Wrong number of parameters!')
end

[mx,nx]=size(x);

m=mean(x);
Sigma2=diag(cov(x))';
Sigma=sqrt(Sigma2);
Skewness=askewness(x);
Kurtosis=akurtosis(x);
RMS=sqrt(1/mx*sum(x.^2));
Crest=max(abs(x))./RMS;
XMax=max(x);
XMin=min(x);
kol=[1:nx];


if fid ~= 1
    fprintf(fid,'Output of command STATCHK\n');
    fprintf(fid,'Date: %s\n',datestr(now));
end
fprintf(fid,'Statistical parameters:\n');
fprintf(fid,'============================\n');
[S,E]=sprintf('%5s%12s%12s%12s%12s%12s%12s%12s%12s%12s\n','Col.','Max','Min','Mean','Crest','RMS','Std dev',...
'Variance','Skewness','Kurtosis');
fprintf(fid,'%s',S);
for col=1:nx,
   S2=sprintf('%5d%12.2g%12.2g%12.2g%12.2g%12.2g%12.2g%12.2g%12.2g%12.2g',kol(col),XMax(col),XMin(col),...
   m(col),Crest(col),RMS(col),Sigma(col),Sigma2(col),Skewness(col),Kurtosis(col));  
   fprintf(fid,'%s\n',S2);
end

[row,col]=size(x);
if (col > 1) & NPlot
   fprintf(fid,' Stat: more than one column in vector, graphing only first column!\n\n');
end
[H, XAx, G]=apdf(x(:,1),N,NPlot);
% 
if nargin == 4
   S=['save ' FileName ' XMax XMin m Crest RMS Sigma Sigma2 Skewness Kurtosis'];
   eval(S)
   fclose(fid);
end
