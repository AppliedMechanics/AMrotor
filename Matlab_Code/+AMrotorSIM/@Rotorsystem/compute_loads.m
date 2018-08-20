 function compute_loads(obj) 
 
    for i=obj.loads
    i.compute_load();
    end
    
end 