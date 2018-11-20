function plot_omegas( ax,rpm,EW,color )
%PLOT_OMEGAS Summary of this function goes here
%   Detailed explanation goes here
    plot(ax,rpm,imag(EW)/2/pi,...
              'Color',color)
          
    % plot harmonic excitation
    plot(ax,rpm,rpm/60*2*pi,'Color','black','LineStyle','--')

end

