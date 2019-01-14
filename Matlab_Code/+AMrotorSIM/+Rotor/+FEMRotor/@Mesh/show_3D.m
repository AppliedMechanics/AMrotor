function [ax]=show_3D(self)
   a=1;
   n=1;
   dimR=size(self.nodes);
   n_nodes = length(self.nodes);
   r=zeros(n_nodes,1);
   mesh_node_z=zeros(1,n_nodes);
   mesh_node_radius=zeros(1,n_nodes);

   f2=figure;
% erzeuge Vektor r mit Radien der Abschnitte
%==========================================================================
%    for k=1:n_nodes


    for k=1:n_nodes
        mesh_node_z(k) = self.nodes(k).z;
        mesh_node_radius(k) = self.nodes(k).radius_outer;
    end
    while n <=n_nodes

        r(n,1)=mesh_node_radius(n);

        n=n+1;

    end

    if a < dimR(1)
        a=a+1;
    end

%    end

%==========================================================================
   ax = axes('xlim', [-10 10], 'ylim', [-10 10], 'zlim',[-10 10]);

   view(3);
   grid on;
   axis equal;
   hold on
   xlabel('z')
   ylabel('y')
   zlabel('x')

   dim_r=size(r);
   theta = linspace(0,2*pi,20);

   k=1;
   %%%%%%%%%%%%%%%%%%%%%%%
   %erstes el
   rs = linspace(0,r(1),2);
   % 
   [TH,R] = meshgrid(theta,rs);
   % 
   Z=((R.*cos(TH)).^2)-((R.*sin(TH)).^2); % z=(x^2)-(y^2)
   % 
   [x,y,z] = pol2cart(TH,R,Z);

   z=z*0;

   hs(1)=surf(z+mesh_node_z(1),y,x);
   set(hs(1), 'edgecolor','none')
   set(hs(1), 'facecolor','b')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


   for n=2:dim_r(1)

   %Berechnen der Zylinderelemente   
        [xzyl, yzyl, zzyl] = cylinder([r(n) r(n)]);

        %[xZ1, yz1, zZ1] = cylinder([r(n) r(n)]);

        zzyl(1,:)=mesh_node_z(n-1);
        zzyl(2,:)=mesh_node_z(n);

   %% berechenen der Scheiben bzw Zyl. Deckel :-))

        rs = linspace(0,r(n),2);
% 
        [TH,R] = meshgrid(theta,rs);
% 
        Z=((R.*cos(TH)).^2)-((R.*sin(TH)).^2); % z=(x^2)-(y^2)
% 
        [x,y,z] = pol2cart(TH,R,Z);

        z=z*0;

        %plote Zylinder
        %hz(n) = surf(zzyl,yzyl, xzyl);
        hz(n) = surf(zzyl,yzyl, xzyl);
        set(hz(n), 'edgecolor','k')%set(hz(n), 'edgecolor','none')
        set(hz(n), 'facecolor','b')
        %Plote Deckel
        %hs(n)=surf(z+geo_node_x(n),y,x);
        hs(n)=surf(z+mesh_node_z(n),y,x);
        set(hs(n), 'facecolor','b')

        if r(n) > r(n-1) 

            set(hs(n), 'edgecolor','none') %sichtbare deckel ohne edges

        end

        if r(n) < r(n-1)
            set(hs(n-1), 'edgecolor','none')   %sichtbare deckel ohne edges
        end

        k=k+2;

   end

   set(hs(n), 'edgecolor','none')
   set(hs(n), 'facecolor','b')


   zz=1:50;

   end