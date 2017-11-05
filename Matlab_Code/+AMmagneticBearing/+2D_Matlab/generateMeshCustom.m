function msh = generateMeshCustom(self, varargin)    
% generateMesh            - Generate a mesh from the geometry        
%    MSH = generateMesh(PDEM) Generates a mesh object from the geometry stored        
%    in the Geometry property. The mesh created is assigned to the Mesh 
%    property of this class and a handle to the mesh is returned in MSH.
%
%    MSH = generateMesh(...,'Name1',Value1, 'Name2',Value2, ...) 
%    uses name/value pairs to override the default meshing values for 
%    'Name1', 'Name2',... Supported options for generateMesh include:
%
%    Property        Value/{Default}         Description
%    -----------------------------------------------------------
%    Hmax            numeric {estimate}    Target maximum edge size
%    Hmin            numeric {estimate}    Target minimum edge size
%    Hgrad           numeric {1.5}         Element gradation control
%    GeometricOrder  linear|{quadratic}    Element geometric order 
%                                          
%
%    Note: For 3D meshing, if the Hmax is inadvertently set too low the mesh
%    generation may take a long time to complete. Use Ctrl-C to interrupt 
%    the meshing.
%
%    Example:  Import a 3D STL geometry, generate the mesh and plot.
%       numberOfPDEs = 1;
%       pdem = createpde(numberOfPDEs);
%       gm = importGeometry(pdem,'Block.stl');
%       % The output mesh object, msh, reports the Max and Min size
%       msh = generateMesh(pdem)
%       pdemesh(msh);
%
% See also pdeplot, pdemesh, pde.FEMesh

% Copyright 2014-2017 The MathWorks, Inc.

    if isempty(self.Geometry)
       msh = [];
       return;
    end    
    if self.IsTwoD && isa(self.Geometry, 'pde.AnalyticGeometry')        
%         try      
%             msh = geninitmesh(self.Geometry.geom,varargin{:});        
%         catch ex
%             throwAsCaller(ex);
%         end          
%        
%         self.Mesh = msh;
%         addlistener(msh,'ObjectBeingDestroyed',@pde.PDEModel.delistMesh); 
%        return;  
        p = inputParser;
        addParameter(p,'Hmax',0,@pde.PDEModel.isValidHmax);
        addParameter(p,'Hmin',0,@pde.PDEModel.isValidHmin);       
        addParameter(p,'GeometricOrder','quadratic', @pde.PDEModel.isValidGeomOrder);        
        addParameter(p,'Hgrad',0,  @pde.PDEModel.isValidHgrad);
        addParameter(p,'MesherVersion','');   % No longer used
        addParameter(p,'Jiggle','');          % No longer used
        addParameter(p,'JiggleIter','');      % No longer used      
        parse(p,varargin{:});
        Hmax = p.Results.Hmax;
        Hmin = p.Results.Hmin;
        Hgrad = p.Results.Hgrad;
        if Hmax ~= 0 && Hmin ~= 0 && Hmin > Hmax         
            error(message('pde:pdeModel:invalidHmaxHmin'));  
        end            
        geomOrder = p.Results.GeometricOrder; 
        try
            msh =  generateMeshFacettedAnalytic(self, Hmax,Hmin,Hgrad,geomOrder);
        catch ex
            throwAsCaller(ex);
         end   
        self.Mesh = msh;
        addlistener(msh,'ObjectBeingDestroyed',@pde.PDEModel.delistMesh); 
    else
        p = inputParser;
        addParameter(p,'Hmax',0,@pde.PDEModel.isValidHmax);
        addParameter(p,'Hmin',0,@pde.PDEModel.isValidHmin);       
        addParameter(p,'GeometricOrder','quadratic', @pde.PDEModel.isValidGeomOrder);
        addParameter(p,'Hgrad',0,  @pde.PDEModel.isValidHgrad);
        parse(p,varargin{:});
        Hmax = p.Results.Hmax;
        Hmin = p.Results.Hmin;
        Hgrad = p.Results.Hgrad;
        if Hmax ~= 0 && Hmin ~= 0 && Hmin > Hmax         
            error(message('pde:pdeModel:invalidHmaxHmin'));  
        end            
        geomOrder = p.Results.GeometricOrder;      
        try
            [nodes, tet, cas, fas, eas, vas, Hmax, Hmin, Hgrad] = genmeshinternal(self.Geometry,Hmax,Hmin,Hgrad,geomOrder);
        catch ex
            throwAsCaller(ex);
        end       
        assoc = pde.FEMeshAssociation(tet, cas, fas, eas, vas);     
        self.Mesh = pde.FEMesh(nodes,tet,Hmax,Hmin, Hgrad, geomOrder,assoc);
        msh = self.Mesh;
        addlistener(msh,'ObjectBeingDestroyed',@pde.PDEModel.delistMesh); 
    end
