function [f,H,C] = calculate(obj,sensorIn,sensorOut,rpm,inputDirection,outputDirection,numberOfBlocks)
% CALCULATE calculate the frequency response function from time data
% (Stationaere Lsg)
%   calculates frf from a time data experiment using sensor-data
%   settings for frf-calculation:
%       window: halfsine
%       overlap: 67 percent
%
% [f,H,C] = calculate(obj,f,inPos,outPos,type,rpm,inputDirection,outputDirection)
%
% See also time2xmtrx, xmtrx2frf

obj.sensorIn = sensorIn;
obj.sensorOut = sensorOut;

%% get time data
time = obj.experiment.time;
obj.check_rpm_included_in_results(rpm)
% resultStruct = obj.experiment.result(rpm);

[xIn,~,yIn,~] = sensorIn.read_values(obj.experiment);
xIn = xIn(rpm);
yIn = yIn(rpm);
resultsIn = [xIn; yIn];

[xOut,~,yOut,~] = sensorOut.read_values(obj.experiment);
xOut = xOut(rpm);
yOut = yOut(rpm);
resultsOut = [xOut; yOut];

% select the dof
inputDirection = obj.set_dof_number(inputDirection);
outputDirection = obj.set_dof_number(outputDirection);
obj.check_selected_dof(inputDirection,outputDirection); % check dimension and value
obj.inputDirection = inputDirection;
obj.outputDirection = outputDirection;

input = resultsIn(inputDirection,:)';
output = resultsOut(outputDirection,:)';


%% additional info
obj.make_type();
obj.make_unit();
obj.make_descriptions_for_FRF();

%% set parameters
N = floor(length(time)/numberOfBlocks/2)*2;
obj.check_for_uniform_sampling(time);
fs = 1/(time(2)-time(1));
window = hsinew(N);
POverlap = 67;


%% calculation
[Gxx,Gyx,Gyy,f,NBlocks1]=time2xmtrx(input,output,fs,window,POverlap); % AbraVibe
[H,C,Cx]=xmtrx2frf(Gxx,Gyx,Gyy); % AbraVibe

obj.f = f;
obj.H = H;
obj.C = C;


end