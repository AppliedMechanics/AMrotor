function F = calculate_bearing_force(rotorsystem,time,displacement,velocity)
% calculate the force of the sensor BearingForceSensor
%   Uses the displacment and velocity to obtain the force of
%   the corresponding bearings; does not use an inertia term
%   Calculates the forces of the bearing acting ON the rotor:
%   F_bearing = - (k*x + d*x_dot)
F = zeros(size(displacement,1),size(displacement,2));

if any(strcmp({rotorsystem.sensors.type},'BearingForceSensor'))
    %get the bearings
    isBearing = strcmp({rotorsystem.components.type},'Bearings');
    bearings = rotorsystem.components(isBearing);
    h_ges = zeros(size(displacement,1),size(displacement,2));
    
    
    for k = 1:length(time)
        currDisplacement = displacement(:,k); 
        currVelocity = velocity(:,k);

        node_nr = 1; %leftmost node
        dof_psiz = rotorsystem.rotor.get_gdof('psi_z',node_nr);
        Omega = velocity(dof_psiz,k);
        rpm = Omega / (2*pi) *60;
        [M_Comp,C_Comp,G_Comp,K_Comp]= rotorsystem.get_component_matrices(bearings,rpm);
        D_Comp = C_Comp + Omega*G_Comp;
        
        h_ges(:,k) = -(D_Comp*currVelocity + K_Comp*currDisplacement);
    end
    F = h_ges;
end

end