function zero_crossing = get_sensor_mode_zero_crossing(position,p,V)% get zero crossing

figure
for s=1:length(p)
    hold off
    plot(position,real(V(:,s)))
    hold on
    grid on
    zeroCrossing=[];
    for k=2:length(V(:,s))
        amp=real(V(k-1:k,s));
        pos=position(k-1:k);
        x0 = interp1(amp,pos,0); % zero crossing
        zeroCrossing = [zeroCrossing, x0(~isnan(x0))];
    end
    plot(zeroCrossing,zeros(size(zeroCrossing)),'o')
    drawnow
    zero_crossing{s} = zeroCrossing;
end

% print zero crossing
disp(' ')
disp('Zero crossing')
for s=1:length(p)
    disp(['Mode ',num2str(s),' ',num2str(imag(p(s))/2/pi,3),'Hz',': ',num2str(zero_crossing{s}*1e3,3),' mm']);
end

end