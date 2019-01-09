function plot_omegas( ax,x,y,color )
%PLOT_OMEGAS Summary of this function goes here
%   Detailed explanation goes here
    plot(ax,x,imag(y)/2/pi,...
              'Color',color)

end

