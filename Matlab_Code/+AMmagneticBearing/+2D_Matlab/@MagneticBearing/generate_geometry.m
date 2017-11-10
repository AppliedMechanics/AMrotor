function generate_geometry(self)
%GENERATE_GEOMETRY Summary of this function goes here
%   Detailed explanation goes here

gm=horzcat(reshape([self.cnfg.geometry.rect(:).geo],10,[]),...
           reshape([self.cnfg.geometry.circ(:).geo],10,[]));
ns=char(...
   horzcat(         {self.cnfg.geometry.rect(:).name},...
                    {self.cnfg.geometry.circ(:).name}))';
       
[dl,bt]=decsg(gm,self.cnfg.geometry.sf,ns);                    % Erzeugen der Geometrie 
% Ohne zweiten Kreis in Welle:
edges.delete=[8,176,93,22,114,117,178,100,180,94,125,166,89,168,18,104,170,130,98,172,103,122,174,163, ...
              144,111,126,127,9,149,10,150,90,14,128,135,160,15,129,151,97,19,24,95,96,106,20,25,91,132,112,154,155,101,156,145,138,136,102,161,157,107,121,13,21,162,137,120,26,12,92,146,119,11,118,113,105,16,133,17];
% Mit zweitem Kreis in Welle:
% edges.delete=[196 194 188 186 192 190 184 182 14 116 109 110 117 17 138 136 172 149 107 144 153 28 152 27 26 151 25 24 118 119 29 30 176 120 121 177 122 178 123 179 16 115 23 108 20 137 173 167 145 21 146 142 18 148 165 166 102 103 13 130 162 129 128 10 11 127 112 113 104 105 141 133 170 171 12 134 135 15 101 34 114 161 22 100 106 99 19 143 160 98 97 9 8 22 33 154 32 33];
    
[dl,~]=csgdel(dl,bt, edges.delete);    % Loesche alle Kanten aus dem Array "KantenDel"

geometryFromEdges(self.model,dl);           % Erzeugen der Geometrie
end

