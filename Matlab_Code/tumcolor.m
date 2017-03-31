function color = tumcolor(c)
%TUMCOLOR gibt eine TUM-Farbe aus

keys = {'b1','b2','b3','g1','g2','g3','a1','a2','a3','a4','a5'};
values = {[0 101 189],[0 82 147],[0 51 89],[88,88,90],[156,157,159],[217,218,219],[227,114,34],[162,173,0],[152,198,234],[100,160,200],[218,215,203]};
colors = containers.Map(keys,values);
color = colors(c)./255;

end

