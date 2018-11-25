function [F] = LimSinghForce(self,par,u)
%LIMSINGHFORCE %gives forces by displacements according to Lim Singh Model 
%u=(delta_bx   delta_by  delta_bz  beta_bx  beta_by)
%f=(F_bx F_by F_bz M_bx M_by)
% faster than LimSinghStiffness because only calculation of force

delta_zj= u(3) + par.rj*(u(4)*sin(par.phi) - u(5)*cos(par.phi));
delta_rj= u(1)*cos(par.phi) +u(2)*sin(par.phi) -par.rL;
% delta_rj=(delta_rj+abs(delta_rj))/2; %only positive

A=sqrt((par.A0*sin(par.alpha0) + delta_zj).^2 +(par.A0*cos(par.alpha0)+delta_rj).^2);
%  check=A-par.A0;
alphaj=atan2((par.A0*sin(par.alpha0) + delta_zj),(par.A0*cos(par.alpha0) + delta_rj))*360/(2*pi);
% check=(check+abs(check))/2; %only positive
var=(alphaj<90);
A=var.*A;

   f(1,:)= real(par.K*((A-par.A0).^(1.5))./(A)).* [(par.A0*cos(par.alpha0)+delta_rj).*cos(par.phi)];
   f(2,:)= real(par.K*((A-par.A0).^(1.5))./(A)).* [(par.A0*cos(par.alpha0)+delta_rj).*sin(par.phi)];
   f(3,:)= real(par.K*((A-par.A0).^(1.5))./(A)).* [(par.A0*sin(par.alpha0)+delta_zj)];
   f(4,:)= real(par.K*((A-par.A0).^(1.5))./(A)).* [par.rj*(par.A0*sin(par.alpha0)+delta_zj).*sin(par.phi)];
   f(5,:)= real(par.K*((A-par.A0).^(1.5))./(A)).* [-par.rj*(par.A0*sin(par.alpha0)+delta_zj).*cos(par.phi)];
   
F=sum(f,2)';

F=[F'; 0];

end



