% Test different options of differentiation by the TIMEDIFF command

if ~exist('fid','var')
    fid=1;
end

f0=17;
fs=1000;
N=2000;

fprintf(fid,'Testing TIMEDIFF...\n')

% Create an input time signal x=sin(17Hz), 5 seconds long
t=(0:1/fs:5)';
x=sin(2*pi*f0*t);
% Create true derivative yt=2*pi*f0*cos(17Hz)
yt=2*pi*f0*cos(2*pi*f0*t);

% Try the different options of timediff, 'simple' and 'fir'
y1=timediff(x,fs,'maxflat');
y2=timediff(x,fs,'remez');
% Make all signals same length as y2 which has longest delay (is shortest)
y1=y1(1:length(y2));
yt=yt(1:length(y2));
t=t(1:length(y2));

% Throw away additionally the 20 first samples of all signals because the
% FIR method performs badly there
t=t(21:end);
yt=yt(21:end);
y1=y1(21:end);
y2=y2(21:end);


R1=std(yt-y1)/std(yt);
R2=std(yt-y2)/std(yt);

if R1 > 1e-10
    fprintf(fid,'ERROR in timediff, Type=''MaxFlat'': error too large!\n')
end
if R2 > 1e-6
    fprintf(fid,'ERROR in timediff, Type=''Remez'': error too large!\n')
end

fprintf(fid,'TIMEDIFF tested. If no outputs it was ok\n')