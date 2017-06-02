%analytische Berechnung des Kennfeldes des standardisierten
%Hufeisenmagneten 2
%Michael Mirza 30.03.2017

AKSHM2=zeros(375,3)
mu0=4*pi*10^-7
murfe=10000
murluft=1
a=0.01
n=4
k3=1
for k1=1:1:15
    Iz=k1
    for k2=1:1:25
        x=k2/100
        lfe=4*8*a-2*x*a
        lluft=2*x*a
        area=4*a^2
        rmfe=lfe/(mu0*murfe*area)
        rmluft=lluft/(mu0*murluft*area)
        rmges=rmfe+rmluft
        durchflutung=n*Iz
        flux=durchflutung/rmges
        b=flux/area
        sigma=(1/2)*(b^2)*((mu0*(murfe-murluft))/(mu0^2*murfe*murluft))
        Fx=2*area*sigma
        Fy=0
        AKSHM2(k3,1)=Iz
        AKSHM2(k3,2)=x
        AKSHM2(k3,3)=Fx
        %AKSHM2(k3,4)=Fy
        k3=k3+1
        
        
        
        
        
        
    end
    
    
end
csvwrite('AnalytKFSHM2.csv',AKSHM2)

