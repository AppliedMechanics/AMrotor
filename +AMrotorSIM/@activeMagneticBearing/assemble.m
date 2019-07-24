function assemble(AMB,r)
% creates SimpleBearing and pidController-objects for
% activeMagneticBearing and adds it to the rotorsystem
%   AMB: object of the class activeMagneticBearing
%   r: object of the class Rotorsystem

% Bearing
cnfg.name = [AMB.name,'Bearing'];
cnfg.type = 'Bearings';
cnfg.subtype = 'SimpleBearing';
cnfg.position = AMB.position;
cnfg.stiffness = AMB.kx;
cnfg.damping = 0;
r.components(end+1) = AMrotorSIM.Components.Bearings.SimpleBearing(cnfg);
AMB.simpleBearing = r.components(end);
clear cnfg

% Controllers
cnfg.position = AMB.position;
cnfg.P = AMB.electricalP * AMB.ki;
cnfg.I = AMB.electricalI * AMB.ki;
cnfg.D = AMB.electricalD * AMB.ki;
% x-direction
cnfg.name = [AMB.name,'PIDx'];
cnfg.direction = 'u_x';
cnfg.targetDisplacement = AMB.targetDisplacementX;
r.pidControllers(end+1) = AMrotorSIM.pidController(cnfg);
AMB.pidController(end+1) = r.pidControllers(end);
% y-direction
cnfg.name = [AMB.name,'PIDy'];
cnfg.direction = 'u_y';
cnfg.targetDisplacement = AMB.targetDisplacementY;
r.pidControllers(end+1) = AMrotorSIM.pidController(cnfg);
AMB.pidController(end+1) = r.pidControllers(end);

end