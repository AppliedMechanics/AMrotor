function MODAL = pv2modal(p,V,dofs,dirs)
% PV2MODAL   Convert separate variables to animate MODAL struct
%
%       MODAL = pv2modal(p,V,dofs,dirs)
%
%       MODAL   Structure with all modal information, see ANIMATE
%
%       p       Vector with complex poles with positive imaginary part
%       V       Mode shape matrix Ndofs-by-Nmodes
%       dofs    Vector with each dof in the mode shape rows
%       dirs    Vector with each direction in the mode shape rows (1,2,3
%               for x,y,z)
%
% NOTE! This function only works for dofs=[1:NumberDofs]!
%
% See also ANIMATE modal2pv

% Copyright (c) 2018 by Anders Brandt
% Email: abra@iti.sdu.dk
% Version: 1.0 2018-05-10
%
% This file is part of ABRAVIBE Toolbox for NVA

[NumberPoints,NumberModes]=size(V);

% Create empty MODAL struct, with correct size
dofs=dofs(:);
for n=1:NumberModes
    MODAL(n).Freq=0;
    MODAL(n).Node=dofs;
    MODAL(n).X=zeros(length(dofs),1);
    MODAL(n).Y=zeros(length(dofs),1);
    MODAL(n).Z=zeros(length(dofs),1);
end

% Fill in proper places in MODAL
for n = 1:NumberModes
    MODAL(n).Freq=p(n)/2/pi;
    MODAL(n).Node=dofs;
    for row=1:NumberPoints
        if abs(dirs(row)) == 1
            MODAL(n).X(dofs(row))=sign(dirs(row))*V(row,n);
        elseif abs(dirs(row)) == 2
             MODAL(n).Y(dofs(row))=sign(dirs(row))*V(row,n);
        elseif abs(dirs(row)) == 3
             MODAL(n).Z(dofs(row))=sign(dirs(row))*V(row,n);
        end
    end
end
