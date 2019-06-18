function Hs = frfsynt(H,f,p,V,Res,indof,outdof,Type,DispTime,Fdof)
% FRFSYNT  Synthesize FRF(s) after modal parameter extraction
%
%       Hs = modal2frf(H,f,p,V,indof,outdof,Type,DispTime,Fdof)
%
%       Hs          FRF matrix, N-by-D-by-R
%
%       H           Measured accelerance FRFs for overlay plot(s)
%       f           Frequency axis (column) vector
%       p           Column vector with poles, one for each column in V
%       V           Mode shape matrix with modes in columns (unity modal mass)
%       Res         Residual vector from parameter estimation. Empty if no
%                   residuals were used
%       indof       Vector with dofs for references (inputs), length=R
%       outdof      Vector with dofs for responses (outputs), length=D,
%                   Default is 1:length(V(:,1))
%       Type        String with 'd' for dynamic flexibility (displacement/force)
%       	                    'v' for mobility (velocity/force) (Default)
%       	                    'a' for accelerance (acceleration/force)
%       DispTime    Time in seconds for display of each overlay plot. 
%                   If = 0, no plots are produced
%       Fdof        Vector with pointer to corresponding coefficient in the
%                   response dimension
%       N           length(f), number of frequency values to compute H on
%
% If R > 1, synthesized FRFs for each response are plotted simultaneously
% for all references in indof.
%
% Note2: The mode shapes are assumed to be scaled to unity modal A.
%
% Example:
% Assume a test was made with three shakers in positions 1, 29, and 35 on a
% structure with 35 dofs, numbered 1 to 35. The three driving point FRFs
% will then be synthesized and overlaid with the corresponding measured 
% functions, by
% H11=frfsynt(H,f,p,V,Res,1,1,'a',DispTime,[1 29 35])
% H2929=frfsynt(H,f,p,V,Res,29,29,'a',DispTime,[1 29 35])
% H3535=frfsynt(H,f,p,V,Res,35,35,'a',DispTime,[1 29 35])
% ...if we assume all variables H,f... are properly defined.
% Example 2:
% If all measurements are to be synthesized and plotted during DispTime
% seconds each (for each output and all inputs simultaneously), then call:
% Hs=frfsynt(H,f,p,V,Res,[1 29 35],[1:35],'a',DispTime,[1 29 35])

% Copyright (c) 2012 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2012-03-27
% This file is part of ABRAVIBE Toolbox for NVA

[N,D,R]=size(H);
Nm=length(p);
[n,m]=size(V);
if n ~= D
    error('Mode shape matrix is not consistent with H matrix, wrong number of responses!')
end
if m ~= Nm
    error('Mode shape matrix is not consistent with the pole vector!')
end
if max(outdof) > D
    error('Requested output dof(s) outside size of H!')
end

% Define which force indeces in H that will be synthesized
fidx=[];
for r=1:length(indof)
    fidx=[fidx find(Fdof == indof(r))];
end
if isempty(fidx)
    error('No force positions found! Check syntax')
elseif length(fidx) > R
    error('Too many forces in indof!')
end

% calculate omega^2 for use with residuals
w2=(2*pi*f).^2;        

% Allocate Hs
Hs=zeros(N,length(outdof),length(fidx));

for d=1:length(outdof)
    if  ~exist('h','var')
        h=figure;
    else
        figure(h);
    end
    if length(fidx) == 1
        Hs(:,d)=modal2frf(f,p,V,indof,outdof(d),Type);
        semilogy(f,abs(H(:,outdof(d),fidx)),f,abs(Hs(:,d)),'--')
        xlabel('Frequency, [Hz]')
        if strcmp(upper(Type),'D')
            ylabel('Receptance, [m/N]')
        elseif strcmp(upper(Type),'V')
            ylabel('Mobility, [(m/s)/N]')
        elseif strcmp(upper(Type),'A')
            ylabel('Accelerance, [(m/s)^2/N]')
        end
        legend('Measured','Synthesized')
        title(['Response dof ' num2str(outdof(d))])
    else
        for r=1:length(fidx)
            Ht=modal2frf(f,p,V,indof(r),outdof(d),Type);
            if isempty(Res)
            else
                Ht=Ht+Res(fidx(r),outdof(d));
                Ht=Ht+Res(R+fidx(r))./w2;outdof(d);
            end
            Hs(:,d,r)=Ht;
            subplot(length(fidx),1,r)
            semilogy(f,abs(H(:,outdof(d),fidx(r))),f,abs(Hs(:,d,r)),'--')
            xlabel('Frequency, [Hz]')
            if strcmp(upper(Type),'D')
                ylabel('Receptance, [m/N]')
            elseif strcmp(upper(Type),'V')
                ylabel('Mobility, [(m/s)/N]')
            elseif strcmp(upper(Type),'A')
                ylabel('Accelerance, [(m/s)^2/N]')
            end
            if r == 1
                legend('Measured','Synthesized')
                title(['Response dof ' num2str(outdof(d))])
            end
        end
    end
    pause(DispTime)
end
