% Licensed under GPL-3.0-or-later, check attached LICENSE file

function h = get_loc_load_vec(obj,time,node,varargin)
% Builds the unbalance load vector from Config-file (cnfg) in dof-order: ux,uy,uz,psix,psiy,psiz
%
%    :parameter time: Time step
%    :type time: double
%    :parameter node: Node number
%    :type node: double
%    :parameter varargin: Placeholder
%    :type varargin: 
%    :return: Load vector h

    %Constant fix force 
    obj.h = sparse(6,1);    
    % dof-order: ux,uy,uz,psix,psiy,psiz

    %%
    unwucht = obj.cnfg.betrag;
    phase = obj.cnfg.winkellage;
    omega = node.qd(6); % Velocity state vector psiz

    % due to centripetal force
    FCentripetalForce(1) = unwucht * omega^2 * cos(omega*time + phase);
    FCentripetalForce(2) = unwucht * omega^2 * sin(omega*time + phase);
    
    % due to angular acceleration
%     FAngularAcceleration(1) = + unwucht * omegadot * sin(omega*time + phase);
%     FAngularAcceleration(2) = - unwucht * omegadot * cos(omega*time + phase);
    
    % Superposition
%     obj.h(1) = FCentripetalForce(1) + FAngularAcceleration(1);
%     obj.h(2) = FCentripetalForce(2) + FAngularAcceleration(2);
    obj.h(1) = FCentripetalForce(1);
    obj.h(2) = FCentripetalForce(2);
    
    h = obj.h;
    
    % possible next steps: moment and force because of FAngularAcceleration
    
    
end