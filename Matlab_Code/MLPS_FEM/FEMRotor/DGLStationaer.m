function zpunkt = DGLStationaer(t, z, A, Omega0, h_m, h_sin_m, h_cos_m)

% =========================================================================
% Gleichung der Rotorbiegeschwingung
% =========================================================================

zpunkt = A * z + h_m + h_sin_m*sin(Omega0*t) + h_cos_m*cos(Omega0*t);
zpunkt=zpunkt;
