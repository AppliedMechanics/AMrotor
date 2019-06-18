clear, close all
[X,Y] = meshgrid(linspace(-1e-3,1e-3,100),linspace(-1e-3,1e-3,100));
parametersGupta20mm
for i = 1:length(X)
    for j = 1:length(Y)
        F = LimSinghForce_test(par,[X(i),Y(j),0,0,0,0]',0);
        Fx(i,j) = F(1);
        Fy(i,j) = F(2);
    end
end

surf(X,Y,Fx)
xlabel('x'),ylabel('y'),zlabel('F_x')
figure
surf(X,Y,Fy)
xlabel('x'),ylabel('y'),zlabel('F_y')