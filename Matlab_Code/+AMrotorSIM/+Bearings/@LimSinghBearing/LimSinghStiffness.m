function [K,F] = LimSinghStiffness(par,u)
%LIMSINGHSTIFFNESS %gives forces by displacements according to Lim Singh Model 
%u=(delta_bx   delta_by  delta_bz  beta_bx  beta_by)
%f=(F_bx F_by F_bz M_bx M_by)

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

dsrj=par.A0*cos(par.alpha0)+delta_rj;
%dsrj=(dsrj+abs(dsrj))/2; %only positive

dszj=par.A0*sin(par.alpha0)+delta_zj;

kxx= real(par.K*((A-par.A0).^(1.5) .*cos(par.phi).^2 .*(1.5*A.*dsrj.^2 ./(A-par.A0) +A.^2 -dsrj.^2))./(A.^3));
v2=isnan(kxx);
kxx(v2)=0;
kxx=    sum(kxx);

kxy= real(par.K*((A-par.A0).^(1.5) .*sin(par.phi).*cos(par.phi) .*(1.5*A.*dsrj.^2 ./(A-par.A0) +A.^2 -dsrj.^2))./(A.^3));
v2=isnan(kxy);
kxy(v2)=0;
kxy=    sum(kxy);

kxz= real(par.K*((A-par.A0).^(1.5) .*dsrj.*dszj.*cos(par.phi) .*(1.5*A ./(A-par.A0) -1))./(A.^3));
v2=isnan(kxz);
kxz(v2)=0;
kxz=    sum(kxz);

kxtetax= real(par.rj*par.K*((A-par.A0).^(1.5) .*dsrj.*dszj.*sin(par.phi).*cos(par.phi) .*(1.5*A ./(A-par.A0) -1))./(A.^3));
v2=isnan(kxtetax);
kxtetax(v2)=0;
kxtetax=sum(kxtetax);

kxtetay=real(par.rj*par.K*((A-par.A0).^(1.5) .*dsrj.*dszj.*cos(par.phi).^2 .*(1- (1.5*A ./(A-par.A0))))./(A.^3));
v2=isnan(kxtetay);
kxtetay(v2)=0;
kxtetay=sum(kxtetay);

kyy= real(par.K*((A-par.A0).^(1.5) .*sin(par.phi).^2 .*(1.5*A.*dsrj.^2 ./(A-par.A0) +A.^2 -dsrj.^2))./(A.^3));
v2=isnan(kyy);
kyy(v2)=0;
kyy=sum(kyy);


kyz= real(par.K*((A-par.A0).^(1.5) .*dsrj.*dszj.*sin(par.phi) .*(1.5*A ./(A-par.A0) -1))./(A.^3));
v2=isnan(kyz);
kyz(v2)=0;
kyz=sum(kyz);

kytetax= real(par.rj*par.K*((A-par.A0).^(1.5) .*dsrj.*dszj.*sin(par.phi).^2 .*(-1+ (1.5*A ./(A-par.A0))))./(A.^3));
v2=isnan(kytetax);
kytetax(v2)=0;
kytetax=sum(kytetax);

kytetay=real(par.rj*par.K*((A-par.A0).^(1.5) .*dsrj.*dszj.*sin(par.phi).*cos(par.phi) .*(-1.5*A ./(A-par.A0) +1))./(A.^3));
v2=isnan(kytetay);
kytetay(v2)=0;
kytetay=sum(kytetay);

kzz=    real(par.K*((A-par.A0).^(1.5) .*(1.5*A.*dszj.^2 ./(A-par.A0) +A.^2 -dszj.^2))./(A.^3));
v2=isnan(kzz);
kzz(v2)=0;
kzz=sum(kzz);

kztetax= real(par.rj*par.K*((A-par.A0).^(1.5) .*sin(par.phi) .*(1.5*A.*dszj.^2 ./(A-par.A0) +A.^2 -dszj.^2))./(A.^3));
v2=isnan(kztetax);
kztetax(v2)=0;
kztetax=sum(kztetax);

kztetay= real(par.rj*par.K*((A-par.A0).^(1.5) .*cos(par.phi) .*(-1.5*A.*dszj.^2 ./(A-par.A0) -A.^2 +dszj.^2))./(A.^3));
v2=isnan(kztetay);
kztetay(v2)=0;
kztetay=sum(kztetay);

ktetaxtetax= real(par.rj^2 *par.K*((A-par.A0).^(1.5) .*sin(par.phi).^2 .*(1.5*A.*dszj.^2 ./(A-par.A0) +A.^2 -dszj.^2))./(A.^3));
v2=isnan(ktetaxtetax);
ktetaxtetax(v2)=0;
ktetaxtetax=sum(ktetaxtetax);

ktetaxtetay= real(par.rj^2 *par.K*((A-par.A0).^(1.5) .*sin(par.phi).*cos(par.phi) .*(-1.5*A.*dszj.^2 ./(A-par.A0) -A.^2 +dszj.^2))./(A.^3));
v2=isnan(ktetaxtetay);
ktetaxtetay(v2)=0;
ktetaxtetay=sum(ktetaxtetay);

ktetaytetay= real(par.rj^2 *par.K*((A-par.A0).^(1.5) .*cos(par.phi).^2 .*(1.5*A.*dszj.^2 ./(A-par.A0) +A.^2 -dszj.^2))./(A.^3));
v2=isnan(ktetaytetay);
ktetaytetay(v2)=0;
ktetaytetay= sum(ktetaytetay);
% kxtetaz=0;
% kytetaz=0;
% kztetaz=0;
% ktetaxtetaz=0;
% ktetaytetaz=0;
% ktetaztetaz=0;


K=[kxx kxy kxz kxtetax kxtetay ; kxy kyy kyz kytetax kytetay ; kxz kyz kzz kztetax kztetay ; kxtetax kytetax kztetax ktetaxtetax ktetaxtetay ; kxtetay kytetay kztetay ktetaxtetay ktetaytetay];
end



