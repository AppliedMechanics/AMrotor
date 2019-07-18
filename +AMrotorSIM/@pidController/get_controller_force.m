function force = get_controller_force(obj,tCurr,y)
% get the force of the controller
%   obj: pidController-object
%   t: time-vector of solution
%   y: position vector at the corresponding controller node

p = obj.P;
i = obj.I;
d = obj.D;

dof_name = {'u_x','u_y','u_z','psi_x','psi_y','psi_z'};
dof_loc = [1,2,3,4,5,6];
ldof = containers.Map(dof_name,dof_loc);
entryNo = ldof(obj.direction);

currVal = y(entryNo);
dt = tCurr - obj.prevTime;

cumError = obj.cumError;
prevError = obj.prevError;

target = obj.targetDisplacement;


% "loop"
% P
error = target - currVal;
pCor = p * error;
% I
cumError = cumError + error;
iCor = i * cumError * dt;
% D
slopeError = (error - prevError) / dt;
dCor = d * slopeError;
prevError = error;
prevTime = tCurr;

cor = pCor + iCor + dCor;

% Stellgroessenbegrenzung
% if cor > maxCor, cor = maxCor; end
% if cor < minCor, cor = minCor; end

force = cor;


% write new values to controller object
obj.cumError = cumError;
obj.prevError = prevError;
obj.prevTime = prevTime;
obj.force = force;

end