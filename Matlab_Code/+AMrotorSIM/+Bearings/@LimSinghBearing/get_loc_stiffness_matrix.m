function [K] = get_loc_stiffness_matrix(self,varargin)
            
% %     par = self. ... ;
%     rpm=varargin{1};
%     par.omega = rpm/60*2*pi;
%     phi0=pi/4; % psi_z an der Stelle des Lagers auslesen
%     par.phi=[0:(2*pi/par.N):(2*pi/par.N)*(par.N-1)]+phi0; %par.N=numberOfBalls
%         
%     % dof-order: ux,uy,uz,psix,psiy,psiz
%     
%     [K_tmp,~] = LimSinghStiffness(par,u);
%     K = sparse(6,6);
%     K(1:5,1:5) = K_tmp;
    K = sparse(6,6);
            
    self.stiffness_matrix = K;
end