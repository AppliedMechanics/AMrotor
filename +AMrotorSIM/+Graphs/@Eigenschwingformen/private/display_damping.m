function display_damping( strCoordinate, eigenvalue )

delta = -real(eigenvalue);
omega = imag(eigenvalue);

D = delta/omega; % Lehr damping
disp([strCoordinate,'  ',num2str(D*100),' % modal damping'])

end

