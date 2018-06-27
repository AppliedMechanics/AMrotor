 function compute_loads(obj) 
          
            h.h = zeros(4*length(obj.rotor.nodes),1);   

            %centripetal-force unbalance, rotating
            h.h_ZPsin = h.h;                                      
            h.h_ZPcos = h.h;   

            %unbalance mass inertia force 
            h.h_DBsin = h.h;                                 
            h.h_DBcos = h.h;


            %Constant_fix_force   e.g wight force
            h.h_sin = h.h;                     
            h.h_cos = h.h;


            %rotating_fix_force%   e.g  bearing exitation 
            h.h_rotsin = h.h;                   
            h.h_rotcos = h.h;

          
            for i=obj.loads

            i.compute_load();
            [hi]=assembling_loads(i,obj.rotor);
            
                fields = fieldnames(h);
                for j=1:numel(fields)
                    h.(fields{j})=h.(fields{j})+hi.(fields{j});
                end
            end
            
            obj.systemmatrizen.h = h;
end 