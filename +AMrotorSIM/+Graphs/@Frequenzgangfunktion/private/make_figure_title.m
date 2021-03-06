function titleStr = make_figure_title(obj)
% Provides the title of the analysis as figure title
%
%    :return: Figure title

% Licensed under GPL-3.0-or-later, check attached LICENSE file

titleStr = obj.experimentFRF.name;
title(titleStr)
end