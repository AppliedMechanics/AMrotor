function [ax]=show_3D(self)
    ele = self.elements;
   nEle = length(self.elements);

   f2=figure;

   ax = axes('xlim', [-10 10], 'ylim', [-10 10], 'zlim',[-10 10]);

   view(3);
   grid on;
   axis equal;
   hold on
   xlabel('z')
   ylabel('y')
   zlabel('x')
   
   theta = linspace(0,2*pi,20);


   for n=1:nEle

       rEle = ele(n).radius_outer;
       
   %% Berechnen der Zylinderelemente   
        [xzyl, yzyl, zzyl] = cylinder([rEle, rEle]);
        
        zLeft = ele(n).node1.z;
        zRight = ele(n).node2.z;
        zzyl(1,:)=zLeft;
        zzyl(2,:)=zRight;

   %% berechenen der Scheiben bzw Zyl. Deckel :-))

        rs = linspace(0,rEle,2);
        [TH,R] = meshgrid(theta,rs);
        Z=((R.*cos(TH)).^2)-((R.*sin(TH)).^2); % z=(x^2)-(y^2)
        [x,y,z] = pol2cart(TH,R,Z);
        z = z*0;
        
        %% Plote Deckel
        hs_left(n)=surf(z+zLeft,y,x);
        hs_right(n)=surf(z+zRight,y,x);
        set(hs_left(n), 'facecolor','b')
        set(hs_right(n), 'facecolor','b')

        %% plote Zylinder
        hz(n) = surf(zzyl,yzyl, xzyl);
        set(hz(n), 'edgecolor','none')
        set(hz(n), 'facecolor','b')

%% Ausblenden der Kanten der sichtbaren Deckel
%         if r(n) > r(n-1) || n == 2
%             set(hs_left(n), 'edgecolor','none')
%         end
%         if r(n) < r(n-1)
%             set(hs_right(n-1), 'edgecolor','none')
%         end


   end

%% Ausblenden der linken und rechten Deckel
%    set(hs_left(1), 'edgecolor','none')
%    set(hs_left(1), 'facecolor','b')
%    set(hs_right(n), 'edgecolor','none')
%    set(hs_right(n), 'facecolor','b')

   end