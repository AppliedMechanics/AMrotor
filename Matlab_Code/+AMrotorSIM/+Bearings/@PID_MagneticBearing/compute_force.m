function [Fx,Fy]= compute_force(obj, x,y,Ix,Iy)
            
            %Magnetlagerkonstanten aus Config-Datei
            k_i=obj.cnfg.mag.k_i;
            k_s=obj.cnfg.mag.k_s;

            i_max = obj.cnfg.mag.I_max;
            i_min = obj.cnfg.mag.I_min;
            
%            Ix = min(Ix,i_max); Ix = max(Ix,i_min);
%            Iy = min(Iy,i_max); Iy = max(Iy,i_min);
%            k_s=0;
            %Kraftbestimmung
            Fx=k_s*x+k_i*Ix;
            Fy=k_s*y+k_i*Iy;
         
end
