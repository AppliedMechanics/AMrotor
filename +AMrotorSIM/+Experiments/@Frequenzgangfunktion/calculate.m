function [f,H] = calculate(obj,f,inPos,outPos,type,rpm,inputDirection,outputDirection)
% CALCULATE calculate the frequency response function of the M,D,K-system
%   calculates frf of M,D,K-system using abravibe's function mck2frf
%   searches the nearest points to the user input positions and gets the
%   dof in the desired diections
% [f,H] = calculate(obj,f,inPos,outPos,type,rpm,inputDirection,outputDirection)
%
% See also mck2frf
    inputNode = obj.rotorsystem.rotor.get_node_no(inPos);
    outputNode = obj.rotorsystem.rotor.get_node_no(outPos);
    
    inputDofNode = obj.rotorsystem.rotor.get_dof_no(inputNode);
    outputDofNode = obj.rotorsystem.rotor.get_dof_no(outputNode);
    
    inputDirection = obj.set_dof_number(inputDirection);
    outputDirection = obj.set_dof_number(outputDirection);
    
    nNodesOut = length(outputNode);
    nNodesIn = length(inputNode);
    indexIn=[];indexOut=[];
    for i=1:nNodesOut
        indexOut = [indexOut, outputDirection+6*(i-1)];
    end
    for i=1:nNodesIn
        indexIn = [indexIn, inputDirection+6*(i-1)];
    end

    inputDof = inputDofNode(indexIn);
    outputDof = outputDofNode(indexOut);
    
    


    % calculation
    [M,C,G,K] = obj.rotorsystem.assemble_system_matrices(rpm);
    D = C + G*rpm/60*2*pi;
    H = mck2frf(f,M,D,K,inputDof,outputDof,type); % AbraVibe
    
    obj.f = f;
    obj.H = H;
    obj.type = type;
    obj.inputPosition = inPos;
    obj.outputPosition = outPos;

    
    obj.make_unit_from_type;
    obj.make_descriptions_for_FRF(inputNode,outputNode,inputDirection,outputDirection)
    
end