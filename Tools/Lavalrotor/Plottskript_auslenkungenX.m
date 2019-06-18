load('H:\BA\Robert_Hoefer_Paket\+AMrotorMONI\TUMFarben.mat')
%Unwuchte
epsilon=  1e-3 +1i*1e-3; %m
%schlag
a= 0%1e-3 -1i*1e-3; %m
%Kupplungsversatz
bKV= 0%-1e-3 +1i*1e-3;  % m
%Achsversatz
bAV= 0%-1e-3 -1i*1e-3;   
    
t=0;
k=0;
X = [];
Y = [];
Drehzahl = [];
r_M =[];
for Omega = 0:1:150;
k=k+1;
r_M = ( k_M*a + k_K*bKV + Masse*epsilon*Omega^2 )/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
Drehzahl(k)= Omega;
X(k) = real(r_M);
Y(k) = imag(r_M);
    if Omega >70 && Omega <75
        Drehzahl(k)= inf;
    end
end
 plot(Drehzahl,X,'-.','color',TUM.orange,'LineWidth',1);
 hold on

 
 
%Unwuchte
epsilon= 0%1e-3 +1i*1e-3; %m
%schlag
a= 1e-3 -1i*1e-3; %m
%Kupplungsversatz
bKV= 0%-1e-3 +1i*1e-3;  % m
%Achsversatz
bAV= 0%-1e-3 -1i*1e-3;   
    
t=0;
k=0;
X = [];
Y = [];
Drehzahl = [];
r_M =[];
for Omega = 0:1:150;
k=k+1;
r_M = ( k_M*a + k_K*bKV + Masse*epsilon*Omega^2 )/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
Drehzahl(k)= Omega;
X(k) = real(r_M);
Y(k) = imag(r_M);
 if Omega >70 && Omega <75
        Drehzahl(k)= inf;
    end
end
 plot(Drehzahl,X,'--','color',TUM.schwarz08,'LineWidth',1)
 hold on

 
 
 
 %Unwuchte
epsilon=  0%1e-3 +1i*1e-3; %m
%schlag
a= 0%1e-3 -1i*1e-3; %m
%Kupplungsversatz
bKV= -5e-3 +5i*1e-3;  % m
%Achsversatz
bAV= 0%-1e-3 -1i*1e-3;   
    
t=0;
k=0;
X = [];
Y = [];
Drehzahl = [];
r_M =[];
for Omega = 0:1:150;
k=k+1;
r_M = ( k_M*a + k_K*bKV + Masse*epsilon*Omega^2 )/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
Drehzahl(k)= Omega;
X(k) = real(r_M);
Y(k) = imag(r_M);
 if Omega >70 && Omega <75
        Drehzahl(k)= inf;
    end
end
 plot(Drehzahl,X,'-.','color',TUM.schwarz,'LineWidth',1)
 hold on

 
 
 
 %Unwuchte
epsilon=  0%1e-3 +1i*1e-3; %m
%schlag
a= 0%1e-3 -1i*1e-3; %m
%Kupplungsversatz
bKV= 0%-1e-3 +1i*1e-3;  % m
%Achsversatz
bAV= -5e-3 -5i*1e-3;   
    
t=0;
k=0;
X = [];
Y = [];
Drehzahl = [];
r_M =[];
for Omega = 0:1:150;
k=k+1;
r_M = ( k_M*a + k_K*bKV + Masse*epsilon*Omega^2 )/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
Drehzahl(k)= Omega;
X(k) = real(r_M);
Y(k) = imag(r_M);

end
 plot(Drehzahl,X,':','color',TUM.gruen,'LineWidth',1.5)
 hold on

 
 
%Unwuchte
epsilon=  1e-3 +1i*1e-3; %m
%schlag
a= 1e-3 -1i*1e-3; %m
%Kupplungsversatz
bKV= -5e-3 +5i*1e-3;  % m
%Achsversatz
bAV= -5e-3 -5i*1e-3;   
    
t=0;
k=0;
X = [];
Y = [];
Drehzahl = [];
r_M =[];
for Omega = 0:1:150;
k=k+1;
r_M = ( k_M*a + k_K*bKV + Masse*epsilon*Omega^2 )/( k_M + k_K - Masse*Omega^2 ) *exp(1i*Omega*t) + ( k_K )/( k_K + k_M )* bAV ;
Drehzahl(k)= Omega;
X(k) = real(r_M);
Y(k) = imag(r_M);
 if Omega >70 && Omega <75
        Drehzahl(k)= inf;
    end
end
 plot(Drehzahl,X,'-','color',TUM.blau,'LineWidth',1)
 legend('Unwucht','Schlag','Kupplungsversatz','Achsversatz','Alle Fehler')
 xlabel('\Omega in  [ rad sec^{-1} ]')
 ylabel('X-Auslenkung in  [ m ]')
 ylim([-0.03,0.03])
 grid on
 grid minor
 
 hold off