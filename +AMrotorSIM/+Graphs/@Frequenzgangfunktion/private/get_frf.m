function [f,frf,inLocDof,outLocDof] = get_frf(obj,paramPlot)
dofPerNode = 6;

nNodesOut = size(obj.experimentFRF.H,2)/dofPerNode;
nNodesIn = size(obj.experimentFRF.H,3)/dofPerNode;


in=[];out=[];
for i=1:nNodesOut
    out = [out, paramPlot.outputDirection+6*(i-1)];
end
for i=1:nNodesIn
    in = [in, paramPlot.inputDirection+6*(i-1)];
end

f=obj.experimentFRF.f;
frf=obj.experimentFRF.H(:,out,in);
inLocDof = in;
outLocDof = out;

end