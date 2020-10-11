% Licensed under GPL-3.0-or-later, check attached LICENSE file

function [ output ] = LookUpTable( self, rpmTable, inputCell, rpmCurrent )
% Includes parameters (M, C, K) from LUT into CompLUTMCK object with interpolation
%
%    :param rpmTable: Rpm values of LUT
%    :type rpmTable: vector
%    :param inputCell: Corresponding values of interest (M, C or K)
%    :type inputCell: cell
%    :param rpmCurrent: Rotation speed of interest (for interpolation)
%    :type rpmCurrent: double
%    :return: Desired ouput matrix (M, C or K)

% structure of inputs and outputs
%
% displacement = 1 x Ndisplacment array
% current = 1 x Ncurrent array
% force = Ndisplacemet x Ncurrent
%
% outputMatrix = 6 x 6 matrix for rpmCurrent

output = zeros(6,6);
for i = 1:6
    for j = 1:6
        if isempty(inputCell{i,j}) %allows slim tables, only interesting coefficiens are stored
            output(i,j)=0;
        else
            output(i,j) = interp1(rpmTable, inputCell{i,j}, rpmCurrent, 'linear');
        end
    end
end
output = sparse(output);
% dof-order: ux,uy,uz,psix,psiy,psiz



if rpmCurrent > max(rpmTable)
    warning(['Extrapolation of Component-Coefficients from Look-Up-Table ',... 
            'at rotational speed of more than max(Table.rpm)=',...
            num2str(max(rpmTable)),'. ',...
            'Results may be inaccurate!']);
end
end

