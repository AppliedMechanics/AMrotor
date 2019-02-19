function [p,V,dofs,dirs] = modal2pv(MODAL)
% MODAL2PV   Convert animate MODAL struct to separate variables
%
%       [p,V,dofs,dirs] = modal2pv(MODAL)
%
%       p       Vector with complex poles with positive imaginary part
%       V       Mode shape matrix Ndofs-by-Nmodes
%       dofs    Vector with each dof in the mode shape rows
%       dirs    Vector with each direction in the mode shape rows (1,2,3
%               for x,y,z)
%
%       MODAL   Structure with all modal information, see ANIMATE
%
% See also ANIMATE pv2modal

% Copyright (c) 2018 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2018-05-10
%
% This file is part of ABRAVIBE Toolbox for NVA

dofidx=1;       % Index into rows in V, and into dofs, dirs
V=[];
NDofs=length(MODAL(1).Node);
for n = 1:length(MODAL)
    NextRowIdx=1;
    p(n)=MODAL(n).Freq*2*pi;
    if ~isequal(MODAL(n).X,zeros(size(MODAL(n).X)))
        V(1:NDofs,n)=MODAL(n).X;
        dofs(1:NDofs)=Modal(n).Node;
        dirs(1:Ndofs)=1*ones(size(MODAL(n).Node));
        NextRowIdx=NDofs+1;
    end
     if ~isequal(MODAL(n).Y,zeros(size(MODAL(n).Y)))
        V(NextRowIdx:NextRowIdx-1+NDofs,n)=MODAL(n).Y;
        dofs(NextRowIdx:NextRowIdx-1+NDofs)=Modal(n).Node;
        dirs(NextRowIdx:NextRowIdx-1+NDofs)=2*ones(size(MODAL(n).Node));
        NextRowIdx=NDofs+1;
    end
     if ~isequal(MODAL(n).Z,zeros(size(MODAL(n).Z)))
        V(NextRowIdx:NextRowIdx-1+NDofs,n)=MODAL(n).Z;
        dofs(NextRowIdx:NextRowIdx-1+NDofs)=MODAL(n).Node;
        dirs(NextRowIdx:NextRowIdx-1+NDofs)=3*ones(size(MODAL(n).Node));
        NextRowIdx=NDofs+1;
    end
end
