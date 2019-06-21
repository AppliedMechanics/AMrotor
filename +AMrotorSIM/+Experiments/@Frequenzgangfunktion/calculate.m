function [f,H] = calculate(obj,f,inPos,outPos,type,rpm)
    inNode = obj.rotorsystem.rotor.get_node_no(inPos);
    outNode = obj.rotorsystem.rotor.get_node_no(outPos);
    
    inDof = obj.rotorsystem.rotor.get_dof_no(inNode);
    outDof = obj.rotorsystem.rotor.get_dof_no(outNode);
    
    [M,C,G,K] = obj.rotorsystem.assemble_system_matrices(rpm);
    D = C + G*rpm/60*2*pi;
    H = mck2frf(f,M,D,K,inDof,outDof,type); % AbraVibe
    
    obj.f = f;
    obj.H = H;
    obj.type = type;
    obj.inputPosition = inPos;
    obj.outputPosition = outPos;
    
end