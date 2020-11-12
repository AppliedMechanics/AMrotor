function [varargout] = compute_state_space_for_controller(self,Omega)
% Computes the state space of the system, e.g. for controller design
%
%    :param Omega: Angular velocity step
%    :type Omega: double
%    :return: [A,B,C,D] or sys of Matlab-type ss, check function

%   in Simulink or otherwise
%   dx/dt = Ax(t) + Bu(t)
%   y(t) = Cx(t) + Du(t)
%
%   Uses the positions of the displacement sensors for C and uses the
%   positions of the pidControllers (with the inverse of M) for the matrix B
%
%   sys = rotorsystem.compute_state_space_for_controller(Omega)
%   sys is a system of the Matlab-type State-Space ss
%
%   [A,B,C,D] = rotorsystem.compute_state_space_for_controller(Omega)
%   returns the State-Space matrices directly
%
%   See also
%   ss
% Licensed under GPL-3.0-or-later, check attached LICENSE file

[M,C,G,K]= self.assemble_system_matrices(Omega*60/2/pi);
D = C + Omega*G;
M_inv = M\eye(size(M));
zeroMatr = zeros(size(M));
nDof = length(M);

A = [zeroMatr, eye(size(M)); -M_inv*K, -M_inv*D];

% get B-matrix
B1 = [zeroMatr, zeroMatr; zeroMatr, M_inv];
B2 = [];
for cntr = self.pidControllers
    % get localisation of desired controller forces
    cntrNode = self.rotor.find_node_nr(cntr.position);
    dof = self.rotor.get_gdof(cntr.direction,cntrNode);
    L = zeros(nDof,1);
    L(dof) = 1;
    B2 = [B2,L];
end
B2 = [zeros(size(B2));B2]; % state-space
B = B1*B2;

% get C-matrix
C = [];
for sensor = self.sensors
    if strcmp(sensor.type,'Displacementsensor')
        sensNode = self.rotor.find_node_nr(sensor.position);
        % which direction ? -> simply chose the x-direction
        dof_x = self.rotor.get_gdof('u_x',sensNode);
        L = zeros(1,nDof);
        L(dof_x) = 1;
        L = L/norm(L);
        C = [C;L];
    end
end
C = [C, zeros(size(C))];

D = zeros(size(C,1),1);

switch nargout
    case 1
        sys = ss(A,B,C,D);
        varargout{1} = sys;
    case 3
        varargout{1} = A;
        varargout{2} = B;
        varargout{3} = C;
    case 4
        varargout{1} = A;
        varargout{2} = B;
        varargout{3} = C;
        varargout{4} = D;
    otherwise
        varargout = {};
end


end