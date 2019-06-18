function plot_damping_ratio( ax,x,y,color )
%PLOT_DELTAS Summary of this function goes here
%   Detailed explanation goes here
    plot(ax,x,-real(y)./imag(y),...
              'Color',color)

end

