function msh = generateMeshFacettedAnalyticCustom(self, Hmax, Hmin, Hgrad, geomOrder)     
% generateMeshFacettedAnalytic - Generate a mesh by first facetting the
% analytic geometry and then meshing the facetted geometry.
%
% Internal use only

% Copyright 2017 The MathWorks, Inc.
gm = self.Geometry;
F = self.facetAnalyticGeometry(gm);
[nodes, tri, cas, fas, eas, vas, Hmax, Hmin, Hgrad, esense] = genMeshFromFacetRep(F, Hmax, Hmin, Hgrad, geomOrder);
assoc = pde.FEMeshAssociation(tri, cas, fas, eas, vas, esense) 
[nodes, ndparams] = projectEdgeNodesToCurves(nodes, gm, assoc);
msh = pde.FEMesh(nodes,tri,Hmax,Hmin, Hgrad, geomOrder,assoc, ndparams);
end

% projectEdgeNodesToCurves - project edge nodes to curves and compute
%                            nodal parametric positions.
function [nodes, ndparams] = projectEdgeNodesToCurves(nodes, gm, ma)
    numEdges = gm.NumEdges();
    ndparams = cell(1,numEdges);
    geom = gm.geom;
    isfcn = false;
    if(isa(geom, 'function_handle'))
        isfcn = true;
    end
    NumRealArcFacets = 12;
    for edgeId = 1:numEdges
        en = ma.getNodes('Edge',edgeId);
        xy = nodes(:,en)';
        darcL = sqrt(sum((diff(xy,1,1).^2), 2)); %#ok<UDIM> % Facet, lengths
        s = [0; cumsum(darcL)]; % Arc length at each node in polycurve
        s0 = 0; % Start parameter of polycurve
        s1 = s(end); % Total length of edge == end parameter of polycurve
        D=pdeigeom(geom,edgeId);
        sp = D(1);
        ep = D(2);        
        P = linspace(sp, ep, NumRealArcFacets);
        P(1) = sp;
        P(end) = ep;
        [X,Y]=pdeigeom(geom,edgeId,P);
        XY = [X; Y];
        pp = pdearcl(P,XY,s,s0,s1);
        % start and end parameters may be off by eps
        % Adjust to avoid NaNs
        pp(1) = sp;
        pp(end) = ep;
        ndparams{edgeId} = [pp(1:end-1); pp(2:end)];
        if isfcn || (geom(1,edgeId) ~= 2)
            [Xn,Yn]=pdeigeom(geom,edgeId,pp);        
            nodes(1,en) = Xn;
            nodes(2,en) = Yn;                
        end
    end
end
