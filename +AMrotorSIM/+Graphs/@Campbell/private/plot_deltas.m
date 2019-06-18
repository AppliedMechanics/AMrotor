function plot_deltas( ax,x,y,color )
%PLOT_DELTAS Summary of this function goes here
%   Detailed explanation goes here
    plot(ax,x,-real(y),...
              'Color',color)

end

