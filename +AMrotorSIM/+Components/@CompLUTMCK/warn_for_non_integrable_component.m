% Licensed under GPL-3.0-or-later, check attached LICENSE file

function warn_for_non_integrable_component(self)
% Displays a warning message and asks for further action
%
%    :return: Warning message

wrnMsgGerman = ['Achtung! Es wurde eine Komponente als Kennfeld vorgegeben. ',...
    'Dies kann unerw�nschte Effekte in der Zeitintegration bedeuten. Die ',...
    'Koeffizienten bedeuten eine Linearisierung um den Arbeitspunkt. ',...
    'Evtl. wollen Sie die Komponente als load einbinden, falls verf�gbar, '...
    'womit es als dynamische Kraft, welche in jedem Zeitschritt neu ',...
    'berechnet wird, eingebunden wird.'];
wrnMsg = ['Attention! You specified a Component (name = ''',self.name,''') as a look up table. ',...
    'This may cause unexpected results in the time integration. The ',...
    'component coefficients are a linearization around the operating point. ',... 
    'You may want to include the componen as a load, if available, which '...
    'is recalculated in every time step and integrated as a dynamic force.'];

warning(wrnMsg);

promptGerman = 'Wollen Sie die Zeitintegration trotzdem fortsetzen? [y/n]   ';
prompt = 'Do you want to continue the time integration anyway? [y/n]   ';

selection = input(prompt,'s');

if ~strcmp(selection,'y')
    error('Aborted time integration, because of problematic look up table-component.');
end

end

