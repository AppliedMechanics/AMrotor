% Licensed under GPL-3.0-or-later, check attached LICENSE file

function assemble(AMB,r)
% Creates SimpleBearing- and pidController-objects for ActiveMagneticBearing and adds it to the rotorsystem
%
%    :param AMB: object of type ActiveMagneticBearing
%    :type AMB: object
%    :param r: object of type Rotorsystem
%    :type r: object
%    :return: SimpleBearing- and pidController-objects

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
cnfg = AMB.cnfg;
cnfg.type = cnfg.pidType;
% x-direction
cnfg.name = [AMB.name,'PIDx'];
cnfg.direction = 'u_x';
cnfg.targetDisplacement = AMB.targetDisplacementX;
r.pidControllers(end+1) = AMrotorSIM.pidControllers.(cnfg.type)(cnfg);
AMB.pidController(end+1) = r.pidControllers(end);
% y-direction
cnfg.name = [AMB.name,'PIDy'];
cnfg.direction = 'u_y';
cnfg.targetDisplacement = AMB.targetDisplacementY;
r.pidControllers(end+1) = AMrotorSIM.pidControllers.(cnfg.type)(cnfg);
AMB.pidController(end+1) = r.pidControllers(end);

end