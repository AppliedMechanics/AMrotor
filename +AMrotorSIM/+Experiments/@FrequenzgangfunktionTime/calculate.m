% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [f,H,C] = calculate(obj,sensorIn,sensorOut,rpm,inputDirection,outputDirection,numberOfBlocks,windowShape)
% Calculates the frequency response function from time data
%
%    :param sensorIn: Desired input sensor in rotorsystem object (e.g.: r.sensors(5))
%    :type sensorIn: object(sensor)
%    :param sensorOut: Desired input sensor in rotorsystem object (e.g.: r.sensors(5))
%    :type sensorOut: object(sensor)
%    :param rpm: Rotation speed
%    :type rpm: double
%    :param inputDirection: Desired input direction {'u_x','u_y','u_z','psi_x','psi_y','psi_z'}
%    :type inputDirection: vector (char)
%    :param outputDirection: Desired output direction {'u_x','u_y','u_z','psi_x','psi_y','psi_z'}
%    :type outputDirection: vector (char)
%    :param numberOfBlocks: Amount of blocks for the FFT
%    :type numberOfBlocks: double
%    :param windowShape: Window type (check Matlab windows)
%    :type windowShape: string
%    :return: Frequency range (f), FRF-matrix (H) and Coherence-matrix (C)

% (Stationaere Lsg)
%   calculates frf from a time data experiment using sensor-data
%   settings for frf-calculation:
%       overlap: 67 percent
%
% [f,H,C] = calculate(obj,sensorIn,sensorOut,rpm,inputDirection,outputDirection,numberOfBlocks,windowShape)
%
% See also time2xmtrx, xmtrx2frf

obj.sensorIn = sensorIn;
obj.sensorOut = sensorOut;

%% get time data
time = obj.experiment.time;
obj.check_rpm_included_in_results(rpm)
% resultStruct = obj.experiment.result(rpm);

[xIn,yIn,zIn] = sensorIn.read_values(obj.experiment);
xIn = xIn(rpm);
yIn = yIn(rpm);
zIn = zIn(rpm);
resultsIn = [xIn; yIn; zIn];

[xOut,yOut,zOut] = sensorOut.read_values(obj.experiment);
xOut = xOut(rpm);
yOut = yOut(rpm);
zOut = zOut(rpm);
resultsOut = [xOut; yOut; zOut];

% select the dof
inputDirection = obj.set_dof_number(inputDirection);
inputDirection = mod(inputDirection,3);
outputDirection = obj.set_dof_number(outputDirection);
outputDirection = mod(outputDirection,3);
obj.check_selected_dof(inputDirection,outputDirection); % check dimension and value
obj.inputDirection = inputDirection;
obj.outputDirection = outputDirection;

input = resultsIn(inputDirection,:)';
output = resultsOut(outputDirection,:)';


%% additional info
obj.make_type();
obj.make_unit();
obj.make_descriptions_for_FRF();

% inform user of delta between desired and real sensor position
disp([obj.name, obj.descriptionsH{1:end},':'])
fprintf('INPUT\n')
obj.print_table(sensorIn.position, sensorIn.positionMesh, sensorIn.position-sensorIn.positionMesh)
fprintf('OUTPUT\n')
obj.print_table(sensorOut.position, sensorOut.positionMesh, sensorOut.position-sensorOut.positionMesh)
disp(' ')

%% set parameters
N = floor(length(time)/numberOfBlocks/2)*2;
obj.check_for_uniform_sampling(time);
fs = 1/(time(2)-time(1));
window = eval([windowShape,'(N)']);%hsinew(N);%boxcar(N);%ahann(N);%
POverlap =67;% 0;%


%% calculation
[Gxx,Gyx,Gyy,f,NBlocks1]=time2xmtrx(input,output,fs,window,POverlap); % AbraVibe
[H,C,Cx]=xmtrx2frf(Gxx,Gyx,Gyy); % AbraVibe

obj.f = f;
obj.H = H;
obj.C = C;


end