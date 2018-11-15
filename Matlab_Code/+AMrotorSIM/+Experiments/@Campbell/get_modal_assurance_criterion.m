function mac = get_modal_assurance_criterion(obj, v1, v2)
% get the modal assurance criterion between 2 vectors

mac = abs((v1'*v2))^2 / ( (v1'*v1) * (v2'*v2) );

end

