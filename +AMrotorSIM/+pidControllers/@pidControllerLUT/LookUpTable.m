function [ outputMatrix ] = LookUpTable( self, rpmTable, inputCell, rpmCurrent ) 
% Assembles the desired table (from Config-file) for a controller characterized by a LUT
%
%    :param rpmTable: Rpm values of LUT
%    :type rpmTable: vector
%    :param inputCell: Corresponding values of interest
%    :type inputCell: cell
%    :param rpmCurrent: Rotation speed (for interpolation)
%    :type rpmCurrent: double
%    :return: Desired ouput matrix 

% structure of inputs and outputs
%
% rpmTable = 1 x Nrpm array
% inputCell = 6 x 6 cell
% a single cell of inputCell is an array with Nrpm entries for every
% rpm-step: inputCell{i,j} = Nrpm x 1 array
% rpmCurrent = 1x1 current rpm-step
%
% outputMatrix = 6 x 6 matrix for rpmCurrent
%
% Licensed under GPL-3.0-or-later, check attached LICENSE file

outputMatrix = zeros(6,6);
for i = 1:6
    for j = 1:6
        if isempty(inputCell{i,j}) %allows slim tables, only interesting coefficiens are stored
            outputMatrix(i,j)=0;
        else
            outputMatrix(i,j) = interp1(rpmTable, inputCell{i,j}, rpmCurrent, 'linear');
        end
    end
end
outputMatrix = sparse(outputMatrix);
% dof-order: ux,uy,uz,psix,psiy,psiz



if rpmCurrent > max(rpmTable)
    warning(['Extrapolation of Component-Coefficients from Look-Up-Table ',... 
            'at rotational speed of more than max(Table.rpm)=',...
            num2str(max(rpmTable)),'. ',...
            'Results may be inaccurate!']);
end
end

