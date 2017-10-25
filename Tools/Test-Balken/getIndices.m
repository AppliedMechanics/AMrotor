function ind = getIndices(BCs)

ind.x = [];
ind.x = [ind.x,BCs(1:4:end)];
ind.x = [ind.x,BCs(4:4:end)];

ind.y = [];
ind.y = [ind.y,BCs(2:4:end)];
ind.y = [ind.y,BCs(3:4:end)];

ind.x = sort(ind.x(~isnan(ind.x)));
ind.y = sort(ind.y(~isnan(ind.y)));

end