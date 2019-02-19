function [Hrec,RecDof, Hdp, DpDof, MissingDofs] = modalchk(H,f,Rdof,Rdir,Fdof,Fdir,FillMtrx,Type)
% MODALCHK  Standard checks on FRF matrix for exp. modal analysis
%
% modalchk(H,f,Rdof,Rdir,Fdof,Fdir,FillMtrx,Type) produces appropriate plots
%       
% [Hrec,RecDof, Hdp, DpDof, MissingDofs] = modalchk(H,f,Rdof,Rdir,Fdof,Fdir,FillMtrx,Type)
% produces outputs in requested variables
%
%       Hrec        Reciprocity matrix N-by-2-by-(R-1)! with corresponding FRFs
%                   to/from each reference R and, in H(:,:,R)
%       RecDof      2-by-(R-1)! cell array with dof string for H(:,m,n) in
%                   RecDof{m,n) (see headpstr command)
%       Hdp         Driving point FRFs, N-by-R, with reference to Fdof(n)
%                   in Hdp(:,n)
%       DpDof       Cell array with dof string for Hdp(:,n) in DpDof{n};
%       MissingDofs Index into H in case  there are missing measurements.
%                   If not, MissingDofs is empty
%       H           FRF matrix with accelerances, sorted by DATA2FRF
%       f           Frequency axis for H
%       Rdof        Response dofs (or force dofs if impact test)
%       Rdir        Response directions
%       Fdof        Force dofs (or response if impact test)
%       Fdir        Force directions
%       FillMtrx    Matrix with a 1 in positions with an FRF in H
%       Type        String with options for which tests
%                   'all' (Default) performs all of the following:
%                   'reciprocity'
%                   'imaginary' check imaginary part of driving points
%                   'complete' checks if missing 
%

% Copyright (c) 2009-2011 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2011-06-23   
%          1.1 2012-04-23 Fixed bug, if force/response have different
%                         direction, crashed before
% This file is part of ABRAVIBE Toolbox for NVA

% Parse inputs
if nargin == 7
    Type='ALL';
elseif nargin == 8
    Type=upper(Type);
else
    error('Wrong number of inputs. Only Type is optional!')
end

[N,D,R]=size(H);

% Convert dof and directions to a combined number
for n=1:length(Rdof)
    a=Rdir(n);
    Rdofs(n)=sign(a)*(10*Rdof(n)+abs(a));         % Dof 13Z- is now -133
end
for n=1:length(Fdof)
    a=Fdir(n);
    Fdofs(n)=sign(a)*(10*Fdof(n)+abs(a));         % Dof 13Z- is now -133
end

if strcmp(Type,'ALL') | strcmp('RECIPROCITY')
% 1. Reciprocity
% For each pair of force dofs, find corresponding measurements
    for n = 1:R
        for m = n+1:R
            % Following two lines fixed bug 2012-04-23 by introducing abs()
            Ridx1=find(abs(Rdofs) == abs(Fdofs(n)));      % Response for F(n)
            Ridx2=find(abs(Rdofs) == abs(Fdofs(m)));      % Response for F(m)
            Hrec(:,1,n)=H(:,Ridx1,m);
            RecDof{1,n}=strcat(int2str(Rdof(Ridx1)),nbr2dir(Rdir(Ridx1)),'/',int2str(Fdof(m)),nbr2dir(Fdir(m)));
            Hrec(:,2,n)=H(:,Ridx2,n);
            RecDof{2,n}=strcat(int2str(Rdof(Ridx2)),nbr2dir(Rdir(Ridx2)),'/',int2str(Fdof(n)),nbr2dir(Fdir(n)));
            if nargout == 0
                % Produce plot
                figure
                semilogy(f,abs(Hrec(:,1,n)),f,abs(Hrec(:,2,n)))
                legend(RecDof{1,n},RecDof{2,n})
                xlabel('Frequency [Hz]')
                title('Reciprocity plot')
            end
        end
    end
end
if strcmp(Type,'ALL') | strcmp(Type,'IMAGINARY')
% 2. Imaginary part of driving points are checked for peaks and directions:
    for r=1:R
        Ridx=find(Rdof == Fdof(r));
        Hdp(:,r)=H(:,Ridx,r);
        DpDof{r}=strcat(int2str(Rdof(Ridx)),nbr2dir(Rdir(Ridx)),'/',int2str(Fdof(r)),nbr2dir(Fdir(r)));
    end
    if nargout == 0
        figure
        for r=1:R
            subplot(R,1,r)
            plot(f,imag(Hdp(:,r)))
            ylabel('Imaginary part')
            title(['Driving point ' DpDof{r} '; If both sensors have common sign, peaks should be positive!'])
            xlabel('Frequency [Hz]')
        end
    end
end
if strcmp(Type,'ALL') | strcmp(Type,'COMPLETE')
    if (FillMtrx == 0) ~= zeros(size(FillMtrx))
        warning('Missing measurements!')
        [a,b]=find(FillMtrx == 0);
        MissingDofs=[a b];
    end
end

