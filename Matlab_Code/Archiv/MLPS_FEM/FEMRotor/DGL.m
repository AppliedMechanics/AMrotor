function zpunkt = DGL(t, z, Jzz, Moden, K_m, KDI_m, Nn_m, DDI_m, DDA_m, Gn_m, h_m, h_ZPsin_m, h_ZPcos_m, h_DBsin_m, h_DBcos_m, h_sin_m, h_cos_m)

% =========================================================================
% Gleichung der Fuehrungsbewegung
% =========================================================================

M=0;

zpunkt = zeros(4*Moden+2,1);
zpunkt(1) = z(2);
zpunkt(2) = M/Jzz;

% =========================================================================
% Gleichung der Rotorbiegeschwingung
% =========================================================================

K_DGL = K_m + Nn_m*zpunkt(2) + z(2)*KDI_m;
D_DGL = DDI_m + DDA_m + Gn_m*z(2);
h_DGL = [zeros(2*Moden,1); h_m + (h_ZPsin_m*z(2)^2 +h_DBsin_m*zpunkt(2) +h_sin_m) * sin(z(1)) + (h_ZPcos_m*z(2)^2 +h_DBcos_m*zpunkt(2) +h_cos_m) * cos(z(1));];

zpunkt(3:length(z)) = [ -zeros(2*Moden,2*Moden), eye(size(K_DGL)); -K_DGL, -D_DGL] * z(3:end) + h_DGL;
%zpunkt=zpunkt.';
