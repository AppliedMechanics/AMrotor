function node_nr = find_node_nr(self,position)

    for i = 2:length(self.mesh.nodes)
%         if self.mesh.nodes(1,i-1).z < position < self.mesh.nodes(1,i).z %
%         Bug in urspruenglicher Version (oben) -> z.B. der Ausdruck
%         0.008<0.009<0.012 liefert 0(false), obwohl der Ausdruck wahr ist, da
%         Matlab daraus (0.008<0.009)<0.012 => 1<0.012 => false macht
%         Weiteres Beispiel, das unerwartete Ergebnisse liefert:
%           0.004<0.009<0.006 => (0.004<0.009)<0.006 => 0<0.006 => true,
%           obwohl Ausdruck false sein muesste
        if self.mesh.nodes(1,i-1).z < position && position < self.mesh.nodes(1,i).z
            % neue "verbesserte" Version: Es wird einer Position immer der
            % vorherige Knoten zugeordnet
           if position - self.mesh.nodes(1,i-1).z < self.mesh.nodes(1,i).z - position
                node_nr = self.mesh.nodes(1,i-1).name;
                break
           else
                node_nr = self.mesh.nodes(1,i).name;
                break
           end
        elseif position == self.mesh.nodes(1,i-1).z 
            node_nr = self.mesh.nodes(1,i-1).name;
            break
        elseif position == self.mesh.nodes(1,i).z 
            node_nr = self.mesh.nodes(1,i).name;
            break
        end
    end
end