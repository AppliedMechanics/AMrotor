function plot_campbell(Aew,omega,n_ew)

rps=omega/2/pi;

figure()
plot(rps,rps,'b');
hold on;

for s=1:n_ew
plot(rps,imag(Aew(s*2-1,:)/2/pi), rps,imag(Aew(s*2,:)/2/pi))
end

end
