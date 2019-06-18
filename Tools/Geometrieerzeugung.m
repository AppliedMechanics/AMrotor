%% Geometrieerzeugung der Rotor-Scheibe-Aufbau

%Aufräumen
close all;
clear all;
clc;

%Ausgabe in der Form z.B geometrie=[z1,da,di;z2,da,di];
    
      %Start
      z_start=input('Geben Sie die Z-Startkoordinate des 1.Abschnitts ein \n');
      da_start=input('Geben Sie den Aussendurchmesser des 1.Anschnitts ein \n');
      di_start=input('Geben Sie den Innendurchmesser des 1.Anschnitts ein \n');
      array_start = [z_start , da_start , di_start];
  
     
      %Ende des ersten Abschnitts
      fprintf('\nGeben Sie die Z-Endkoordinate des 1.Abschnitts ein \n');
      z_1=input('\n Z-Endkoordinate: ');
      fprintf('\nGeben Sie den Aussendurchmesser des 1.Anschnitts ein \n');
      da_1=input('\nAussendurchmesser: ');
      fprintf('\nGeben Sie den Innendurchmesser des 1.Anschnitts ein \n');
      di_1=input('\nInnendurchmesser: \n');
      x_end1=[z_1 , da_1 , di_1];
      x_temp1=horzcat(array_start , x_end1);
%       %Abfrage ob weitere Abschnitte gewünscht sind
      i=0;
      while true 
      n=input('\n\nWollen sie weiteren Abschnitten hinzufügen? Ja(1) Nein(0) \n');
          if n==1
      fprintf('\nGeben Sie die Z-Endkoordinate des Abschnitts ein \n');
      z=input('\n Z-Endkoordinate: ');
      fprintf('\nGeben Sie den Aussendurchmesser des Anschnitts ein \n');
      da=input('\nAussendurchmesser: ');
      fprintf('\nGeben Sie den Innendurchmesser des Anschnitts ein \n');
      di=input('\nInnendurchmesser: \n');
      i=i+1;
      x_end2(i,:)=[z , da , di];
     
          elseif n==0
          break;
          end    
      end
            %Matrix in Vektor umwandeln
      if i~=0
      b=x_end2'; 
      c=b(:);
      d=c';
            %Endergebnis als Zeilenvektor ausgeben      
      x_temp3=horzcat(x_temp1 , d);
      disp(x_temp3);
      L= length(d);
           
           %Plot der Geometriekontur
       j=1;
      while j<=L-2
          z_koord(:,j)= [d(j) d(j)];
          j=j+3;
      end
         z_koord( z_koord==0)=[] ;
         z_koord(end)=[];
                   
         m=2;
      while m<=L-1
          da_koord(:,m)=[ d(m) d(m)];
          m=m+3;
      end
         da_koord(  da_koord==0)=[] ;
         
       z_plot=[z_start z_1 z_1 z_koord];
       da_plot=[da_start  da_1  da_koord ]; 
       figure(1) 
       plot(z_plot, da_plot, 'b.- ')                
       xlabel('Z mm')
       ylabel('Aussendurchmesser mm') 
       ylim ([0 inf])
   
      else
       disp( x_temp1);
       z_plot=[z_start z_1 ];
       da_plot=[da_start  da_1   ]; 
       figure(1) 
       plot(z_plot, da_plot, 'b.- ')                
       xlabel('Z mm')
       ylabel('Aussendurchmesser mm') 
       ylim ([0 inf])
      end
    
      
      