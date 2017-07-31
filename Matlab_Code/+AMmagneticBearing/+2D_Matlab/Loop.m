for i=-0.5:0.11:0.5
vx=i*1e-3;
vy=-i*1e-3;

fprintf('vx= %e; vy= %e \t', vx, vy);

[Fx, Fy]=FEM_MagLag([vx vy],0,0);

end