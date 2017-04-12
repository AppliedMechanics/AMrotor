function plot_EV_EW(AevR,Aew,nodes,n_ew)

disp('Eigenkreisfrequenzen')

for s=1:n_ew
disp([num2str(imag(Aew(s*2-1,1))/(2*pi)),' Hz'])
end


figure()
hold on;

for s=1:n_ew
plot(nodes,((imag(AevR(1:2:end/2,s))/(norm(AevR(1:2:end/2,s))))));
end

end