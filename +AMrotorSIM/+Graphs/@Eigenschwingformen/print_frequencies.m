function print_frequencies(obj)

     n_ew=obj.modalsystem.n_ew;
      %
      disp('Eigenkreisfrequenzen')
        for s=1:n_ew
            disp(' ')
            disp([num2str(s),'. Eigenfrequenz'])
            displayFrequencies('lateral',imag(obj.modalsystem.eigenValues.lateral),s)
        end
        
end