end  

%{
function msh =  geninitmesh(geom, varargin)         
     ip = inputParser;
     ip.KeepUnmatched=true;
     addParameter(ip,'Hmax',0,@pde.PDEModel.isValidHmax);
     addParameter(ip,'Hmin',0,@pde.PDEModel.isValidHmin);       
     addParameter(ip,'GeometricOrder','linear', @pde.PDEModel.isValidGeomOrder);
     parse(ip,varargin{:});                          
     if ip.Results.Hmin ~= 0   
          error(message('pde:pdeModel:No2DHmin')); 
     end
     nc = numel(ip.Results.GeometricOrder); 
     geomorder = 'linear';
     if ~(strncmpi(ip.Results.GeometricOrder,'linear',nc))
        geomorder = 'quadratic';
     end  
     
     % If a GeometricOrder option is provided then strip it.
     stripidx = [];     
     for i = 1:(nargin-1)
         if ischar(varargin{i})
             nc = numel(varargin{i});     
             if strncmpi(varargin{i},'GeometricOrder',nc)
                 stripidx(end+1) = i;   %#ok
                 stripidx(end+1) = i+1; %#ok
             end
         end 
     end
     if ~isempty(stripidx)
         varargin(stripidx) = [];
     end
     [p, e, t] = initmesh(geom,varargin{:});                
     meshmaxsz = ip.Results.Hmax;
     meshminsz=0;            
     tt = t';
     tt(:,end) = [];
     pt = p';
     tr = triangulation(tt, p');   
     edges = tr.edges();
     dx = pt(edges(:,2),1)-pt(edges(:,1),1);
     dy = pt(edges(:,2),2)-pt(edges(:,1),2);
     if meshmaxsz == 0
        meshmaxsz = max(sqrt(sum(abs([dx dy]).^2,2)));   
     end
     if meshminsz == 0
        meshminsz = min(sqrt(sum(abs([dx dy]).^2,2)));   
     end
     if strcmp(geomorder, 'quadratic')
        [p, e, t] =  lintoquad(geom, p, e, t);
     end     
     assoc = pde.FEMeshAssociation(t, e);
     t(end,:) = [];
     msh = pde.FEMesh(p, t, meshmaxsz, meshminsz, geomorder, assoc);
end

function [p2, e2, t2] =  lintoquad(geom, p, e, t)
    [p2, e2, t2] = linearTriToQuadratic(p',e,t(1:3,:)');
    %
    % Perform the projection
    %
    nume = size(e2, 2);
    mididx = 2:2:nume;
    ptidx = e2(1,mididx);
    params = e2(3,mididx);
    eid = e2(5,mididx);
    [x, y] = pdeigeom(geom, eid, params);
    p2(ptidx,1) = x;
    p2(ptidx,2) = y;
    p2 = p2';
    t2 = t2';
    sdl = t(4,:);
    t2(end+1,:) = sdl;       
end
%}
