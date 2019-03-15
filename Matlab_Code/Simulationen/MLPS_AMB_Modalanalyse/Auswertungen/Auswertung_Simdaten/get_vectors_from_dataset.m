function [t,x,y,Fx,Fy] = get_vectors_from_dataset(filename)
load(filename)
% extract the time and measured values from the time table
t = data.time;

x(:,1) = data.x_dir_WegLager1links_;
x(:,2) = data.x_dir_WegLager1_;
x(:,3) = data.x_dir_WegLager1rechts_;
x(:,4) = data.x_dir_WegScheibe_;
x(:,5) = data.x_dir_WegLager2links_;
x(:,6) = data.x_dir_WegLager2_;
x(:,7) = data.x_dir_WegLager2rechts_;

y(:,1) = data.y_dir_WegLager1links_;
y(:,2) = data.y_dir_WegLager1_;
y(:,3) = data.y_dir_WegLager1rechts_;
y(:,4) = data.y_dir_WegScheibe_;
y(:,5) = data.y_dir_WegLager2links_;
y(:,6) = data.y_dir_WegLager2_;
y(:,7) = data.y_dir_WegLager2rechts_;

% Anregungskraft
Fx(:,1) = data.x_dir_KraftLager1_;% Lager 1
Fx(:,2) = data.x_dir_KraftLager2_;% Lager 2

Fy(:,1) = data.y_dir_KraftLager1_;% Lager 1
Fy(:,1) = data.y_dir_KraftLager2_;% Lager 2

end