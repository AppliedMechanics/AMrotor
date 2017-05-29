function [Fx,Fy]= compute_force(obj, x,y,Ix,Iy)
            
            %Magnetlagerkonstanten aus Config-Datei
            k_i=obj.cnfg.mag.k_i;
            k_s=obj.cnfg.mag.k_s;

            %Kraftbestimmung
            Fx=k_s*x+k_i*Ix;
            Fy=k_s*y+k_i*Iy;
         
end
