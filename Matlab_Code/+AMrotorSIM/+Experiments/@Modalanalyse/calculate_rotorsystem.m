function calculate_rotorsystem(obj,n_modes,drehzahl)

      disp('Berechne Modalanalyse Rotorsystem')

      obj.n_ew = n_modes;

      [obj.eigenVectors.x,obj.eigenValues.x] = getEigenform(obj,n_modes,'x');
      [obj.eigenVectors.y,obj.eigenValues.y] = getEigenform(obj,n_modes,'y');


 end